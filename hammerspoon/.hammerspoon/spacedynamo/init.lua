-- Get the main screen
local function getScreen()
    return hs.screen.mainScreen()
end

-- Get all spaces for the screen
local function getSpaces()
    local screen = getScreen()
    return hs.spaces.spacesForScreen(screen)
end

-- Get the previous and next space indices
local function getAdjacentSpaces()
    local spaces = getSpaces()
    local currentSpace = hs.spaces.focusedSpace()
    local currentIndex = hs.fnutils.indexOf(spaces, currentSpace)
    local previousIndex = currentIndex > 1 and currentIndex - 1 or currentIndex
    local nextIndex = currentIndex < #spaces and currentIndex + 1 or currentIndex
    return previousIndex, nextIndex
end

-- Switch to a specific space
local function switchToSpace(index)
    local spaces = getSpaces()
    local space = spaces[index]
    hs.spaces.gotoSpace(space)
end

-- Move the focused window to a specific space
local function moveWindowToSpace(index)
    local window = hs.window.focusedWindow()
    local spaces = getSpaces()
    local space = spaces[index]
    hs.spaces.moveWindowToSpace(window, space)
    hs.spaces.gotoSpace(space)
end

-- Create a new space and move the focused window to it
local function createAndMoveWindowToSpace()
    local window = hs.window.focusedWindow()
    local screen = getScreen()
    local spacesBefore = getSpaces()
    hs.spaces.addSpaceToScreen(screen)
    local spacesAfter = getSpaces()
    local space
    local A = {}
    for _, v in ipairs(spacesBefore) do
        A[v] = true
    end
    for _, v in ipairs(spacesAfter) do
        if A[v] == nil then
            space = v
        end
    end
    hs.spaces.moveWindowToSpace(window, space)
    hs.spaces.gotoSpace(space)
end

-- Delete the current space and switch to the previous space
local function deleteSpace(index)
    local spaceToDelete = hs.spaces.focusedSpace()
    switchToSpace(index)
    hs.timer.delayed.new(0.5, function()
        hs.spaces.removeSpace(spaceToDelete)
    end):start()
end

-- Read the configuration from a JSON file
local config = hs.json.read("spacedynamo/config.json")

local switchmodifiers = config.switchmodifiers
local movemodifiers = config.movemodifiers
local hotkeys = config.hotkeys

-- Bind hotkeys for switching and moving windows to spaces
for i = 1, 9 do
    hs.hotkey.bind(switchmodifiers, tostring(i), function()
        switchToSpace(i)
    end)
    hs.hotkey.bind(movemodifiers, tostring(i), function()
        moveWindowToSpace(i)
    end)
end

-- Bind hotkeys for moving windows to adjacent spaces
hs.hotkey.bind(movemodifiers, hotkeys.left, function()
    local previousIndex, _ = getAdjacentSpaces()
    moveWindowToSpace(previousIndex)
end)

hs.hotkey.bind(movemodifiers, hotkeys.right, function()
    local _, nextIndex = getAdjacentSpaces()
    moveWindowToSpace(nextIndex)
end)

-- Bind hotkey for creating a new space and moving the window to it
hs.hotkey.bind(movemodifiers, hotkeys.create, function()
    local _, nextIndex = getAdjacentSpaces()
    createAndMoveWindowToSpace(nextIndex)
end)

-- Bind hotkey for deleting the current space
hs.hotkey.bind(movemodifiers, hotkeys.delete, function()
    local previousIndex, _ = getAdjacentSpaces()
    deleteSpace(previousIndex)
end)

-- Bind hotkey for deleting the current space
hs.hotkey.bind(switchmodifiers, hotkeys.mc, function()
    hs.spaces.toggleMissionControl()
end)

    -- Bind hotkey for deleting the current space
hs.hotkey.bind(switchmodifiers, hotkeys.expose, function()
    hs.spaces.toggleAppExpose()
end)