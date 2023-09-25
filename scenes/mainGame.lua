MainGame = Class:extend()

function MainGame:new()
    mainGameSong = love.audio.newSource("sounds/mainGame.mp3", "stream")
    startGameEffect = love.audio.newSource("sounds/startGame.wav", "static")

    backgound = love.graphics.newImage("assets/mainGame2.jpg")
    backgoundPosition = windowHeight + 60

    navalBattleText = "BATALHA NAVAL"
    navalBattleTextWhite = love.graphics.newText(font90, navalBattleText)
    navalBattleTextBlack = love.graphics.newText(font90, {{0, 0, 0}, navalBattleText})

    playText = "Pressione espaço para jogar"
    playTextWhite = love.graphics.newText(font40, playText)
    playTextBlack = love.graphics.newText(font40, {{0, 0, 0}, playText})

    copyrightText = "Copyright ©2023 G.E.R."
    copyrightTextWhite = love.graphics.newText(font20, copyrightText)
    copyrightTextBlack = love.graphics.newText(font20, {{0, 0, 0}, copyrightText})

    navalBattleTextX, navalBattleTextY = (windowWidth - navalBattleTextWhite:getWidth()) / 2,
        ((windowHeight - navalBattleTextWhite:getHeight()) / 2) * 4

    playTextX, playTextY = windowWidth, windowHeight

    playTextGoingUp, playTextCount = false, 0

    copyrightTextX, copyrightTextY = windowWidth, windowHeight - copyrightTextWhite:getHeight() - 5
end

function MainGame:update(dt)
    if love.keyboard.isDown("space") then
        love.audio.stop(mainGameSong)
        love.audio.play(startGameEffect)
        currentScene = "setup"
    end

    self:initialAnimation(dt)
    self:movePlayText(dt)

end

function MainGame:draw()
    love.graphics.setColor(love.math.colorFromBytes(165, 230, 255))
    love.graphics.setBackgroundColor(love.math.colorFromBytes(0, 10, 50))

    if backgoundPosition > 40 then
        inspirationGameText = love.graphics.newText(font30,
            "Esse jogo foi inspirado no jogo Battleship do NES (Nintendinho)")
        love.graphics.draw(inspirationGameText, 15, 15)
    end

    love.window.setTitle("Batalha Naval")

    love.audio.play(mainGameSong)

    love.graphics.setColor(love.math.colorFromBytes(100, 200, 255, 255))
    love.graphics.draw(backgound, 0, backgoundPosition)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(navalBattleTextBlack, navalBattleTextX + 6, navalBattleTextY + 6)
    love.graphics.draw(navalBattleTextWhite, navalBattleTextX, navalBattleTextY)
    love.graphics.draw(playTextBlack, playTextX + 6, playTextY + 6)
    love.graphics.draw(playTextWhite, playTextX, playTextY)

    love.graphics.draw(copyrightTextBlack, copyrightTextX + 3, copyrightTextY + 3)
    love.graphics.draw(copyrightTextWhite, copyrightTextX, copyrightTextY)
end

function MainGame:initialAnimation(dt)
    if backgoundPosition > 0 then
        backgoundPosition = backgoundPosition - 10 * 15 * dt
    elseif backgoundPosition < 0 then
        backgoundPosition = 0
    end

    if copyrightTextX > windowWidth - copyrightTextWhite:getWidth() - 5 then
        copyrightTextX = copyrightTextX - 5 * 8 * dt
    elseif copyrightTextX < windowWidth - copyrightTextWhite:getWidth() - 5 then
        copyrightTextX = windowWidth - copyrightTextWhite:getWidth() - 5
    end

    if navalBattleTextY > (windowHeight - navalBattleTextWhite:getHeight()) / 2 - 30 then
        navalBattleTextY = navalBattleTextY - 10 * 15 * dt
    elseif navalBattleTextY < (windowHeight - navalBattleTextWhite:getHeight()) / 2 - 30 then
        navalBattleTextY = (windowHeight - navalBattleTextWhite:getHeight()) / 2 - 30

        playTextX, playTextY = (windowWidth - playTextWhite:getWidth()) / 2,
            ((windowHeight - playTextWhite:getHeight()) / 2) + 150
    end
end

function MainGame:movePlayText(dt)
    if playTextCount > 5 then
        playTextGoingUp = false

    elseif playTextCount < 0 then
        playTextGoingUp = true

    end

    if playTextGoingUp then
        playTextY = playTextY + 20 * dt
        playTextCount = playTextCount + 1
    else
        playTextY = playTextY - 20 * dt
        playTextCount = playTextCount - 1
    end
end
