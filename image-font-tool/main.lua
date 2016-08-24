
function love.load(args)
    if #args == 2 and (args[2] == "-h" or args[2] == "--help") then
        print "love . INPUT_FILENAME OUTPUT_FILENAME [--add-space SIZE]"
        print ""
        print "INPUT_FILENAME: Input image."
        print "OUTPUT_FILENAME: Output image (saved on the love application data directory)."
        print ""
        print ""
        print ""
        print "Paint all non-alpha columns of the input image in black."
        print "Use the parameter '--add-space' to add automatically an space char of size SIZE."
    elseif #args >= 3 then
        local filename = args[2]
        local output_filename = args[3]
        local img = love.graphics.newImage(filename)
        local w = img:getWidth()
        local h = img:getHeight()
        local addSpace = false

        -- Create canvas.
        if #args >= 5 and args[4] == "--add-space" then
            print "Adding space char..."
            space = tonumber(args[5])
            canvas = love.graphics.newCanvas(w + space + 1, h)
            addSpace = true
        else
            canvas = love.graphics.newCanvas(w, h)
        end

        love.graphics.setCanvas(canvas)
        love.graphics.draw(img)
        local data = canvas:newImageData()
        for x = 1, w do
            local void = true
            for y = 1, h do
                r, g, b, a = data:getPixel(x - 1, y - 1)

                if a > 0 then
                    void = false
                    break
                end
            end

            if void then
                for y = 1, h do
                    data:setPixel(x - 1, y - 1, 0, 0, 0, 255)
                end
            end
        end
        if addSpace then
            for y = 1, h do
                data:setPixel(w + space, y - 1, 0, 0, 0, 255)
            end
        end
        data:encode('png', output_filename)
        love.graphics.setCanvas()

        print "Output saved to the application data directory."
        print "In Linux systems: ~/.local/share/love/image-font-tool"
    else
        print "Error parameters: love . INPUT_FILENAME OUTPUT_FILENAME"
    end
    
    love.event.quit()
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(canvas)
end
