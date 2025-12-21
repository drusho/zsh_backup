-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Initialize configuration builder
local config = wezterm.config_builder()

-- ============================================================================
-- APPEARANCE
-- ============================================================================

-- Color Scheme (Custom Cobalt2-inspired theme)
config.colors = {
	foreground = "#CBE0F0",
	-- background = "#0a436e",
	-- background = "rgba(0,0,0,0)",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = {
		"#214969", -- black
		"#E52E2E", -- red
		"#44FFB1", -- green
		"#FFE073", -- yellow
		"#0FC5ED", -- blue
		"#a277ff", -- magenta
		"#24EAF7", -- cyan
		"#24EAF7", -- white
	},
	brights = {
		"#214969", -- bright black
		"#E52E2E", -- bright red
		"#44FFB1", -- bright green
		"#FFE073", -- bright yellow
		"#A277FF", -- bright blue
		"#a277ff", -- bright magenta
		"#24EAF7", -- bright cyan
		"#24EAF7", -- bright white
	},
}

-- Window Appearance

config.window_background_opacity = 0.8
config.macos_window_background_blur = 30 -- Adds a professional 'frosted glass' effect on Mac
config.window_decorations = "RESIZE"

-- -- 1. Cyberpunk Aesthetic & Transparency -- --
config.background = {
    {
        source = {
            Gradient = {
                orientation = { Linear = { angle = 45.0 } },
                colors = {
                    '#0f0c29', -- Deep Space
                    '#302b63', -- Cyber Purple
                    '#24243e', -- Night Blue			
                    '#ff00ff', -- Optional: Add a hint of neon pink at the edge
},
                interpolation = 'Linear',
                -- 'preset' removed to allow custom 'colors' array to work
            },
        },
        width = '100%',
        height = '100%',
        opacity = 0.9, 
    },
}

-- Ensures your cursor doesn't get lost in the gradient
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 1500
config.force_reverse_video_cursor = true

-- -- 2. Visual Polish -- --
config.color_scheme = 'Cobalt2' -- Matches your existing theme preference
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.3,
}

-- return config


-- Font Configuration
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0
config.line_height = 1.0

-- Tab Bar - Minimal professional style
config.enable_tab_bar = true
config.use_fancy_tab_bar = false -- Use simple/retro tab bar for clean look
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- Tab bar colors (matches Cobalt2 theme)
config.colors.tab_bar = {
	background = "#0a2540",
	active_tab = {
		bg_color = "#0a436e",
		fg_color = "#CBE0F0",
		intensity = "Bold",
	},
	inactive_tab = {
		bg_color = "#0a2540",
		fg_color = "#6B8BA3",
	},
	inactive_tab_hover = {
		bg_color = "#0a3050",
		fg_color = "#CBE0F0",
		italic = false,
	},
	new_tab = {
		bg_color = "#0a2540",
		fg_color = "#6B8BA3",
	},
	new_tab_hover = {
		bg_color = "#0a3050",
		fg_color = "#CBE0F0",
	},
}

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu" -- Modern GPU-accelerated rendering

-- ============================================================================
-- SSH & REMOTE CONNECTIONS (Data Engineer workflow)
-- ============================================================================

-- SSH domains for quick access to homelab
config.ssh_domains = {
	{
		name = "homelab-nas",
		remote_address = "192.168.1.249",
		username = "admin",
		-- Connect with: wezterm connect homelab-nas
	},
	-- Add more SSH hosts as needed:
	-- {
	--   name = "remote-server",
	--   remote_address = "your-server.example.com",
	--   username = "your-username",
	-- },
}

-- ============================================================================
-- BEHAVIOR
-- ============================================================================

-- Scrollback
config.scrollback_lines = 10000

-- Window padding
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

-- macOS-specific settings
config.native_macos_fullscreen_mode = false -- Better window management
config.quit_when_all_windows_are_closed = false -- Keep app running

-- Mouse bindings - macOS standard behavior
config.mouse_bindings = {
	-- Copy on select (like iTerm2)
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- Paste on right-click
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- ============================================================================
-- KEY BINDINGS
-- ============================================================================

config.keys = {
	-- Disable default CMD+K clear scrollback (can be confusing)
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackOnly"),
	},
	-- Split panes (like tmux)
	{
		key = "|",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "_",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Navigate panes with CMD+Arrow
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	-- Close pane
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- Tab management
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "[",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "CMD",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- Workspace management (Data Engineer: switch between projects)
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = "#44FFB1" } },
				{ Text = "Enter name for new workspace:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- Quick SSH launcher
	{
		key = "s",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
	},
	-- CMD+1-9 to switch to specific tabs
	{
		key = "1",
		mods = "CMD",
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "2",
		mods = "CMD",
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "3",
		mods = "CMD",
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "4",
		mods = "CMD",
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "5",
		mods = "CMD",
		action = wezterm.action.ActivateTab(4),
	},
	{
		key = "6",
		mods = "CMD",
		action = wezterm.action.ActivateTab(5),
	},
	{
		key = "7",
		mods = "CMD",
		action = wezterm.action.ActivateTab(6),
	},
	{
		key = "8",
		mods = "CMD",
		action = wezterm.action.ActivateTab(7),
	},
	{
		key = "9",
		mods = "CMD",
		action = wezterm.action.ActivateTab(8),
	},
}

-- and finally, return the configuration to wezterm
return config