Game = Class:extend()

function Game:new()
    self.gameSong = love.audio.newSource("sounds/game.mp3", "stream")
    self.gameSong:setLooping(true)
    self.background = love.graphics.newImage("assets/backgrounds/game.jpg")

    self.usedPlayerPositions = {}

    self.usedComputerPositions = {}

    self.playerShot = Shot(true)
    self.computerShot = Shot()

end

function Game:update(dt)
    for k, ship in pairs(computerShips) do
        ship:update(dt)
    end

    for k, ship in pairs(playerShips) do
        ship:update(dt)
    end

    self.playerShot:update(dt)
    -- self.computerTarget:update(dt)

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

    -- computerShips[1].destroyedParts[1] = true
    -- computerShips[1].destroyedParts[2] = true

    -- computerShips[3].destroyedParts[1] = true
    -- computerShips[3].destroyedParts[2] = true
    -- computerShips[3].destroyedParts[3] = true
    -- computerShips[3].destroyedParts[4] = true
    -- computerShips[7].destroyedParts[3] = true

    self:verifyUsedPositions()

    -- self.usedPlayerPositions[1][1] = 1
    -- self.usedComputerPositions[1][1] = 1

    for k, ship in pairs(playerShips) do
        ship.moveBlocked, ship.isCurrentSelected = true, true
        ship.isSet = false
        ship:draw()
    end

    for k, ship in pairs(computerShips) do
        ship.isCurrentSelected = true
        ship:draw()
    end

    self.playerShot:draw()
    -- self.computerTarget:draw()

    self:showKeyboardControls()
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
    local marginTop = grid.columnsQuantity == 12 and 360 or 430

    local i = 1
    local marginLeft = 40

    for i = 1, 4 do
        local ship = computerShips[i]
        if ship:isShipDestroyed() then
            love.graphics.setColor(1, 0, 0)
        end

        love.graphics.draw(ship.img, computerGridPositionX + marginLeft, (i * 44) + marginTop)
        love.graphics.setColor(1, 1, 1)
    end

    marginLeft = marginLeft + 80

    local heightI = 1
    for p = 5, 7 do
        local ship = computerShips[p]
        if ship:isShipDestroyed() then
            love.graphics.setColor(1, 0, 0)
        end

        love.graphics.draw(ship.img, computerGridPositionX + marginLeft, (heightI * 44) + marginTop)
        love.graphics.setColor(1, 1, 1)

        heightI = heightI + 1
    end

    marginLeft = marginLeft + 110

    heightI = 1
    for i = 8, 9 do
        local ship = computerShips[i]
        if ship:isShipDestroyed() then
            love.graphics.setColor(1, 0, 0)
        end

        love.graphics.draw(ship.img, computerGridPositionX + marginLeft, (heightI * 44) + marginTop)
        love.graphics.setColor(1, 1, 1)
        heightI = heightI + 1
    end

    marginLeft = marginLeft + 140

    local ship = computerShips[10]
    if ship:isShipDestroyed() then
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.draw(ship.img, computerGridPositionX + marginLeft, (1 * 44) + marginTop)
    love.graphics.setColor(1, 1, 1)
end

function Game:showKeyboardControls()
    local x = 40
    local y = grid.columnsQuantity == 12 and 400 or 470

    local textRotate = love.graphics.newText(font20, "Ataque especial")
    local imgRotate = love.graphics.newImage('assets/keyboard/shift.png')

    local text = string.format('Ataques especiais: %d', self.playerShot.specialAttackCount)
    local textSpecialAttackCount = love.graphics.newText(font20, text)

    love.graphics.draw(textSpecialAttackCount, x + 320, y)

    love.graphics.draw(textRotate, x, y)
    y = y - 5
    love.graphics.draw(imgRotate, x, y)
    y = y + 130

    local textSet = love.graphics.newText(font20, "Confirmar ataque")
    local imgSet = love.graphics.newImage('assets/keyboard/enter.png')

    love.graphics.draw(textSet, x, y)
    y = y + 20
    love.graphics.draw(imgSet, x, y)

end
