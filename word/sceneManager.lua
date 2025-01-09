G = require "scenes/game"
R = require "scenes/results"
E = require "scenes/settings"
T = require "scenes/title"
P = require "scenes/splash"
O = require "scenes/overworld"
L = require "scenes/levelSelect"
H = require "scenes/help"
V = require "scenes/saves"

S = {}

local currentLevel

function S.load()

    currentLevel = nil

    if isDebug then
        currentScene = scenes.GAME
        currentLevel = 1
    end

    G.load()
    R.load()
    E.load()
    T.load()
    P.load()
    O.load()
    L.load()
    H.load()
    V.load()

end

function S.update()

    if currentScene == scenes.SPLASH then
        P.update()
    elseif currentScene == scenes.TITLE then
        T.update()
    elseif currentScene == scenes.SAVES then
        V.update()
    elseif currentScene == scenes.OVERWORLD then
        O.update()
    elseif currentScene == scenes.LEVELSELECT then
        L.update()
    elseif currentScene == scenes.GAME then
        G.update(currentLevel)
    elseif currentScene == scenes.RESULTS then
        R.update()
    elseif currentScene == scenes.SETTINGS then
        E.update()
    elseif currentScene == scenes.HELP then
        H.update()
    end

end

function S.draw()


    if currentScene == scenes.SPLASH then
        P.draw()
    elseif currentScene == scenes.TITLE then
        T.draw()
    elseif currentScene == scenes.SAVES then
        V.draw()
    elseif currentScene == scenes.OVERWORLD then
        O.draw()
    elseif currentScene == scenes.LEVELSELECT then
        L.draw()
    elseif currentScene == scenes.GAME then
        G.draw()
    elseif currentScene == scenes.RESULTS then
        R.draw()
    elseif currentScene == scenes.SETTINGS then
        E.draw()
    elseif currentScene == scenes.HELP then
        H.draw()
    end

end

function S.mousepressed(x, y, b)

    if currentScene == scenes.SPLASH then
        P.mousepressed(x, y, b)
    elseif currentScene == scenes.TITLE then
        T.mousepressed(x, y, b)
    elseif currentScene == scenes.SAVES then
        V.mousepressed(x, y, b)
    elseif currentScene == scenes.OVERWORLD then
        O.mousepressed(x, y, b)
    elseif currentScene == scenes.LEVELSELECT then
        L.mousepressed(x, y, b)
    elseif currentScene == scenes.GAME then
        G.mousepressed(x, y, b)
    elseif currentScene == scenes.RESULTS then
        R.mousepressed(x, y, b)
    elseif currentScene == scenes.SETTINGS then
        E.mousepressed(x, y, b)
    elseif currentScene == scenes.HELP then
        H.mousepressed(x, y, b)
    end

end

function S.mousemoved(x, y, dx, dy)

    if currentScene == scenes.SPLASH then
        P.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.TITLE then
        T.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.SAVES then
        V.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.OVERWORLD then
        O.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.LEVELSELECT then
        L.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.GAME then
        G.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.RESULTS then
        R.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.SETTINGS then
        E.mousemoved(x, y, dx, dy)
    elseif currentScene == scenes.HELP then
        H.mousemoved(x, y, dx, dy)
    end

end

function S.mousereleased(x, y, b)

    if currentScene == scenes.SPLASH then
        P.mousereleased(x, y, b)
    elseif currentScene == scenes.TITLE then
        T.mousereleased(x, y, b)
    elseif currentScene == scenes.SAVES then
        V.mousereleased(x, y, b)
    elseif currentScene == scenes.OVERWORLD then
        O.mousereleased(x, y, b)
    elseif currentScene == scenes.LEVELSELECT then
        L.mousereleased(x, y, b)
    elseif currentScene == scenes.GAME then
        G.mousereleased(x, y, b)
    elseif currentScene == scenes.RESULTS then
        R.mousereleased(x, y, b)
    elseif currentScene == scenes.SETTINGS then
        E.mousereleased(x, y, b)
    elseif currentScene == scenes.HELP then
        H.mousereleased(x, y, b)
    end

end

function S.keyreleased(key)

    if currentScene == scenes.SPLASH then
        P.keyreleased(key)
    elseif currentScene == scenes.TITLE then
        T.keyreleased(key)
    elseif currentScene == scenes.SAVES then
        V.keyreleased(key)
    elseif currentScene == scenes.OVERWORLD then
        O.keyreleased(key)
    elseif currentScene == scenes.LEVELSELECT then
        L.keyreleased(key)
    elseif currentScene == scenes.GAME then
        G.keyreleased(key)
    elseif currentScene == scenes.RESULTS then
        R.keyreleased(key)
    elseif currentScene == scenes.SETTINGS then
        E.keyreleased(key)
    elseif currentScene == scenes.HELP then
        H.keyreleased(key)
    end

end

return S