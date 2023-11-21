Game = Class:extend()

function Game:new()
    self.gameSong = love.audio.newSource("sounds/game.mp3", "stream")
    self.gameSong:setLooping(true)
    self.background = love.graphics.newImage("assets/backgrounds/game.jpg")

    self.playerStatistics = {
        time = 0,
        shots = 0,
        hits = 0
    }
    self.turn = "player"

    self.computerHits = 0

    self.firedPositions = {}

    self.usedPlayerPositions = {}
    self.usedComputerPositions = {}

    self.computerShipsPosition = {}
    self.playerShipsPosition = {}

    self.playerShot = Shot(true)
    self.computerShot = Shot()
    self.time, self.timePlay = 0, 0
    self.computerShotReseted = true
end

function Game:update(dt)
    self.time = self.time + dt

    self.playerStatistics.time = self.playerStatistics.time + dt

    -- 30 or 14
    if self.playerStatistics.hits == 30 then
        self.timePlay = self.timePlay + dt

        if self.timePlay > 5 then
            love.audio.stop()
            currentScene = "endGame"
        end
    elseif self.computerHits == 30 then
        self.timePlay = self.timePlay + dt

        if self.timePlay > 5 then
            love.audio.stop()
            endGame.isPlayerWin = false
            currentScene = "endGame"
        end
    else

        if not self.computerShotReseted and self.time > 2.5 and self.turn == "player" then
            love.audio.play(hitEffect)
            self.computerShot:reset()
            self.time = 0
            self.timePlay = 0
            self.computerShotReseted = true
        end

        if self.turn == "player" then
            for k, ship in pairs(playerShips) do
                ship:update(dt)
            end

            if self.time > 1.5 then
                self.playerShot:update(dt)
            end

        else
            for k, ship in pairs(computerShips) do
                ship:update(dt)
            end

            self.computerShot:update(dt)
        end
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
        -- ship.isCurrentSelected = true
        ship:draw()
    end

    for k, ship in pairs(playerShips) do
        ship.moveBlocked = true
        ship.isCurrentSelected = true
        ship.isSet = false
        ship:draw()
    end

    if self.turn ~= "player" then
        if self.computerShot.specialAttackCount > 0 then
            self.computerShot.isSpecial = true
            self:computerPlay()
            self.computerShot.specialAttackCount = self.computerShot.specialAttackCount - 1
        else
            for i = 1, 3 do
                local x, y = self:randomShotPosition(false)
                self.computerShot:setShotPosition(x, y, i)
            end

            for i = 1, 3 do
                self.computerShot:confirmShot(i)
            end
        end

        self.computerShotReseted = false
        self.turn = "player"
        self.time = 0
    end

    self.playerShot:draw()
    self.computerShot:draw()

    self:showKeyboardControls()
    -- self:showShipsToDestroy()
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

function Game:computerPlay()
    local x, y = self:randomShotPosition(true)

    self.computerShot:setShotPosition(x, y)
    self.computerShot:confirmShot()

end

function Game:randomShotPosition(isSpecialTarget)
    -- antes de gerar posições aleatórias,
    -- olhar se não existe algum navio parcialmente destruído

    if not isSpecialTarget and #self.firedPositions > 0 then
        print("caiu aqui 02")
        local randomIndex = love.math.random(#self.firedPositions)
        local randomFiredPosition = self.firedPositions[randomIndex]

        local y, x = randomFiredPosition.col, randomFiredPosition.line
        print(string.format("randomFiredPosition=> x: %d, y: %d", x, y))
        local freePositions, i = {}, 1

        -- logica aqui
        -- ver se tem um fired em cima
        if x > grid.columnsQuantity and self.usedPlayerPositions[x][y - 1] == 0 then
            print("xablau")
            freePositions[i] = {
                col = x - 1,
                line = y
            }
            i = i + 1
        end

        if #freePositions > 0 then
            randomIndex = love.math.random(#freePositions)
            local position = freePositions[randomIndex]

            return position.col, position.line
        end

    end

    print("Caiu aqui")

    local minus = isSpecialTarget and 2 or 0
    local x = love.math.random(grid.linesQuantity - minus)
    local y = love.math.random(grid.columnsQuantity - minus)

    if self.usedPlayerPositions[y][x] > 0 then

        return self:randomShotPosition(isSpecialTarget)
    end

    return x, y

end
