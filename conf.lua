-- https://love2d.org/wiki/Config_Files

function love.conf(t)
    require("yue")
    t.console = true
    t.window.title = "My Tsuki Game"
    t.window.width = 800
    t.window.height = 480
end
