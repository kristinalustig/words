G = {}

local H = require "helpers"

--assets declared here
local bg

--variables declared here
local currentLevel
local currentLevelGoal
local letterBank
local levelTitle
local levelScore
local lbUnusedCount
local letterGrid
local actionHistory
local wordCount
local gridScore
local isBoardValid
local validText

--sizing stuff declared here
local lbStartX
local lbStartY
local lbIncr
local lbSize

--
--
-- LOAD
--
--
--
function G.load()

    --assets
    bg = lg.newImage("assets/game/bg.png")

    --vars
    currentLevel = nil
    letterBank = {}
    levelTitle = ""
    lbUnusedCount = 0
    currentlyHeld = nil
    actionHistory = {}
    currentLevelGoal = {}
    isBoardValid = false
    validText = ""

    --sizing
    lbStartX = 32
    lbStartY = 64
    lbIncr = 40
    lbSize = 32

    --first-time inits
    H.loadWordList()
    
end

--
--
-- UPDATE
--
--
--
function G.update(level)

    --are we starting a fresh level?
    if level ~= currentLevel then
        currentLevel = level
        currentLevelGoal = H.loadLevelGoal(currentLevel)
        letterBank = H.loadLetterBank(currentLevel)
        lbUnusedCount = #letterBank
        levelTitle = currentLevelGoal.title
        levelScore = 0
        letterGrid = LoadFreshLetterGrid()
    end

    UpdateLetterBank()

    UpdateGridStatus()

end

--
--
--
-- DRAW
--
--
function G.draw()

    lg.draw(bg, 0, 0, 0, .5, .5)
    lg.printf("Score: "..gridScore, 592, 16, 300, "left")
    lg.printf("Letter Bank: (".. lbUnusedCount .. " left)", 32, 16, 200, "left")
    lg.printf(levelTitle, 32, 592, 400, "left")
    DrawLetterBank()

    DrawGridHighlights()

    if isDebug then
        for kp, vp in ipairs(letterGrid) do
            for k, v in ipairs(vp) do
                lg.printf(v.row .. ", " .. v.col, v.x, v.y, 32, "left")
            end
        end
    end

    if isBoardValid then
        lg.printf("BOARD VALID!", 32, 592, 400, "right")
    else
        lg.printf(validText, 32, 592, 400, "right")
    end

end

--
--
-- INPUTS
--
--
--
function G.mousepressed(x, y, b)

    if x == nil or y == nil then return end

    --place or return currently held square
    if currentlyHeld then
        if b == 2 then
            currentlyHeld.used = false
            currentlyHeld = nil
            return
        elseif b == 1 then
            local sq = GetPlacementSquare(x, y)
            if sq ~= nil and sq.val == nil then
                currentlyHeld.x = sq.x
                currentlyHeld.y = sq.y
                currentlyHeld.row = sq.row
                currentlyHeld.col = sq.col
                sq.val = currentlyHeld.txt
                currentlyHeld = nil
                return
            end
        end
    end

    --pick up square if none held, or return to bank if right click
    for k, v in ipairs(letterBank) do
        if H.getMouseOverlap(v.x, v.y, lbSize, lbSize, x, y) then
            --if the item is placed on the board
            if v.used == true and currentlyHeld == nil then
                letterGrid[v.row][v.col].val = nil
                letterGrid[v.row][v.col].isValid = nil
                v.row = nil
                v.col = nil
                --pick it up with left click
                if b == 1 then
                    currentlyHeld = v
                --put it back in bank with right click
                elseif b == 2 then
                    v.used = false
                end
                return
            elseif currentlyHeld == nil then
                v.used = true
                currentlyHeld = v
                v.x = x
                v.y = y
                return
            end
        end
    end

end

function G.mousemoved(x, y, dx, dy)

end

function G.mousereleased(x, y, b)

end

function G.keyreleased(key)

end

--
-- 
-- PRIVATE
--
--
--
function UpdateLetterBank()

    local lbx = lbStartX
    local lby = lbStartY
    local lbCount = 1
    for k, v in ipairs(letterBank) do
        if v.used == false then
            v.x = lbx
            v.y = lby
            if lbCount % 5 == 0 then
                lby = lby + lbIncr
                lbx = lbStartX
            else
                lbx = lbx + lbIncr
            end
            lbCount = lbCount + 1
        elseif v == currentlyHeld then
            v.x, v.y = push:toGame(lm.getX(), lm.getY())
        end
    end
end

function UpdateGridStatus()
    wordCount = 0
    gridScore = 0

    --check each row for valid words
    for r = 1, 16, 1 do
        local c = 1
        while c <= 15 do
            if letterGrid[r][c].val ~= nil then
                local c2 = GetWordEndpoint(r, c, "hor")
                if c2 - c >= 1 then
                    CheckAndMarkValidity(r, r, c, c2)
                    c = c2 + 1
                else
                    letterGrid[r][c].isValid = nil
                    c = c + 1
                end
            else
                letterGrid[r][c].isValid = nil
                c = c + 1
            end
        end
    end

    --check each col for valid words
    for c = 1, 16, 1 do
        local r = 1
        while r <= 15 do
            if letterGrid[r][c].val ~= nil then
                local r2 = GetWordEndpoint(r, c, "ver")
                if r2 - r >= 1 then
                    CheckAndMarkValidity(r, r2, c, c)
                end
                r = r2 + 1
            else
                letterGrid[r][c].isValid = nil
                r = r + 1
            end
        end
    end


    --check overall board state
    isBoardValid, validText = CheckBoardState()

end

function CheckBoardState()

    local c = currentLevelGoal

    if c.scoreMin > gridScore then
        return false, "Score not high enough"
    end

    if c.cellsOffLimits ~= nil then
        for k, v in ipairs(c.cellsOffLimits) do
            if letterGrid[v.r][v.c].val ~= nil then
                return false
            end
        end
    end

    if c.cellsMustCover ~= nil then
        for k, v in ipairs(c.cellsOffLimits) do
            if letterGrid[v.r][v.c].val == nil then
                return false
            end
        end
    end

    if c.musttouchEdgesHor == true then
    end

    if c.musttouchEdgesVer == true then
    end
 
    if c.mustHaveLadderShape == true then
    end

    if c.mustHaveTimelineShape == true then
    end

    if c.noRepeatedLetters == true then
    end

    if c.wordLengthMin ~= nil then
    end

    if c.wordLengthMax ~= nil then
    end

    if c.wordLetterPositionVal ~= nil then
    end

    if c.wordContainsString ~= nil then
    end

    if c.wordContainsCharOnceVal ~= nil then
    end

    if c.mustBeAbcOrder == true then
    end

    if c.mustBeReverseAbcOrder == true then
    end

    if c.mustUseAllLetters == true then
    end

    if AllWordsConnected() then
        return true, "connected"
    else
        return false, "All words not connected"
    end

end

function AllWordsConnected()

    local floodStartC = 1
    local floodStartR = 1
    local pickedStart = false

    local usedCount = 0
    for kp, vp in ipairs(letterGrid) do
        for k, v in ipairs(vp) do
            v.checked = false
            if v.val ~= nil then
                usedCount = usedCount + 1
                if not pickedStart then
                    floodStartC = v.col
                    floodStartR = v.row
                end
            end
        end
    end

    FloodAll(floodStartR, floodStartC)

    local flooded = 0
    for kp, vp in ipairs(letterGrid) do
        for k, v in ipairs(vp) do
            if v.checked then
                flooded = flooded + 1
            end
        end
    end

    return flooded == usedCount

end

function FloodAll(r, c)

    if r < 1 or r > 16 or c < 1 or c > 16 then
        return
    end

    if letterGrid[r][c].val == nil or letterGrid[r][c].checked then
        return
    end
    
    letterGrid[r][c].checked = true

    FloodAll(r+1, c)
    FloodAll(r, c+1)
    FloodAll(r-1, c)
    FloodAll(r, c-1)

end

function CheckAndMarkValidity(r1, r2, c1, c2)

    local word = ""
    for r = r1, r2, 1 do
        for c = c1, c2, 1 do
            word = word .. letterGrid[r][c].val
        end
    end

    local isValid = H.getWordValidity(word)
    for r = r1, r2, 1 do
        for c = c1, c2, 1 do
            letterGrid[r][c].isValid = isValid
            if isValid then
                gridScore = gridScore + H.getLetterValue(letterGrid[r][c].val)
            end
        end
    end

    if isValid then
        wordCount = wordCount + 1
    end

end

function GetWordEndpoint(r, c, dir)

    if dir == "hor" then
        local cont = true
        while cont == true do
            if c > 16 then
                cont = false
                break
            end
            if letterGrid[r][c+1].val ~= nil then
                c = c + 1
            else
                cont = false
            end
        end
        return c 
    end

    if dir == "ver" then
        local cont = true
        while cont == true do
            if r > 16 then
                cont = false
                break
            end
            if letterGrid[r+1][c].val ~= nil then
                r = r + 1
                if r > 16 then
                    cont = false
                end
            else
                cont = false
            end
        end
        return r
    end

end



function DrawLetterBank()

    for k, v in ipairs(letterBank) do
        lg.rectangle("fill", v.x, v.y, 32, 32)
        lg.setColor(1, 0, 1)
        lg.printf(v.txt, v.x, v.y, 32, "center")
        lg.setColor(1, 1, 1)
    end

end

function DrawGridHighlights()

    for kp, vp in ipairs(letterGrid) do
        for k, v in ipairs(vp) do
            if v.isValid == true then 
                lg.setColor(0, 1, 0)
            elseif v.isValid == false then
                lg.setColor(1, 0, 0)
            else
                lg.setColor(1, 1, 1)
            end
            lg.setLineWidth(2)
            lg.rectangle("line", v.x, v.y, lbSize, lbSize)
        end
    end

    lg.setColor(1, 1, 1)

end

function LoadFreshLetterGrid()

    local temp = {}

    local xStart = 256
    local yStart = 64
    local incr = 32

    for i=1, 16, 1 do
        table.insert(temp, {})
        for j=1, 16, 1 do
            table.insert(temp[i], {
                row = i,
                col = j,
                x = xStart + ((j-1)*incr),
                y = yStart + ((i-1)*incr),
                val = nil,
                isValid = nil
            })
        end
    end

    return temp

end

function GetPlacementSquare(x, y)
    for kp, vp in ipairs(letterGrid) do
        for k, v in ipairs(vp) do
            if H.getMouseOverlap(v.x, v.y, lbSize, lbSize, x, y) then
                return v
            end
        end
    end
    return nil
end

return G