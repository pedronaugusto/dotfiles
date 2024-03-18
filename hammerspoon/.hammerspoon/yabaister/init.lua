-- Send message(s) to a running instance of yabai.
local function yabai(command)
    os.execute("/opt/homebrew/bin/yabai -m " .. command)
end

local config = hs.json.read("yabaister/config.json")

for _, object in ipairs(config) do
    local modifiers = object.modifiers
    local hotkeys = object.hotkeys

    for key, command in pairs(hotkeys) do
        hs.hotkey.bind(modifiers, key, function()
            yabai(command)
        end)
    end
end
