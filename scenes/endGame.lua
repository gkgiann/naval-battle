EndGame = Class:extend()

function EndGame:new()
    self.isPlayerWin = true
    self.winTheme = love.audio.newSource("sounds/winTheme.mp3", "stream")
    self.loseTheme = love.audio.newSource("sounds/loseTheme.mp3", "stream")

    self.backgound = love.graphics.newImage("assets/backgrounds/mainGame.jpg")
    self.time = 0
    self.playerName = ""

    self.letters = {
        a = "a",
        b = "b",
        c = "c",
        d = "d",
        e = "e",
        f = "f",
        g = "g",
        h = "h",
        i = "i",
        j = "j",
        k = "k",
        l = "l",
        m = "m",
        n = "n",
        o = "o",
        p = "p",
        q = "q",
        r = "r",
        s = "s",
        t = "t",
        u = "u",
        v = "v",
        w = "w",
        x = "x",
        y = "y",
        z = "z"
    }

end

function EndGame:update(dt)
    self.time = self.time + dt

    if self.time > 0.15 then
        self:inputPlayerName()
    end
end

function EndGame:draw()
    love.window.setTitle("Fim de jogo")
    love.audio.play(self.isPlayerWin and self.winTheme or self.loseTheme)
    love.graphics.setBackgroundColor(love.math.colorFromBytes(0, 10, 50))

    love.graphics.setColor(love.math.colorFromBytes(100, 200, 255, 100))
    love.graphics.draw(self.backgound, 0, 0)
    love.graphics.setColor(1, 1, 1)

    local textTitle = self.isPlayerWin and "Parabéns, você venceu!" or "Que pena, você perdeu!"
    local colors = self.isPlayerWin and {0, 1, 0} or {1, 0, 0}

    local title = love.graphics.newText(font50, {colors, textTitle})
    local titleX, titleY = (windowWidth - title:getWidth()) / 2, 50
    love.graphics.draw(title, titleX, titleY)

    self:showPlayerDetails()

    local text = love.graphics.newText(font40, "Digite seu nome")
    love.graphics.draw(text, 750, 200)

    local playerName = love.graphics.newText(font30, self.playerName)
    love.graphics.draw(playerName, 750, 300)

    local enterToContinue = love.graphics.newText(font30, "Aperte 'Enter' para salvar")
    love.graphics.draw(enterToContinue, 750, 370)
end

function EndGame:showPlayerDetails()
    local shotsQuantity, hitsQuantity, playerTimeInSeconds = game.playerStatistics.shots, game.playerStatistics.hits,
        game.playerStatistics.time

    local text = string.format('Total de tiros    %d', shotsQuantity)
    local shots = love.graphics.newText(font30, text)

    text = string.format("Tiros certos      %d", hitsQuantity)
    local hits = love.graphics.newText(font30, text)

    local timeFormatted = self:formatSeconds(playerTimeInSeconds)

    text = string.format("Tempo jogado    %s", timeFormatted)
    local time = love.graphics.newText(font30, text)

    local statistics = love.graphics.newText(font40, "Estatísticas")

    local y = 200

    love.graphics.draw(statistics, 100, y)
    y = y + 100
    love.graphics.draw(shots, 100, y)
    y = y + 50
    love.graphics.draw(hits, 100, y)
    y = y + 50
    love.graphics.draw(time, 100, y)
end

function EndGame:inputPlayerName()
    for k, letter in pairs(self.letters) do
        if love.keyboard.isDown(letter) then
            self.playerName = string.format("%s%s", self.playerName, letter)

            self.time = 0
        end

        if love.keyboard.isDown("backspace") then
            self.playerName = ""

            self.time = 0
        end

        if love.keyboard.isDown("return") then
            if #self.playerName > 3 then
                -- trocar para a tela de ranking

                -- love.audio.stop()
                -- currentScene = ""
            end
        end
    end
end

function EndGame:formatSeconds(seconds)
    local minutes = math.floor(seconds / 60)
    local secondsRemaining = seconds % 60

    return string.format("%02d:%02d", minutes, secondsRemaining)
end
