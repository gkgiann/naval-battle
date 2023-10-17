Shot = Class:extend()

function Shot:new(isPlayerShot)
    self.isPlayerShot = isPlayerShot and isPlayerShot or false
    self.isSpecial = false
    self.specialAttackCount = 2
    self.targets = {Target(self.isPlayerShot), Target(self.isPlayerShot), Target(self.isPlayerShot)}
    self.specialTarget = SpecialTarget(self.isPlayerShot)
    self.currentTargetIndex = 1
    self.time = 0
    self.iTimeControl = 1
    self.setTargetEffect = love.audio.newSource("sounds/startGame.wav", "static")
end

function Shot:update(dt)
    self.time = self.time + dt

    if self.time > 0.3 and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
        if self.specialAttackCount > 0 then
            self.isSpecial = not self.isSpecial
            love.audio.play(moveShipEffect)
        end

        self.time = 0
    end

    if self.isSpecial then
        self.specialTarget:update(dt)

        if self.time > 0.25 and not self.specialTarget.isSet and love.keyboard.isDown("return") then
            self.specialTarget.isSet = true
            self.time = 0
            love.audio.play(initialHitEffect)
        end

        if self.time > 2 and self.specialTarget.isSet then
            self.specialTarget:verifyIfHitShip()
            love.audio.play(hitEffect)

            self.specialAttackCount = self.specialAttackCount - 1

            self:reset()

            self.time = 0
            self.isSpecial = false
        end

    else
        if not (self.currentTargetIndex > #self.targets) then
            local currentTarget = self.targets[self.currentTargetIndex]
            currentTarget.isCurrentSelected = true

            currentTarget:update(dt)

            if self.time > 0.3 and self.currentTargetIndex <= #self.targets and love.keyboard.isDown("return") then

                if currentTarget:isPositionFree() then
                    self.currentTargetIndex = self.currentTargetIndex + 1

                    currentTarget.isCurrentSelected = false
                    currentTarget.isSet = true

                    love.audio.play(self.setTargetEffect)
                    self.time = 0

                end

            end
        else
            if self.time > 1 and self.iTimeControl <= 3 then
                self.targets[self.iTimeControl]:verifyIfHitShip()
                love.audio.play(hitEffect)

                self.time = 0
                self.iTimeControl = self.iTimeControl + 1
            elseif self.time > 1.5 and self.iTimeControl > 3 then
                self:reset()

                self.time = 0
            end
        end
    end
end

function Shot:draw()
    if self.isSpecial then
        self.specialTarget:draw()
    else
        for k, target in pairs(self.targets) do
            if target.isCurrentSelected or target.isSet then
                target:draw()
            end
        end
    end
end

function Shot:reset()
    self.isSpecial = false
    self.targets = {Target(self.isPlayerShot), Target(self.isPlayerShot), Target(self.isPlayerShot)}
    self.specialTarget = SpecialTarget(self.isPlayerShot)
    self.currentTargetIndex = 1
    self.iTimeControl = 1
    self.time = 0
end
