local naughty = require("naughty")

local themeSwitcher = {}

function themeSwitcher.widget(path)
    if path == nil then
        path = "/usr/share/awesome/themes"
    end

    naughty.notify({ preset = naughty.config.presets.normal,
                     title = "Theme Switcher!",
                     text = "Hello World!" })
end

return themeSwitcher
