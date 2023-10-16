Cursor = Class:extend()

function Cursor:new(isPlayerCursor)
    self.isPlayerCursor = isPlayerCursor and isPlayerCursor or false
    self.line = 1
    self.column = 1
    self.time = 0
    self.isBlocked = false
    self.color = {1, 1, 0}
    self.isSpecial = true
    self.specialAttackCount = 2

end

function Cursor:update(dt)
    self.time = self.time + dt

    if self.time > 0.2 then
        self.color = {1, 1, 0}
    end

    if self.time > 0.25 and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
        if self.specialAttackCount > 0 then
            if not self.isSpecial then
                self.line, self.column = 1, 1
            end

            self.isSpecial = not self.isSpecial
            self.time = 0
        end
    end

    if not self.isBlocked then
        self:move()

        if self.time > 0.25 and love.keyboard.isDown("return") then

            local usedPositions = self.isPlayerCursor and game.usedComputerPositions or game.usedPlayerPositions

            if self.isSpecial then
                if self:isPositionFree() then
                    local cursorPositions = self:getTargetsPosition()

                    for k, position in pairs(cursorPositions) do
                        for k, pos in pairs(position) do
                            usedPositions[pos.col][pos.line] = 1
                        end
                    end

                    self.specialAttackCount = self.specialAttackCount - 1
                    if self.specialAttackCount < 1 then
                        self.isSpecial = false
                    end
                else
                    self.color = {1, 0, 0}
                    love.audio.play(wrongEffect)
                end
            else
                if usedPositions[self.column][self.line] > 0 then
                    self.color = {1, 0, 0}
                    love.audio.play(wrongEffect)
                else
                    usedPositions[self.column][self.line] = 1
                end
            end

            self.time = 0
        end
    end
end

function Cursor:draw()
    local r, g, b = self.color[1], self.color[2], self.color[3]
    love.graphics.setColor(r, g, b)

    local marginX = self.isPlayerCursor and computerGridPositionX or 0
    local centerX = (self.column * 40) + marginX + 38 / 2
    local centerY = (self.line * 40) + 38 / 2

    if self.isSpecial then
        marginX = self.isPlayerCursor and computerGridPositionX or 0
        centerX = (self.column * 40) + marginX + (39 * 3) / 2
        centerY = (self.line * 40) + (39 * 3) / 2
    end

    local rectangleLength = self.isSpecial and 39 * 3 or 38
    local lineLength = self.isSpecial and 19 * 3 or 19

    love.graphics.rectangle("line", (self.column * 40) + marginX, (self.line * 40), rectangleLength, rectangleLength, 2,
        2)

    love.graphics.setLineWidth(self.isSpecial and 3 or 2)
    love.graphics.line(centerX, centerY - lineLength, centerX, centerY + lineLength)
    love.graphics.line(centerX - lineLength, centerY, centerX + lineLength, centerY)

    love.graphics.setColor(1, 1, 1)

end

function Cursor:move(dt)
    if self.time > 0.25 and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
        if (self.line > 1) then
            love.audio.play(moveShipEffect)
            self.line = self.line - 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.line = self.isSpecial and grid.linesQuantity - 2 or grid.linesQuantity
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
            self.column = self.isSpecial and grid.columnsQuantity - 2 or grid.columnsQuantity
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
        if not (self.column >= (self.isSpecial and grid.columnsQuantity - 2 or grid.columnsQuantity)) then
            love.audio.play(moveShipEffect)
            self.column = self.column + 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.column, self.time = 1, 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
        if not (self.line >= (self.isSpecial and grid.linesQuantity - 2 or grid.linesQuantity)) then
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

function Cursor:getTargetsPosition()
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

function Cursor:isPositionFree()
    local cursorPositions = self:getTargetsPosition()

    local usedPositions = self.isPlayerCursor and game.usedComputerPositions or game.usedPlayerPositions

    for k, position in pairs(cursorPositions) do
        for k, pos in pairs(position) do
            if usedPositions[pos.col][pos.line] > 0 then
                return false
            end
        end
    end

    return true
end

