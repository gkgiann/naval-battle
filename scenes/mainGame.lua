MainGame = Class:extend()

function MainGame:new()
    self.mainGameSong = love.audio.newSource("sounds/mainGame.mp3", "stream")
    self.startGameEffect = love.audio.newSource("sounds/startGame.wav", "static")

    self.backgound = love.graphics.newImage("assets/mainGame.jpg")
    self.backgoundPosition = windowHeight + 60

    self.navalBattleText = "BATALHA NAVAL"
    self.navalBattleTextWhite = love.graphics.newText(font90, self.navalBattleText)
    self.navalBattleTextBlack = love.graphics.newText(font90, {{0, 0, 0}, self.navalBattleText})

    self.playText = "Pressione espaço para jogar"
    self.playTextWhite = love.graphics.newText(font40, self.playText)
    self.playTextBlack = love.graphics.newText(font40, {{0, 0, 0}, self.playText})

    self.copyrightText = "Copyright ©2023 G.E.R."
    self.copyrightTextWhite = love.graphics.newText(font20, self.copyrightText)
    self.copyrightTextBlack = love.graphics.newText(font20, {{0, 0, 0}, self.copyrightText})

    self.navalBattleTextX, self.navalBattleTextY = (windowWidth - self.navalBattleTextWhite:getWidth()) / 2,
        ((windowHeight - self.navalBattleTextWhite:getHeight()) / 2) * 4

    self.playTextX, self.playTextY = windowWidth, windowHeight

    self.playTextGoingUp, self.playTextCount = false, 0

    self.copyrightTextX, self.copyrightTextY = windowWidth, windowHeight - self.copyrightTextWhite:getHeight() - 5

    self.time = 0
end

function MainGame:update(dt)
    self.time = self.time + dt

    if love.keyboard.isDown("space") then
        love.audio.stop(self.mainGameSong)
        love.audio.play(self.startGameEffect)
        currentScene = "setup"
    end

    if self.time > 0.3 and love.keyboard.isDown("return") then
        love.audio.play(moveShipEffect)

        if grid.linesQuantity == 8 then
            grid.linesQuantity, grid.columnsQuantity = 10, 15
        else
            grid.linesQuantity, grid.columnsQuantity = 8, 12
        end

        self.time = 0
    end

    self:initialAnimation(dt)
    self:movePlayText(dt)

end

function MainGame:draw()
    love.graphics.setBackgroundColor(love.math.colorFromBytes(0, 10, 50))
    love.window.setTitle("Batalha Naval")

    love.audio.play(self.mainGameSong)

    love.graphics.setColor(love.math.colorFromBytes(100, 200, 255, 255))
    love.graphics.draw(self.backgound, 0, self.backgoundPosition)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.navalBattleTextBlack, self.navalBattleTextX + 6, self.navalBattleTextY + 6)
    love.graphics.draw(self.navalBattleTextWhite, self.navalBattleTextX, self.navalBattleTextY)
    love.graphics.draw(self.playTextBlack, self.playTextX + 6, self.playTextY + 6)
    love.graphics.draw(self.playTextWhite, self.playTextX, self.playTextY)

    love.graphics.draw(self.copyrightTextBlack, self.copyrightTextX + 3, self.copyrightTextY + 3)
    love.graphics.draw(self.copyrightTextWhite, self.copyrightTextX, self.copyrightTextY)

    if self.backgoundPosition > 0 then
        local inspirationGameText = love.graphics.newText(font30, {{0, 0, 0},
                                                                   "Esse jogo foi inspirado no jogo Battleship do NES (Nintendinho)"})
        love.graphics.draw(inspirationGameText, 15, 18)

        inspirationGameText = love.graphics.newText(font30,
            "Esse jogo foi inspirado no jogo Battleship do NES (Nintendinho)")
        love.graphics.draw(inspirationGameText, 15, 15)

    else
        local text = string.format('Tamanho do tabuleiro: %dx%d', grid.linesQuantity, grid.columnsQuantity)

        local gridText = love.graphics.newText(font30, {{0, 0, 0}, text})
        love.graphics.draw(gridText, 18, 20)
        gridText = love.graphics.newText(font30, text)
        love.graphics.draw(gridText, 15, 15)

        local changeGridLength = love.graphics.newText(font30, {{0, 0, 0}, "Pressione enter para alterar"})
        love.graphics.draw(changeGridLength, 18, 65)
        changeGridLength = love.graphics.newText(font30, "Pressione enter para alterar")
        love.graphics.draw(changeGridLength, 15, 60)
    end
end

function MainGame:initialAnimation(dt)
    if self.backgoundPosition > 0 then
        self.backgoundPosition = self.backgoundPosition - 10 * 15 * dt
    elseif self.backgoundPosition < 0 then
        self.backgoundPosition = 0
    end

    if self.copyrightTextX > windowWidth - self.copyrightTextWhite:getWidth() - 5 then
        self.copyrightTextX = self.copyrightTextX - 5 * 8 * dt
    elseif self.copyrightTextX < windowWidth - self.copyrightTextWhite:getWidth() - 5 then
        self.copyrightTextX = windowWidth - self.copyrightTextWhite:getWidth() - 5
    end

    if self.navalBattleTextY > (windowHeight - self.navalBattleTextWhite:getHeight()) / 2 - 30 then
        self.navalBattleTextY = self.navalBattleTextY - 10 * 15 * dt
    elseif self.navalBattleTextY < (windowHeight - self.navalBattleTextWhite:getHeight()) / 2 - 30 then
        self.navalBattleTextY = (windowHeight - self.navalBattleTextWhite:getHeight()) / 2 - 30

        self.playTextX, self.playTextY = (windowWidth - self.playTextWhite:getWidth()) / 2,
            ((windowHeight - self.playTextWhite:getHeight()) / 2) + 150
    end
end

function MainGame:movePlayText(dt)
    if self.playTextCount > 5 then
        self.playTextGoingUp = false

    elseif self.playTextCount < 0 then
        self.playTextGoingUp = true

    end

    if self.playTextGoingUp then
        self.playTextY = self.playTextY + 20 * dt
        self.playTextCount = self.playTextCount + 1
    else
        self.playTextY = self.playTextY - 20 * dt
        self.playTextCount = self.playTextCount - 1
    end
end
