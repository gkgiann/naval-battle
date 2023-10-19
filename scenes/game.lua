Game = Class:extend()

function Game:new()
    self.gameSong = love.audio.newSource("sounds/game.mp3", "stream")
    self.gameSong:setLooping(true)
    self.background = love.graphics.newImage("assets/backgrounds/game.jpg")

    self.turn = "player"

    self.usedPlayerPositions = {}
    self.usedComputerPositions = {}

    self.computerShipsPosition = {}
    self.playerShipsPosition = {}

    self.playerShot = Shot(true)
    self.computerShot = Shot()
end

function Game:update(dt)
    if self.turn == "player" then
        for k, ship in pairs(playerShips) do
            ship:update(dt)
        end

        self.playerShot:update(dt)
    else
        for k, ship in pairs(computerShips) do
            ship:update(dt)
        end

        self.computerShot:update(dt)
    end
end

function Game:draw()
    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 150))
    love.graphics.draw(self.background)
    love.graphics.setColor(1, 1, 1)

    love.audio.play(self.gameSong)
    love.window.setTitle("Batalha Naval")

    createGrid()
    createGrid(computerGridPositionX)

    self:verifyUsedPositions()

    for k, ship in pairs(computerShips) do
        ship.isCurrentSelected = true
        ship:draw()
    end

    for k, ship in pairs(playerShips) do
        ship.moveBlocked = true
        ship.isCurrentSelected = true
        ship.isSet = false
        ship:draw()
    end

    self.playerShot:draw()
    self.computerShot:draw()

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

function Game:fillShipsPosition()
    for i = 1, grid.columnsQuantity do
        self.computerShipsPosition[i] = {}
        self.playerShipsPosition[i] = {}

        for j = 1, grid.linesQuantity do
            self.computerShipsPosition[i][j] = 0
            self.playerShipsPosition[i][j] = 0
        end
    end

    for k, ship in pairs(computerShips) do
        local shipPositions = ship:getMatrixPosition()

        for i, position in ipairs(shipPositions) do
            self.computerShipsPosition[position.column][position.line] = 1
        end
    end

    for k, ship in pairs(playerShips) do
        local shipPositions = ship:getMatrixPosition()

        for i, position in ipairs(shipPositions) do
            self.playerShipsPosition[position.column][position.line] = 1
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
