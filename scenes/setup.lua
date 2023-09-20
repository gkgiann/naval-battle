Setup = Class:extend()

function Setup:new()
    setupSong = love.audio.newSource("sounds/setup.mp3", "stream")
end

function Setup:update(dt)
    if love.keyboard.isDown("backspace") then
        love.audio.stop(setupSong)
        currentScene = "mainGame"
    end
end

function Setup:draw()
    love.window.setTitle("Setup dos navios")
    love.audio.play(setupSong)
    love.graphics.print("tela onde faz o setup dos navios (backspace para voltar)", 100, 100)
end
