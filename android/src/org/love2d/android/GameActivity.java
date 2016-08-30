
package org.love2d.android;


import org.libsdl.app.SDLActivity;
import java.util.List;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Vibrator;
import android.util.Log;
import android.util.DisplayMetrics;
import android.view.*;
import android.content.pm.PackageManager;


public class GameActivity extends SDLActivity
{

    private static DisplayMetrics metrics = new DisplayMetrics();
    private static String gamePath = "";
    private static Context context;
    private static Vibrator vibrator = null;
    private static boolean immersiveActive = true;


	@Override 
	protected String[] getLibraries()
	{
		return new String[] {
				"gnustl_shared",
				"mpg123",
				"openal",
				"love"
		};
	}

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
    	Log.d("GameActivity", "started");
 
      	context = this.getApplicationContext();
			
		String permission = "android.permission.VIBRATE";
		int res = context.checkCallingOrSelfPermission(permission);
		if (res == PackageManager.PERMISSION_GRANTED)
		{
			vibrator = (Vibrator) context.getSystemService(
					Context.VIBRATOR_SERVICE);
		}
		else
		{
			Log.d("GameActivity",
				  "Vibration disabled: could not get vibration permission.");
		}

		handleIntent(this.getIntent());

		super.onCreate(savedInstanceState);
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		
		fullScreen();
    }

    @Override
    protected void onNewIntent (Intent intent) {
      Log.d("GameActivity", "onNewIntent() with " + intent);
      handleIntent (intent);
      resetNative();
      startNative();
    };

    protected void handleIntent (Intent intent) {
      Uri game = intent.getData();
      if (game != null) {
        if (game.getScheme().equals ("file")) {
          Log.d("GameActivity", "Received intent with path: " + game.getPath());

          // If we were given the path of a main.lua then use its
          // directory. Otherwise use full path.
          List<String> path_segments = game.getPathSegments();
          if (path_segments.get(path_segments.size() - 1).equals("main.lua")) {
            gamePath = game.getPath().substring(0, game.getPath().length() - "main.lua".length());
          } else {
            gamePath = game.getPath();
          }
        } else {
          copyGameToCache (game);
        }

        Log.d("GameActivity", "new gamePath: " + gamePath);
      }
    };

    @Override
    protected void onDestroy()
    {
		if (vibrator != null)
		{
			Log.d("GameActivity", "Cancelling vibration");
			vibrator.cancel();
		}
		super.onDestroy();
    }

    @Override
    protected void onPause()
    {
    	if (vibrator != null)
    	{
			Log.d("GameActivity", "Cancelling vibration");
			vibrator.cancel();
		}
    	
    	super.onPause();
    }

    @Override
    public void onResume()
    {
    	super.onResume();
    	
    	fullScreen();
    }

    public boolean getImmersiveMode()
    {
    	return immersiveActive;
    }
    
    public void setImmersiveMode(boolean immersive)
    {
    	immersiveActive = immersive;
    }
    
    public static String getGamePath()
    {
    	Log.d ("GameActivity", "called getGamePath(), game path = " + gamePath);
    	return gamePath;
    }

    public static DisplayMetrics getMetrics()
    {
        return metrics;
    }

    public static void vibrate (double seconds)
    {
    	if (vibrator != null)
    	{
			vibrator.vibrate((long) (seconds * 1000.));
		}
    }

    public static void openURL(String url)
    {
    	Log.d ("GameActivity", "opening url = " + url);
    	Intent i = new Intent(Intent.ACTION_VIEW);
    	i.setData(Uri.parse(url));
    	i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    	context.startActivity(i);
    }
  
    void copyGameToCache (Uri sourceuri)
    {
      String destinationFilename = this.getCacheDir().getPath()+"/downloaded.love";
      gamePath = destinationFilename;

      BufferedOutputStream bos = null;
      try {
        bos = new BufferedOutputStream(new FileOutputStream(destinationFilename, false));
      } catch (IOException e) {
        Log.d ("GameActivity", "Could not open destination file:" + e.getMessage());
      }

      int chunk_read = 0;
      int bytes_written = 0;

      BufferedInputStream bis = null;
      if (sourceuri.getScheme().equals("content")) {
        try {
          bis = new BufferedInputStream(getContentResolver().openInputStream(sourceuri));
        } catch (IOException e) {
          Log.d ("GameActivity", "Could not open game file:" + e.getMessage());
        }
      } else {
        Log.d ("GameActivity", "Unsupported scheme: " + sourceuri.getScheme());
      }

      if (bis != null) {
        // actual copying
        try {
          byte[] buf = new byte[1024];
          chunk_read = bis.read(buf);
          do {
            bos.write(buf, 0, chunk_read);
            bytes_written += chunk_read;
            chunk_read = bis.read(buf);        
          } while(chunk_read != -1);
        } catch (IOException e) {
          Log.d ("GameActivity", "Copying failed:" + e.getMessage());
        } 
      }

      // close streams
      try {
        if (bis != null) bis.close();
        if (bos != null) bos.close();
      } catch (IOException e) {
        Log.d ("GameActivity", "Copying failed: " + e.getMessage());
      }

      Log.d("GameActivity", "Copied " + bytes_written + " bytes");
    }
    
    @SuppressLint("InlinedApi")
	private void fullScreen()
    {
        View decorView = getWindow().getDecorView();
        int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;

        if (Build.VERSION.SDK_INT >= 16)
        {
            uiOptions |= View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_FULLSCREEN;
        }
        if (Build.VERSION.SDK_INT >= 19)
        {
            uiOptions |= View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
        }

        decorView.setSystemUiVisibility(uiOptions);
    }
}
