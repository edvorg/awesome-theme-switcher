local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")

local themeSwitcher = {}

function themeSwitcher.widget(path)
    local logo = " &#358;  ";

    if path == nil then
        path = "/usr/share/awesome/themes"
    end

    local mod = {}
    local button = 1
    local press = function ()
        naughty.notify({ preset = naughty.config.presets.normal,
                         title = "Theme Switcher!",
                         text = "press" })
    end
    local release = function ()
        naughty.notify({ preset = naughty.config.presets.normal,
                         title = "Theme Switcher!",
                         text = "release" })
    end

    local button = awful.button({ }, 1, press, release)
    local widget = wibox.widget.textbox()

    widget:set_markup(logo)
    widget:buttons(awful.util.table.join(button))

    return widget
end

return themeSwitcher
