Setup = Class:extend()

function Setup:new()
    self.currentShipIndex = 1
    self.setupBackground = love.graphics.newImage("assets/mainGame.jpg")
    self.setupSong = love.audio.newSource("sounds/setup.mp3", "stream")
    self.time = 0
    self.setShipEffect = love.audio.newSource("sounds/startGame.wav", "static")
    self.shipSetMatrix = {}

    for i = 1, grid.columnsQuantity do
        self.shipSetMatrix[i] = {}
        
        for j = 1, grid.linesQuantity do
            self.shipSetMatrix[i][j] = 0
        end
    end

    ships = {Ship(2), Ship(3), Ship(4), Ship(5)}
end

function Setup:update(dt)
    self.time = self.time + dt

    if not (self.currentShipIndex > #ships) then
        currentShip = ships[self.currentShipIndex]
        currentShip.isCurrentSelected = true

        for k, ship in pairs(ships) do
            ship:update(dt)
        end

        if self.time > 0.3 and self.currentShipIndex <= #ships and
            (love.keyboard.isDown("return") or love.keyboard.isDown("space")) then
            if self:isPositionFree() then

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
        for k, ship in pairs(ships) do
            ship.color.r, ship.color.g, ship.color.b = 0, 255, 0
        end

        if self.time > 2 then
            currentScene = "game"
            love.audio.stop()
        end
    end

    if love.keyboard.isDown("backspace") then
        love.audio.stop(self.setupSong)
        currentScene = "mainGame"
    end
end

function Setup:draw()

    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 150))
    love.graphics.draw(self.setupBackground)
    love.graphics.setColor(1, 1, 1)

    love.window.setTitle("Setup dos navios")

    self:createGrid()

    love.audio.play(self.setupSong)

    for k, ship in pairs(ships) do
        ship:draw()
    end

    self:showShipsToSet()

end

function Setup:createGrid(x, y)
    x, y = x and x or 0, y and y or 0

    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 100))
    for i = 1, grid.columnsQuantity do
        for j = 1, grid.linesQuantity do
            love.graphics.rectangle("fill", (i * 33) + x, (j * 33) + y, 32, 32, 2, 2)
        end
    end
    love.graphics.setColor(1, 1, 1)

end

function Setup:showShipsToSet()
    local i = 1

    for k, ship in pairs(ships) do
        if not ship.isSet then
            if ship.isCurrentSelected then
                love.graphics.setColor(0, 1, 0)
            end
            love.graphics.draw(ship.img, (grid.columnsQuantity + 2) * 33, i * 35)
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
    -- currentShip

    -- FAZER UMA LÓGICA CABULOSA PARA VER SE O LUGAR
    -- ONDE VOU COLOCAR O NAVIO ESTÁ LIVRE, SE SIM, RETORNE TRUE
end
