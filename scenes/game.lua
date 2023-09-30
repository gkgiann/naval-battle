Game = Class:extend()

function Game:new()
    self.gameSong = love.audio.newSource("sounds/game.mp3", "stream")
    self.gameSong:setLooping(true)
    self.background = love.graphics.newImage("assets/game.jpg")

end

function Game:update(dt)
end

function Game:draw()
    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 150))
    love.graphics.draw(self.background)
    love.graphics.setColor(1, 1, 1)

    love.audio.play(self.gameSong)
    love.window.setTitle("Batalha Naval")

    -- TABULEIRO DO JOGADOR
    createGrid()

    -- TABULEIRO DA MÁQUINA
    createGrid(windowWidth - (grid.columnsQuantity * 40) - 80)
end
