MainGame = Class:extend()

function MainGame:new()
    backgound = love.graphics.newImage("assets/mainGame.jpg")

    navalBattleText = "BATALHA NAVAL"
    navalBattleTextWhite = love.graphics.newText(font90, navalBattleText)
    navalBattleTextBlack = love.graphics.newText(font90, {{0, 0, 0}, navalBattleText})

    playText = "Pressione espaço para jogar"
    playTextWhite = love.graphics.newText(font40, playText)
    playTextBlack = love.graphics.newText(font40, {{0, 0, 0}, playText})

    copyrightText = "© Copyright G.E.R."
    copyrightTextWhite = love.graphics.newText(font20, copyrightText)
    copyrightTextBlack = love.graphics.newText(font20, {{0, 0, 0}, copyrightText})

    navalBattleTextX, navalBattleTextY = (windowWidth - navalBattleTextWhite:getWidth()) / 2,
        ((windowHeight - navalBattleTextWhite:getHeight()) / 2) - 50

    playTextX, playTextY = (windowWidth - playTextWhite:getWidth()) / 2,
        ((windowHeight - playTextWhite:getHeight()) / 2) + 150
    playTextGoingUp, playTextCount = false, 0

    copyrightTextX, copyrightTextY = windowWidth - copyrightTextWhite:getWidth() - 5,
        windowHeight - copyrightTextWhite:getHeight() - 5
end

function MainGame:update(dt)
    if love.keyboard.isDown("space") then
        currentScene = "game"
    end

    self:movePlayText(dt)
end

function MainGame:draw()
    love.graphics.draw(backgound)

    love.graphics.draw(navalBattleTextBlack, navalBattleTextX + 6, navalBattleTextY + 6)
    love.graphics.draw(navalBattleTextWhite, navalBattleTextX, navalBattleTextY)
    love.graphics.draw(playTextBlack, playTextX + 6, playTextY + 6)
    love.graphics.draw(playTextWhite, playTextX, playTextY)

    love.graphics.draw(copyrightTextBlack, copyrightTextX + 3, copyrightTextY + 3)
    love.graphics.draw(copyrightTextWhite, copyrightTextX, copyrightTextY)

end

function MainGame:movePlayText(dt)
    if playTextCount > 5 then
        playTextGoingUp = false

    elseif playTextCount < 0 then
        playTextGoingUp = true

    end

    if playTextGoingUp then
        playTextY = playTextY + 15 * dt
        playTextCount = playTextCount + 1
    else
        playTextY = playTextY - 15 * dt
        playTextCount = playTextCount - 1
    end
end
