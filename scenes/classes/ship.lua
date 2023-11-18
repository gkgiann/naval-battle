Ship = Class:extend()

function Ship:new(len)
    self.isComputerShip = false
    self.line = 1
    self.column = 1
    self.isUp = false
    self.isSet = false
    self.isCurrentSelected = false
    self.moveBlocked = false
    self.length = len
    self.img = love.graphics.newImage(string.format('assets/ships/ship%d.png', len))
    self.time = 0
    self.color = {
        r = 1,
        g = 1,
        b = 1
    }
    self.destroyedParts = {}

    for i = 1, self.length do
        self.destroyedParts[i] = false
    end

end

function Ship:update(dt)
    self.time = self.time + dt

    if self.time > 0.25 then
        self.color.r, self.color.g, self.color.b = 1, 1, 1
    end

    if self.isCurrentSelected and not self.isComputerShip and not self.moveBlocked then
        self:move(dt)
    end
end

function Ship:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)

    local isAllDestroyed = self:isShipDestroyed()

    if self.isSet or self.isCurrentSelected or isAllDestroyed then
        if self.isSet then
            love.graphics.setColor(0, 1, 0)
        end

        local plus = self.length < 5 and self.length * self.length or (self.length * self.length) - 8
        local marginX = self.isComputerShip and (40 * grid.columnsQuantity) + 54 or 0

        if grid.columnsQuantity == 12 and self.isComputerShip then
            marginX = marginX + 240
        end

        if self.isUp then
            love.graphics.draw(self.img, ((40 * self.column) + 35) + marginX, (40 * self.line) + plus, math.rad(90))
        else
            love.graphics.draw(self.img, ((40 * self.column) + plus) + marginX, (40 * self.line) + 2, 0)
        end

    end

    for k, isPartDestroyed in pairs(self.destroyedParts) do
        if isPartDestroyed then

            local alpha = isAllDestroyed and 150 or 230
            local gridPosition = self.isComputerShip and computerGridPositionX or 0

            love.graphics.setColor(love.math.colorFromBytes(255, 0, 0, alpha))

            if self.isUp then
                love.graphics.rectangle("fill", self.column * 40 + gridPosition, (self.line + (k - 1)) * 40,
                    38, 38, 2, 2)
            else
                love.graphics.rectangle("fill", (self.column + (k - 1)) * 40 + gridPosition, self.line * 40,
                    38, 38, 2, 2)
            end

            love.graphics.setColor(1, 1, 1)
        end
    end

    love.graphics.setColor(1, 1, 1)

end

function Ship:move(dt)
    if self.time > 0.25 and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
        canRotate = true

        if self.isUp then
            if self.column >= grid.columnsQuantity - (self.length - 2) then
                canRotate = false
                love.audio.play(wrongEffect)
                self.color.r, self.color.g, self.color.b = 1, 0, 0
            end
        end

        if not self.isUp then
            if self.line >= grid.linesQuantity - (self.length - 2) then
                canRotate = false
                love.audio.play(wrongEffect)
                self.color.r, self.color.g, self.color.b = 1, 0, 0
            end
        end

        if canRotate then
            love.audio.play(moveShipEffect)
            self.isUp = not self.isUp
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
        if (self.line > 1) then
            love.audio.play(moveShipEffect)
            self.line = self.line - 1
            self.time = 0
        else
            love.audio.play(moveShipEffect)
            self.line = self.isUp and grid.linesQuantity - (self.length - 1) or grid.linesQuantity
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
            self.column = self.isUp and grid.columnsQuantity or grid.columnsQuantity - (self.length - 1)
            self.time = 0
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
        if self.isUp then
            if not (self.column >= grid.columnsQuantity) then
                love.audio.play(moveShipEffect)
                self.column = self.column + 1
                self.time = 0
            else
                love.audio.play(moveShipEffect)
                self.column, self.time = 1, 0
            end
        end

        if not self.isUp then
            if not (self.column >= grid.columnsQuantity - (self.length - 1)) then
                love.audio.play(moveShipEffect)
                self.column = self.column + 1
                self.time = 0
            else
                love.audio.play(moveShipEffect)
                self.column, self.time = 1, 0
            end
        end
    end

    if self.time > 0.25 and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
        if self.isUp then
            if not (self.line >= grid.linesQuantity - (self.length - 1)) then
                love.audio.play(moveShipEffect)
                self.line = self.line + 1
                self.time = 0
            else
                love.audio.play(moveShipEffect)
                self.line, self.time = 1, 0
            end
        end

        if not self.isUp then
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

end

function Ship:getMatrixPosition()
    positions = {}

    positions[1] = {}
    positions[1].column = self.column
    positions[1].line = self.line

    for i = 2, self.length do
        positions[i] = {}

        positions[i].column = self.isUp and self.column or self.column + (i - 1)
        positions[i].line = self.isUp and self.line + (i - 1) or self.line
    end

    return positions
end

function Ship:isShipDestroyed()
    local destroyedsQuantity = 0

    for k, isPartDestroyed in pairs(self.destroyedParts) do
        if isPartDestroyed then
            destroyedsQuantity = destroyedsQuantity + 1
        end
    end

    return destroyedsQuantity == self.length
end
