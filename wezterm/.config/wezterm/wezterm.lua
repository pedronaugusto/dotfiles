local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local direction_keys = {
	h = 'Left',
	j = 'Down',
	k = 'Up',
	l = 'Right',
}

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == 'true'
end

local function split_nav(resize_or_move, key)
  return wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 10 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end)
end

-- General Configuration
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'SF Mono'
config.font_size = 16.0
config.line_height = 1.5
config.macos_window_background_blur = 30
config.window_background_opacity = 0.92

config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.use_fancy_tab_bar = false
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = 0,
	bottom = 0,
}
config.window_frame = {
	font_size = 16.0,
	font = wezterm.font({ family = "SF Mono"}),
	active_titlebar_bg = "rgba(30, 30, 46,0.92)",
	inactive_titlebar_bg = "rgba(30, 30, 46,0.92)",
}
config.colors = {
	tab_bar = {
		background = "rgba(30, 30, 46,0.92)",
		inactive_tab_edge = "rgba(30, 30, 46,0.92)",
		active_tab = {
			bg_color = "rgba(30, 30, 46,0.92)",
			fg_color = "#fab387",
		},
		inactive_tab = {
			bg_color = "rgba(30, 30, 46,0.92)",
			fg_color = "#a6adc8",
		},
		inactive_tab_hover = {
			bg_color = "rgba(30, 30, 46,0.92)",
			fg_color = "#74c7ec",
		},
		new_tab = {
			bg_color = "rgba(30, 30, 46,0.92)",
			fg_color = "#a6adc8",
		},
		new_tab_hover = {
			bg_color = "rgba(30, 30, 46,0.92)",
			fg_color = "#74c7ec",
		},
	},
	split = "#fab387",
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
	{ key = "h", mods = "LEADER", action = split_nav('move', 'h') },
	{ key = "j", mods = "LEADER", action = split_nav('move', 'j') },
	{ key = "k", mods = "LEADER", action = split_nav('move', 'k') },
	{ key = "l", mods = "LEADER", action = split_nav('move', 'l') },
	{ key = "h", mods = "CTRL", action = split_nav('move', 'h') },
	{ key = "j", mods = "CTRL", action = split_nav('move', 'j') },
	{ key = "k", mods = "CTRL", action = split_nav('move', 'k') },
	{ key = "l", mods = "CTRL", action = split_nav('move', 'l') },
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
		{ key = "h", action = split_nav('resize', 'h') },
		{ key = "j", action = split_nav('resize', 'j') },
		{ key = "k", action = split_nav('resize', 'k') },
		{ key = "l", action = split_nav('resize', 'l') },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}



return config

