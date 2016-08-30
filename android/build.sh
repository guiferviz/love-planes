export ANDROID_SDK=/home/gazpacho4you/Documentos/android/sdk
export ANDROID_NDK=/home/gazpacho4you/Documentos/android/ndk
export ANDROID_SWT=/usr/share/java
export ANDROID_HOME=${ANDROID_SDK}
export PATH=$PATH:$ANDROID_SDK/tools:$ANDROID_NDK
ant clean && ant debug
