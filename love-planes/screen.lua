
--[[
    Screen.
    Makes your game resolution independent of the screen.
--]]


Screen = {}

function Screen.set(game_width, game_height, mode)
    mode = mode or "scale"

    local window_width  = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    local window_ratio = window_width / window_height
    local game_ratio   = game_width / game_height

    if mode == "fill" then
        Screen.scale_x =  window_width / game_width
        Screen.scale_y = window_height / game_height
        Screen.translate_x, Screen.translate_y = 0, 0
        Screen.border_width, Screen.border_height = 0, 0
        Screen.border_x, Screen.border_y = 0, 0
    elseif mode == "scale" then
        local scale

        if window_ratio < game_ratio then
            scale = window_width / game_width
            Screen.translate_x, Screen.translate_y = 0, (window_height - (game_height * scale)) / 2
            Screen.border_width = window_width
            Screen.border_height = Screen.translate_y
            Screen.border_x = 0
            Screen.border_y = Screen.translate_y + game_height * scale
        elseif window_ratio > game_ratio then
            scale = window_height / game_height
            Screen.translate_x, Screen.translate_y = (window_width - (game_width * scale)) / 2, 0
            Screen.border_width = Screen.translate_x
            Screen.border_height = window_height
            Screen.border_x = Screen.translate_x + game_width * scale
            Screen.border_y = 0
        else
            Screen.translate_x, Screen.translate_y = 0, 0
            scale = window_width / game_width
            Screen.border_width, Screen.border_height = 0, 0
            Screen.border_x, Screen.border_y = 0, 0
        end

        Screen.scale_x, Screen.scale_y = scale, scale
    else
        print("ERROR: not know screen mode.")
    end

    Screen.window_width  = window_width
    Screen.window_height = window_height

    Screen.game_width  = game_width
    Screen.game_height = game_height
end

--[[
    Transforms screen geometry.
    Call this at the beginning of love.draw().
--]]
function Screen.transform()
    love.graphics.push()
    love.graphics.translate(Screen.translate_x, Screen.translate_y)
    love.graphics.scale(Screen.scale_x, Screen.scale_y)
end

--[[
    Transforms screen coordinates to game coordinates.
--]]
function Screen.transformCoordinates(x, y)
    return (x - Screen.translate_x) / Screen.scale_x,
           (y - Screen.translate_y) / Screen.scale_y
end

--[[
    Draws rectangles at the top and bottom of the screen to ensure
    proper aspect ratio. Be aware: change the selected color.
    Call this at the end of love.draw().
--]]
function Screen.drawBorders(color)
    color = color or {0, 0, 0, 255}  -- Default: black

    love.graphics.pop()
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, Screen.border_width, Screen.border_height)
    love.graphics.rectangle("fill", Screen.border_x, Screen.border_y,
                                    Screen.border_width, Screen.border_height)
end

