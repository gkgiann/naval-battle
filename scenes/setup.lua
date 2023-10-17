Setup = Class:extend()

function Setup:new()
    self.currentShipIndex = 1
    self.setupBackground = love.graphics.newImage("assets/backgrounds/game.jpg")
    self.setupSong = love.audio.newSource("sounds/setup.mp3", "stream")
    self.time = 0
    self.setShipEffect = love.audio.newSource("sounds/startGame.wav", "static")
    self.shipSetMatrix = {}
    self.computerShipSetMatrix = {}

    self.setupSong:setLooping(true)

    -- playerShips = {Ship(2), Ship(3), Ship(4), Ship(5)}
    -- computerShips = {Ship(2), Ship(3), Ship(4), Ship(5)}

    playerShips = {Ship(2), Ship(2), Ship(2), Ship(2), Ship(3), Ship(3), Ship(3), Ship(4), Ship(4), Ship(5)}
    computerShips = {Ship(2), Ship(2), Ship(2), Ship(2), Ship(3), Ship(3), Ship(3), Ship(4), Ship(4), Ship(5)}

    for k, ship in pairs(computerShips) do
        ship.isComputerShip = true
    end

end

function Setup:update(dt)
    self.time = self.time + dt

    if not (self.currentShipIndex > #playerShips) then
        currentShip = playerShips[self.currentShipIndex]
        currentShip.isCurrentSelected = true

        for k, ship in pairs(playerShips) do
            ship:update(dt)
        end

        if self.time > 0.25 and self.currentShipIndex <= #playerShips and love.keyboard.isDown("return") then
            if self:isPositionFree() then

                self:setComputerShipPosition()

                local shipMatrixPositions = currentShip:getMatrixPosition()

                for k, position in pairs(shipMatrixPositions) do
                    self.shipSetMatrix[position.column][position.line] = 1
                end

                self.currentShipIndex = self.currentShipIndex + 1

                currentShip.isCurrentSelected = false
                currentShip.isSet = true

                love.audio.play(self.setShipEffect)
                self.time = 0
            else
                love.audio.play(wrongEffect)
                currentShip.color.r, currentShip.color.g, currentShip.color.b = 1, 0, 0
            end
        end
    else
        for k, ship in pairs(playerShips) do
            ship.color.r, ship.color.g, ship.color.b = 0, 255, 0
        end

        if self.time > 2 then
            currentScene = "game"
            love.audio.stop()
        end
    end

end

function Setup:draw()
    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 150))
    love.graphics.draw(self.setupBackground)
    love.graphics.setColor(1, 1, 1)

    love.window.setTitle("Setup dos navios")

    createGrid()

    love.audio.play(self.setupSong)

    for k, ship in pairs(playerShips) do
        ship:draw()
    end

    self:showKeyboardControls()
    self:showShipsToSet()
end

function Setup:showShipsToSet()
    local i = 1

    for k, ship in pairs(playerShips) do
        if not ship.isSet then
            if ship.isCurrentSelected then
                love.graphics.setColor(0, 1, 0)
            end
            love.graphics.draw(ship.img, (grid.columnsQuantity + 2) * 40, i * 44)
            love.graphics.setColor(1, 1, 1)
            i = i + 1
        end
    end
end

function Setup:isPositionFree()
    local shipMatrixPositions = currentShip:getMatrixPosition()

    for k, position in pairs(shipMatrixPositions) do
        if self.shipSetMatrix[position.column][position.line] == 1 then
            return false
        end
    end

    return true
end

function Setup:isComputerPositionFree()
    local shipMatrixPositions = computerShips[self.currentShipIndex]:getMatrixPosition()

    for k, position in pairs(shipMatrixPositions) do
        if self.computerShipSetMatrix[position.column][position.line] == 1 then
            return false
        end
    end

    return true
end

function Setup:showKeyboardControls()
    local x = 900

    local textMove = love.graphics.newText(font30, "Movimentação do navio")
    local imgMove = love.graphics.newImage('assets/keyboard/move.png')

    love.graphics.draw(textMove, x, 25)
    love.graphics.draw(imgMove, x - 50, 35)

    local textRotate = love.graphics.newText(font30, "Girar navio")
    local imgRotate = love.graphics.newImage('assets/keyboard/shift.png')

    love.graphics.draw(textRotate, x, 250)
    love.graphics.draw(imgRotate, x, 270)

    local textSet = love.graphics.newText(font30, "Confirmar posição")
    local imgSet = love.graphics.newImage('assets/keyboard/enter.png')

    love.graphics.draw(textSet, x, 430)
    love.graphics.draw(imgSet, x, 480)

end

function Setup:fillShipSetMatrix()
    for i = 1, grid.columnsQuantity do
        self.shipSetMatrix[i] = {}
        self.computerShipSetMatrix[i] = {}

        for j = 1, grid.linesQuantity do
            self.shipSetMatrix[i][j] = 0
            self.computerShipSetMatrix[i][j] = 0
        end
    end
end

function Setup:setComputerShipPosition()
    local x, y, isUp = self:randomPosition(computerShips[self.currentShipIndex].length)

    computerShips[self.currentShipIndex].line = y
    computerShips[self.currentShipIndex].column = x
    computerShips[self.currentShipIndex].isUp = isUp

    if not self:isComputerPositionFree() then
        self:setComputerShipPosition()
    end

    local shipMatrixPositions = computerShips[self.currentShipIndex]:getMatrixPosition()

    for k, position in pairs(shipMatrixPositions) do
        self.computerShipSetMatrix[position.column][position.line] = 1
    end

end

function Setup:randomPosition(shipLength)
    local isUp = love.math.random(2) == 1 and true or false
    local x, y = 0, 0

    if isUp then
        x = love.math.random(grid.columnsQuantity)
        y = love.math.random(grid.linesQuantity - shipLength)
    else
        x = love.math.random(grid.columnsQuantity - shipLength)
        y = love.math.random(grid.linesQuantity)
    end

    return x, y, isUp
end

-- function Setup:reset()
--     self.currentShipIndex = 1
--     self.time = 0
--     self.shipSetMatrix = {}
--     self.computerShipSetMatrix = {}

--     playerShips = {Ship(2), Ship(2), Ship(2), Ship(2), Ship(3), Ship(3), Ship(3), Ship(4), Ship(4), Ship(5)}
--     computerShips = {Ship(2), Ship(2), Ship(2), Ship(2), Ship(3), Ship(3), Ship(3), Ship(4), Ship(4), Ship(5)}
-- end
