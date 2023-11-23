Ranking = Class:extend()

function Ranking:new()
    self.theme = love.audio.newSource("sounds/ranking.mp3", "stream")
    self.backgound = love.graphics.newImage("assets/backgrounds/game.jpg")
end

function Ranking:update(dt)
    if love.keyboard.isDown("return") then
        love.audio.stop()
        reset()
    end
end

function Ranking:draw()
    love.window.setTitle("Ranking")
    love.audio.play(self.theme)
    love.graphics.setBackgroundColor(love.math.colorFromBytes(0, 10, 50))

    love.graphics.setColor(love.math.colorFromBytes(100, 200, 255, 100))
    love.graphics.draw(self.backgound, 0, 0)
    love.graphics.setColor(1, 1, 1)

    local textTitle = "Ranking dos jogadores"
    local title = love.graphics.newText(font50, textTitle)
    local titleX, titleY = (windowWidth - title:getWidth()) / 2, 50
    love.graphics.draw(title, titleX, titleY)

    local players = findPlayers()

    for i, player in ipairs(players) do
        local namePlayer = string.format("%dº %s | %s | %d tiros | %s", i, player.name,
            player.won and "venceu" or "perdeu", player.shots, self:formatSeconds(player.time))
        local name = love.graphics.newText(font30, namePlayer)

        local nameX, nameY = 50, 150 + (50 * i)
        love.graphics.draw(name, nameX, nameY)
    end

    local textTitle = "Pressione 'Enter' para \nvoltar ao menu principal"
    local title = love.graphics.newText(font30, textTitle)
    local titleX, titleY = 850, 200
    love.graphics.draw(title, titleX, titleY)

end

function Ranking:formatSeconds(seconds)
    local minutes = math.floor(seconds / 60)
    local secondsRemaining = seconds % 60

    return string.format("%02d:%02d", minutes, secondsRemaining)
end
