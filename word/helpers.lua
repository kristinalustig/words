H = {}

local wordList

function H.loadWordList()

    wordList = {}

    for line in love.filesystem.lines("assets/words.txt") do
        table.insert(wordList, line)
    end

end

function H.loadLevelGoal(level)

    local temp = {
        title = "Test title for testing",
        wordCount = nil,
        scoreMin = 5,
        cellsOffLimits = nil,
        cellsMustCover = nil,
        mustTouchEdgesHor = false,
        mustTouchEdgesVer = false,
        mustHaveLadderShape = false,
        mustHaveTimelineShape = false,
        noRepeatedLetters = false,
        wordLengthMin = nil,
        wordLengthMax = nil,
        wordLetterPositionVal = nil,
        wordLetterPosition = nil,
        wordContainsString = nil,
        wordContainsCharOnceVal = nil,
        mustBeAbcOrder = false,
        mustBeReverseAbcOrder = false,
        mustUseAllLetters = false
    }

    return temp

end

function H.loadLetterBank(level)

    local temp = {
        {
            txt = "A",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "B",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "C",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "D",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "E",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "F",
            x = 0,
            y = 0,
            used = false
        },
        {
            txt = "G",
            x = 0,
            y = 0,
            used = false
        }
    }

    return temp

end

function H.getMouseOverlap(tx, ty, tw, th, x, y)

    return (x >= tx and x <= tx + tw and y >= ty and y <= ty + th)

end

function H.getWordValidity(word)

    for k, v in ipairs(wordList) do
        if string.lower(word) == v then
            return true
        end
    end

    return false

end

function H.getLetterValue(s)

    if s == "A" or s == "E" or s == "I" or s == "O" or s == "U" or s == "S" or s == "T" or s == "L" or s == "N" or s == "R" then
        return 1
    elseif s == "J" or s == "K" or s == "Q" or s == "V" or s == "X" or s == "Z" then
        return 3
    else
        return 2
    end

end

return H