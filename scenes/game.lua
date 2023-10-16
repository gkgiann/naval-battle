Game = Class:extend()

function Game:new()
    self.gameSong = love.audio.newSource("sounds/game.mp3", "stream")
    self.gameSong:setLooping(true)
    self.background = love.graphics.newImage("assets/backgrounds/game.jpg")

    self.usedPlayerPositions = {}
    self.usedComputerPositions = {}
    self.playerCursor = Cursor(true)
    -- self.computerCursor = Cursor()
end

function Game:update(dt)
    for k, ship in pairs(computerShips) do
        ship:update(dt)
    end

    for k, ship in pairs(playerShips) do
        ship:update(dt)
    end

    self.playerCursor:update(dt)
    -- self.computerCursor:update(dt)

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
    createGrid(computerGridPositionX)

    computerShips[1].destroyedParts[1] = true
    computerShips[1].destroyedParts[2] = true

    computerShips[3].destroyedParts[1] = true
    -- computerShips[3].destroyedParts[2] = true
    computerShips[3].destroyedParts[3] = true
    -- computerShips[3].destroyedParts[4] = true

    self:verifyUsedPositions()

    -- self.usedPlayerPositions[1][1] = 1
    -- self.usedComputerPositions[1][1] = 1

    for k, ship in pairs(playerShips) do
        ship.moveBlocked, ship.isCurrentSelected = true, true
        ship.isSet = false
        ship:draw()
    end

    for k, ship in pairs(computerShips) do
        -- ship.isCurrentSelected = true
        ship:draw()
    end

    self.playerCursor:draw()
    -- self.computerCursor:draw()

    self:showShipsToDestroy()
end

function Game:fillUsedPositions()
    for i = 1, grid.columnsQuantity do
        self.usedPlayerPositions[i] = {}
        self.usedComputerPositions[i] = {}

        for j = 1, grid.linesQuantity do
            self.usedPlayerPositions[i][j] = 0
            self.usedComputerPositions[i][j] = 0
        end
    end
end

function Game:verifyUsedPositions()
    for i = 1, grid.columnsQuantity do
        for j = 1, grid.linesQuantity do
            love.graphics.setColor(love.math.colorFromBytes(50, 50, 50, 150))

            if self.usedPlayerPositions[i][j] == 1 then
                love.graphics.rectangle("fill", (i * 40), (j * 40), 38, 38, 2, 2)
            end

            if self.usedComputerPositions[i][j] == 1 then
                love.graphics.rectangle("fill", (i * 40) + computerGridPositionX, (j * 40), 38, 38, 2, 2)
            end

            love.graphics.setColor(1, 1, 1)
        end
    end
end

function Game:showShipsToDestroy()
    local i = 1

    for k, ship in pairs(computerShips) do
        if ship:isShipDestroyed() then
            love.graphics.setColor(1, 0, 0)
        end

        love.graphics.draw(ship.img, (grid.columnsQuantity + 2) * 40, i * 44)
        love.graphics.setColor(1, 1, 1)
        i = i + 1
    end
end
