local wezterm = require("wezterm")
local act = wezterm.action

return {

	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 16.0,
	macos_window_background_blur = 20,

	window_background_opacity = 0.95,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = act.ToggleFullScreen,
		},
		{
			key = "b",
			mods = "CMD",
			action = act.SendKey({ key = "b", mods = "CTRL" }),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
