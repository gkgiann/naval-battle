Ship = Class:extend()

function Ship:new(len)
    self.line = 1
    self.column = 1
    self.isUp = false
    self.length = len
    self.img = love.graphics.newImage(string.format('assets/ship%d.png', len))
    self.time = 0

end

function Ship:update(dt)
    self.time = self.time + dt

    self:move(dt)

end

function Ship:draw()
    if self.isUp then
        love.graphics.draw(self.img, (32 * self.line) + 30, self.column * 32, math.rad(90))
    else
        love.graphics.draw(self.img, (32 * self.line), (32 * self.column), 0)

    end
end

function Ship:move(dt)

    if self.time > 0.2 and love.keyboard.isDown("rshift") then
        -- if self.isUp then
        --     if self.length - 1 then
                
        --     end
        -- end

        self.isUp = not self.isUp
        self.time = 0
    end

    if self.time > 0.2 and love.keyboard.isDown("up") then
        if (self.column > 1) then
            self.column = self.column - 1
            self.time = 0
        end

    end

    if self.time > 0.2 and love.keyboard.isDown("left") then
        if (self.line > 1) then
            self.line = self.line - 1
            self.time = 0
        end
    end

    if self.time > 0.2 and love.keyboard.isDown("right") then
        if self.isUp then
            if not (self.line >= 15) then
                self.line = self.line + 1
                self.time = 0
            end
        end

        if not self.isUp then
            if not (self.line >= 15 - (self.length - 1)) then
                self.line = self.line + 1
                self.time = 0
            end
        end
    end

    if self.time > 0.2 and love.keyboard.isDown("down") then
        if self.isUp then
            if not (self.column >= 10 - (self.length - 1)) then
                self.column = self.column + 1
                self.time = 0
            end
        end

        if not self.isUp then
            if not (self.column >= 10) then
                self.column = self.column + 1
                self.time = 0
            end
        end
    end

end
