
function love.load(args)
    if #args == 2 then
        print("Error parameters: love . INPUT_FILENAME OUTPUT_FILENAME")
        love.event.quit()
    else

        local filename = args[2]
        local output_filename = args[3]
        local img = love.graphics.newImage(filename)
        local w = img:getWidth()
        local h = img:getHeight()

        canvas = love.graphics.newCanvas(w, h)

        love.graphics.setCanvas(canvas)
        love.graphics.draw(img)
        local data = canvas:newImageData()
        for x = 1, w do
            local void = true
            for y = 1, h do
                r, g, b, a = data:getPixel(x - 1, y - 1)

                if a >= 128 then
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
        data:encode('png', output_filename)


        love.graphics.setCanvas()
        --love.event.quit()
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(canvas)
end
