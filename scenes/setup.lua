Setup = Class:extend()

function Setup:new()
    setupBackground = love.graphics.newImage("assets/mainGame.jpg")
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

    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 150))
    love.graphics.draw(setupBackground)
    love.graphics.setColor(1, 1, 1)

    love.window.setTitle("Setup dos navios")

    self:createGrid()

    love.audio.play(setupSong)
    -- love.graphics.print("tela onde faz o setup dos navios (backspace para voltar)", 5, 5)

    ship2:draw()
end

function Setup:createGrid()
    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 100))
    for i = 1, 15 do
        for j = 1, 10 do
            love.graphics.rectangle("fill", i * 33, j * 33, 32, 32, 2, 2)
        end
    end
    love.graphics.setColor(1, 1, 1)
end
