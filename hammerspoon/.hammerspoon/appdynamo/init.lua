-- Function to open an application
local function open_app(name)
    hs.application.launchOrFocus(name)
    if name == 'Finder' then
        hs.appfinder.appFromName(name):activate()
    end
end

-- Read the config file
local config = hs.json.read("appdynamo/config.json")

local leadermodifier = config.leadermodifier
local leaderkey = config.leaderkey
local hotkeys = config.hotkeys

-- Create a key map for hotkeys
local keymap = {}
for key, app in pairs(hotkeys) do    keymap[singleKey(key, app)] = function() open_app(app) end
end

-- Bind the hotkeys
hs.hotkey.bind({leadermodifier}, leaderkey, spoon.RecursiveBinder.recursiveBind(keymap))