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

local logTag = "Awesome Theme Switcher"
local themeConfigFile = ".awesome-theme"
local themeConfigPath = os.getenv("HOME") .. "/" .. themeConfigFile
local themeSuffix = "/theme.lua"
local defaultThemesPath = "/usr/share/awesome/themes"
local defaultTheme = defaultThemesPath .. "/default" .. themeSuffix

function themeSwitcher.themes(directory)
    if directory == nil then
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = logTag,
                         text = "directory is nil. using default instead" })
        return themeSwitcher.themes(defaultThemesPath)
    end

    local function command()
        return 'ls -a "' .. directory .. '"' -- @todo add cases for different platforms
    end

    local i, t = 0, {}
    for filename in io.popen(command()):lines() do
        if filename ~= ".." and filename ~= "." then
            t[i] = defaultThemesPath .. "/" .. filename .. themeSuffix
            i = i + 1
        end
    end

    if t[0] == nil then
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = logTag,
                         text = "there are no themes in " .. directory ..
                             ". using default" })
        return themeSwitcher.themes(defaultThemesPath)
    end

    return t
end

function themeSwitcher.nextTheme(current, directory, dir)
    local t = themeSwitcher.themes(directory)
    local currentTheme = themeSwitcher.currentTheme()
    local result = defaultTheme
    local length = 0

    while t[length] do
        length = length + 1
    end

    local i = 0
    local cont = true
    while t[i] and cont do
        if t[i] == currentTheme then
            if t[i + dir] then
                result = t[i + dir]
            elseif dir > 0 then
                result = t[0]
            elseif dir < 0 then
                result = t[length - 1]
            end

            cont = false
        end

        i = i + 1
    end

    if cont and t[0] then
        result = t[0]
    end

    return result
end

function themeSwitcher.widget(path)
    local logo = " &#358;  "

    if path == nil then
        path = defaultThemesPath
    end

    local mod = {}
    local button = 1
    local press = function ()
    end
    local release = function ()
        themeSwitcher.setCurrentTheme(
            themeSwitcher.nextTheme(
                themeSwitcher.currentTheme(), path, 1))
        awesome.restart()
    end

    local button = awful.button({ }, 1, press, release)
    local widget = wibox.widget.textbox()

    widget:set_markup(logo)
    widget:buttons(awful.util.table.join(button))

    return widget
end

function themeSwitcher.setCurrentTheme(theme)
    local f = io.open(themeConfigPath, "w")

    if f then
        f:write(theme)
        f:close()
    else
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = logTag,
                         text = "unable to write to config file" })
    end
end

function themeSwitcher.currentTheme()
    local result = defaultTheme
    local f = io.open(themeConfigPath, "r")

    if f == nil then return result end

    local theme = f:read("*line")

    if theme == nil then return result end

    return theme
end

return themeSwitcher
