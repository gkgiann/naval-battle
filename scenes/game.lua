Game = Class:extend()

function Game:new()
    gameSong = love.audio.newSource("sounds/game.mp3", "stream")

end

function Game:update(dt)
end

function Game:draw()
    love.audio.play(gameSong)
    love.window.setTitle("Batalha Naval")
    love.graphics.print("Com os navios posicionados, hora de batalhar")
end
