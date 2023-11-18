Target = Class:extend()

function Target:new(isPlayerTarget)
    self.isPlayerTarget = isPlayerTarget and isPlayerTarget or false
    self.line = 1
    self.column = 1
    self.time = 0
    self.color = {1, 1, 0}
    self.isSet = false
    self.isCurrentSelected = false
end

function Target:update(dt)
    self.time = self.time + dt

    if self.time > 0.2 then
        self.color = {1, 1, 0}
    end

    if self.isPlayerTarget and self.isCurrentSelected and not self.isSet then
        self:move()
    end
end

function Target:draw()
    if self.isSet then
        self.color = {0, 1, 0}
    end

    local r, g, b = self.color[1], self.color[2], self.color[3]
    love.graphics.setColor(r, g, b)

    local marginX = self.isPlayerTarget and computerGridPositionX or 0
    local centerX = (self.column * 40) + marginX + 38 / 2
    local centerY = (self.line * 40) + 38 / 2

    local rectangleLength = 38
    local lineLength = 19

    love.graphics.rectangle("line", (self.column * 40) + marginX, (self.line * 40), rectangleLength, rectangleLength, 2,
        2)

    love.graphics.setLineWidth(2)
    love.graphics.line(centerX, centerY - lineLength, centerX, centerY + lineLength)
    love.graphics.line(centerX - lineLength, centerY, centerX + lineLength, centerY)

    love.graphics.setColor(1, 1, 1)

end

function Target:move(dt)
    if self.time > 0.25 and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
        if (self.line > 1) then
            love.audio.play(moveShipEffect)
            self.line = self.line - 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.line = grid.linesQuantity
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
        if (self.column > 1) then
            love.audio.play(moveShipEffect)
            self.column = self.column - 1
            self.time = 0
            love.audio.play(moveShipEffect)
        else
            love.audio.play(moveShipEffect)
            self.column = grid.columnsQuantity
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
        if not (self.column >= grid.columnsQuantity) then
            love.audio.play(moveShipEffect)
            self.column = self.column + 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.column, self.time = 1, 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
        if not (self.line >= grid.linesQuantity) then
            love.audio.play(moveShipEffect)
            self.line = self.line + 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.line = self.line + 1
            self.line, self.time = 1, 0
        end
    end
end

function Target:verifyIfHitShip()
    local usedPositions = self.isPlayerTarget and game.usedComputerPositions or game.usedPlayerPositions
    local ships = self.isPlayerTarget and computerShips or playerShips
    local shipsMatrix = self.isPlayerTarget and game.computerShipsPosition or game.playerShipsPosition

    if shipsMatrix[self.column][self.line] == 1 then
        for k, ship in pairs(ships) do
            local shipPositions = ship:getMatrixPosition()

            for i, position in ipairs(shipPositions) do
                if self.column == position.column and self.line == position.line then
                    ship.destroyedParts[i] = true
                    usedPositions[self.column][self.line] = 2

                    if self.isPlayerTarget then
                        game.playerStatistics.hits = game.playerStatistics.hits + 1
                    else
                        game.computerHits = game.computerHits + 1
                    end

                    return
                end
            end
        end
    end

    usedPositions[self.column][self.line] = 1
end

function Target:isPositionFree()
    local usedPositions = self.isPlayerTarget and game.usedComputerPositions or game.usedPlayerPositions

    if usedPositions[self.column][self.line] > 0 then
        self.color = {1, 0, 0}
        love.audio.play(wrongEffect)

        return false
    end

    self.time = 0

    return true
end
