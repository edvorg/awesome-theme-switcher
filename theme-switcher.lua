--[[

Awesome Theme Switcher LGPL Source Code
Copyright (C) 2014 Edward Knyshov.

This file is part of the Awesome Theme Switcher LGPL Source Code
(Awesome Theme Switcher Source Code).

Awesome Theme Switcher Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Awesome Theme Switcher Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Awesome Theme Switcher Source Code.  If not, see <http://www.gnu.org/licenses/>.

Original Awesome Theme Switcher Source Code repository can be found at
https://github.com/edvorg/awesome-theme-switcher

]]--

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

function themeSwitcher.currentTheme()
    return "/usr/share/awesome/themes/default/theme.lua"
end

return themeSwitcher
