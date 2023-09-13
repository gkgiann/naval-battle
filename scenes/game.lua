Game = Class:extend()

function Game:new()
end

function Game:update(dt)
    if love.keyboard.isDown("backspace") then
        currentScene = "mainGame"
    end
end

function Game:draw()
    love.graphics.print("tela onde o jogo acontece (backspace para voltar)", 100, 100)
end
