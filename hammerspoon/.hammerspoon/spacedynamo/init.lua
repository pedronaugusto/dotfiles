local modifiers = { "shift", "cmd" }

local function getSpaces()
    local screen = hs.screen.mainScreen()
    return hs.spaces.spacesForScreen(screen)
end

local function getAdjacentSpaces()
    local spaces = getSpaces()
    local currentSpace = hs.spaces.focusedSpace()
    local currentIndex = hs.fnutils.indexOf(spaces, currentSpace)
    local previousIndex = currentIndex - 1
    if previousIndex < 1 then
        previousIndex = #spaces
    end
    local nextIndex = currentIndex + 1
    if nextIndex > #spaces then
        nextIndex = 1
    end
    return previousIndex, nextIndex
end

local function switchToSpace(index)
    local spaces = getSpaces()
    local space = spaces[index]
    hs.spaces.gotoSpace(space)
end

for i=1,9 do
    hs.hotkey.bind(modifiers, tostring(i), function()
        switchToSpace(i)
    end)
end

hs.hotkey.bind(modifiers, "left", function()
    local previousIndex, _ = getAdjacentSpaces()
    switchToSpace(previousIndex)
end)

hs.hotkey.bind(modifiers, "right", function()
    local _, nextIndex = getAdjacentSpaces()
    switchToSpace(nextIndex)
end)
