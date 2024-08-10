-- Pull in wezterm API
local wezterm = require("wezterm")

-- Variables
local act = wezterm.action

-- This will hold the configuration
local config = wezterm.config_builder()

-- Configuration is done here
config = {
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
	font_size = 11,

	keys = {
		{
			key = ")",
			mods = "CTRL|SHIFT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "(",
			mods = "CTRL|SHIFT",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
	},

	color_scheme = "Tokyo Night",

	default_cursor_style = "BlinkingBar",
	animation_fps = 40,
	enable_tab_bar = false,
}
-- and finally, return the configuration to wezterm
return config
