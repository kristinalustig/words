push = require "ext/push"
local S = require "sceneManager"

local gameWidth, gameHeight = 800, 640 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

windowHeight = windowHeight - 100
windowWidth = windowHeight * (800/640)

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, highdpi = true, resizable = true})

scenes = {
    SPLASH = 1,
    TITLE = 2,
    SAVES = 3,
    OVERWORLD = 4,
    LEVELSELECT = 5,
    GAME = 6,
    RESULTS = 7,
    SETTINGS = 8,
    HELP = 9
}

currentScene = scenes.SPLASH

lm = love.mouse
lg = love.graphics
lk = love.keyboard
la = love.audio

isDebug = true

function love.load()

    S.load()

end

function love.update()

    S.update()

end

function love.draw()

    push:start()

    S.draw()

    if isDebug then
        local x, y = push:toGame(lm.getX(), lm.getY())
        if x ~= nil and y ~= nil then 
          lg.printf(math.floor(x)..", ".. math.floor(y), x+10,y, 200, "left")
        end
      end

    push:finish()

end

function love.mousepressed(x, y, b)
    local x, y = push:toGame(x, y)
    S.mousepressed(x, y, b)
end

function love.mousemoved(x, y, dx, dy)
    local x, y = push:toGame(x, y)
    S.mousemoved(x, y, b)
end

function love.mousereleased(x, y, b)
    local x, y = push:toGame(x, y)
    S.mousereleased(x, y, b)
end

function love.keyreleased(key, _)
    local x, y = push:toGame(x, y)
    S.keyreleased(key)
end

function love.resize(w, h)
    return push:resize(w, h)
  end