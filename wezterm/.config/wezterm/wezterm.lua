local wt = require 'wezterm';

return {
  -- On MacOS when launching the app from Alfred the default program is "sh". I want to use zsh.
  default_prog = {"/usr/local/bin/zsh", "-l"},

  window_decorations = "RESIZE",

  color_scheme = "DaveDark",
  font_size = 20.0,
  font = wt.font_with_fallback({
    { family="Iosevka Nerd Font", weight="Light"},
    { family="Apple Color Emoji" }
  }),
  font_rules = {
    {
      intensity = "Bold",
      font = wt.font_with_fallback({
        { family="Iosevka Nerd Font", weight="Regular" }
      })
    },
    {
      intensity = "Half",
      font = wt.font_with_fallback({
        { family="Iosevka Nerd Font", weight="Light" }
      })
    }
  },
  freetype_load_target = "HorizontalLcd",
  bold_brightens_ansi_colors = true,
  window_background_opacity = 1.0,
  text_background_opacity = 1.0,

  -- set to false to disable the tab bar completely
  enable_tab_bar = true,

  -- set to true to hide the tab bar when there is only
  -- a single tab in the window
  hide_tab_bar_if_only_one_tab = false,

  colors = {
    tab_bar = {

      -- The color of the strip that goes along the top of the window
      -- background = "#0b0022",
      background = "#1e1e1e",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#1e1e1e",
        -- The color of the text for the tab
        fg_color = "#84f542",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#000000",
        fg_color = "#c0c0c0",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      }
    }
  }
}
