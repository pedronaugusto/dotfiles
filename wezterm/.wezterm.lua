local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
if wezterm.config_builder then config = wezterm.config_builder() end

config.color_scheme = "Catppuccin Mocha"
config.font_size = 16.0

config.macos_window_background_blur = 20
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

config.window_frame = {
	active_titlebar_bg = '#1e1e2e'
}

-- Keys
config.leader = { key = "a", mods = "CMD", timeout_milliseconds = 1500 }
config.keys = {
  -- Send C-a when pressing C-a twice
  { key = "a",          mods = "LEADER|CMD", action = act.SendKey { key = "a", mods = "CMD" } },
  { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },

  -- Pane keybindings
  { key = "-",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "=",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
  { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
  { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
  { key = "o",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },
  -- We can make separate keybindings for resizing panes

  { key = "f",			mods = "LEADER",	  action = act.ToggleFullScreen },
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab keybindings
  { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[",          mods = "LEADER",      action = act.ActivateTabRelative(-1) },
  { key = "]",          mods = "LEADER",      action = act.ActivateTabRelative(1) },
  { key = "n",          mods = "LEADER",      action = act.ShowTabNavigator },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  },
  -- Key table for moving tabs around
  { key = "m", mods = "LEADER",       action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },
  -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
  { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

  -- Lastly, workspace
  { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}
config.use_fancy_tab_bar = false
config.status_update_interval = 200
config.tab_bar_at_bottom = false
wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#f9e2af"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7dcfff"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#fab387"
  end

  -- Battery
  local bat = ''
  local charge_icon = ''
  local charge = 0
  for _, b in ipairs(wezterm.battery_info()) do
    charge = b.state_of_charge * 100
    if charge >= 90 then
      charge_icon = wezterm.nerdfonts.fa_battery_full
    elseif charge >= 65 and charge < 90 then
      charge_icon = wezterm.nerdfonts.fa_battery_three_quarters
    elseif charge >= 35 and charge < 65 then
      charge_icon = wezterm.nerdfonts.fa_battery_half
    elseif charge >= 15 and charge < 35 then
      charge_icon = wezterm.nerdfonts.fa_battery_quarter
    elseif charge >= 0 and charge < 15 then
      charge_icon = wezterm.nerdfonts.fa_battery_one_empty
    end
  end

  bat = string.format('%.0f%%', charge)

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " |" },
  }))

  -- Right status
  window:set_right_status(wezterm.format({

    { Foreground = { Color = stat_color } },
    { Text =  charge_icon .. "  " .. bat },
    { Text = " | " },

    { Foreground = { Color = stat_color } },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  }))
end)

return config
