Game = Class:extend()

function Game:new()
    gameSong = love.audio.newSource("sounds/fire_cocktail.mp3", "stream")
end

function Game:update(dt)
    if love.keyboard.isDown("backspace") then
        love.audio.stop(gameSong)
        currentScene = "mainGame"
    end
end

function Game:draw()
    love.audio.play(gameSong)
    love.graphics.print("tela onde o jogo acontece (backspace para voltar)", 100, 100)
end
