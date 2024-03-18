local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- General Configuration
config.color_scheme = 'rose-pine'
config.font_size = 16.0
config.macos_window_background_blur = 30
config.window_background_opacity = 0.97
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = 0,
	bottom = 0,
}
config.window_frame = {
	font_size = 16.0,
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	active_titlebar_bg = "rgba(25, 23, 36,0.97)",
	inactive_titlebar_bg = "rgba(25, 23, 36,0.97)",
}
config.colors = {
	tab_bar = {
		background = "rgba(25, 23, 36,0.97)",
		inactive_tab_edge = "rgba(25, 23, 36,0.97)",
		active_tab = {
			bg_color = "rgba(25, 23, 36,0.97)",
			fg_color = "#ebbcba",
		},
		inactive_tab = {
			bg_color = "rgba(25, 23, 36,0.97)",
			fg_color = "#6e6a86",
		},
		inactive_tab_hover = {
			bg_color = "rgba(25, 23, 36,0.97)",
			fg_color = "#9ccfd8",
			italic = true,
		},
		new_tab = {
			bg_color = "rgba(25, 23, 36,0.97)",
			fg_color = "#6e6a86",
		},
		new_tab_hover = {
			bg_color = "rgba(25, 23, 36,0.97)",
			fg_color = "#9ccfd8",
			italic = true,
		},
	},
	split = "#ebbcba",
}
config.inactive_pane_hsb = {
	saturation = 1,
	brightness = 1,
}

-- Keys
config.leader = { key = "a", mods = "CMD", timeout_milliseconds = 1500 }
config.keys = {
	{ key = "a", mods = "LEADER|CMD", action = act.SendKey({ key = "a", mods = "CMD" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- Tab Navigator
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- Key Tables
config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

return config
