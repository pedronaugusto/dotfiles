local function open_app(name)
    hs.application.launchOrFocus(name)
    if name == 'Finder' then
        hs.appfinder.appFromName(name):activate()
    end
end

local config = hs.json.read("appdynamo/config.json")
local modifiers = config.modifiers
local hotkeys = config.hotkeys
for key, app in pairs(hotkeys) do
    hs.hotkey.bind(modifiers, key, function()
        open_app(app)
    end)
end
