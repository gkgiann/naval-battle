SpecialTarget = Class:extend()

function SpecialTarget:new(isPlayerSpecialTarget)
    self.isPlayerSpecialTarget = isPlayerSpecialTarget and isPlayerSpecialTarget or false
    self.line = 1
    self.column = 1
    self.time = 0
    self.color = {1, 1, 0}
    self.isSet = false
end

function SpecialTarget:update(dt)
    self.time = self.time + dt

    if self.time > 0.2 then
        self.color = {1, 1, 0}
    end

    if not self.isSet then
        self:move()
    end
end

function SpecialTarget:draw()
    if self.isSet then
        self.color = {0, 1, 0}
    end

    local r, g, b = self.color[1], self.color[2], self.color[3]
    love.graphics.setColor(r, g, b)

    local marginX = self.isPlayerSpecialTarget and computerGridPositionX or 0
    local centerX = (self.column * 40) + marginX + (39 * 3) / 2
    local centerY = (self.line * 40) + (39 * 3) / 2

    local rectangleLength = 39 * 3
    local lineLength = 19 * 3

    love.graphics.rectangle("line", (self.column * 40) + marginX, (self.line * 40), rectangleLength, rectangleLength, 2,
        2)

    love.graphics.setLineWidth(3)
    love.graphics.line(centerX, centerY - lineLength, centerX, centerY + lineLength)
    love.graphics.line(centerX - lineLength, centerY, centerX + lineLength, centerY)

    love.graphics.setColor(1, 1, 1)

end

function SpecialTarget:move(dt)
    if self.time > 0.25 and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
        if (self.line > 1) then
            love.audio.play(moveShipEffect)
            self.line = self.line - 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.line = grid.linesQuantity - 2
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
            self.column = grid.columnsQuantity - 2
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
        if not (self.column >= (grid.columnsQuantity - 2)) then
            love.audio.play(moveShipEffect)
            self.column = self.column + 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.column, self.time = 1, 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
        if not (self.line >= (grid.linesQuantity - 2)) then
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

function SpecialTarget:getSpecialTargetsPosition()
    local positions = {}

    for i = 0, 2 do
        local currentLine = self.line + i

        positions[currentLine] = {{
            line = currentLine,
            col = self.column
        }, {
            line = currentLine,
            col = self.column + 1
        }, {
            line = currentLine,
            col = self.column + 2
        }}
    end

    return positions
end

-- function SpecialTarget:isPositionFree()
--     local usedPositions = self.isPlayerSpecialTarget and game.usedComputerPositions or game.usedPlayerPositions
--     local targetPositions = self:getSpecialTargetsPosition()

--     for k, position in pairs(targetPositions) do
--         for k, pos in pairs(position) do
--             if usedPositions[pos.col][pos.line] > 0 then
--                 return false
--             end
--         end
--     end

--     return true
-- end

function SpecialTarget:verifyIfHitShip()
    local usedPositions = self.isPlayerSpecialTarget and game.usedComputerPositions or game.usedPlayerPositions
    local ships = self.isPlayerSpecialTarget and computerShips or playerShips
    local shipsMatrix = self.isPlayerSpecialTarget and game.computerShipsPosition or game.playerShipsPosition
    local targetPositions = self:getSpecialTargetsPosition()

    for k, targetPosition in pairs(targetPositions) do
        for k, pos in pairs(targetPosition) do
            if shipsMatrix[pos.col][pos.line] == 1 then
                for k, ship in pairs(ships) do
                    local shipPositions = ship:getMatrixPosition()

                    for i, position in ipairs(shipPositions) do
                        if pos.col == position.column and pos.line == position.line then
                            usedPositions[pos.col][pos.line] = 2
                            ship.destroyedParts[i] = true

                            if self.isPlayerSpecialTarget then
                                game.playerStatistics.hits = game.playerStatistics.hits + 1
                            else
                                game.computerHits = game.computerHits + 1

                                table.insert(game.firedPositions, {col = pos.col,
                        line = pos.line})
                                -- game.firedPositions[#game.firedPositions + 1] = {
                                --     col = pos.col,
                                --     line = pos.line
                                -- }
                                local fired = game.firedPositions[#game.firedPositions]
                                print(string.format("Adicionado fired => col: %d, line: %d", fired.col, fired.line))
                            end
                        end
                    end
                end
            else
                usedPositions[pos.col][pos.line] = 1
            end
        end
    end
end
