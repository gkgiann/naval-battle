Setup = Class:extend()

function Setup:new()
    bg = love.graphics.newImage("assets/bg_grid.jpg")
    setupSong = love.audio.newSource("sounds/setup.mp3", "stream")

    ship2 = Ship(2)
end

function Setup:update(dt)
    ship2:update(dt)

    if love.keyboard.isDown("backspace") then
        love.audio.stop(setupSong)
        currentScene = "mainGame"
    end

end

function Setup:draw()

    love.window.setTitle("Setup dos navios")

    for i = 1, 15 do
        for j = 1, 10 do
            love.graphics.rectangle("fill", i * 32, j * 32, 31, 31)
        end

    end

    love.audio.play(setupSong)
    -- love.graphics.print("tela onde faz o setup dos navios (backspace para voltar)", 5, 5)

    ship2:draw()
end
