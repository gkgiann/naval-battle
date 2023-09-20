function love.load()

    -- Músicas do battleship (NES)
    -- https://downloads.khinsider.com/game-soundtracks/album/battleship-nes

    -- IMPORTANDO OUTROS ARQUIVOS
    Class = require "classic"
    require "scenes/setup"
    require "scenes/mainGame"

    -- TAMANHO DA JANELA
    windowWidth = 1334
    windowHeight = 768
    love.window.setMode(windowWidth, windowHeight)

    -- FONTES
    font20 = love.graphics.newFont("fonts/wheatonCapitals.otf", 20)
    font40 = love.graphics.newFont("fonts/wheatonCapitals.otf", 40)
    font90 = love.graphics.newFont("fonts/wheatonCapitals.otf", 90)
    love.graphics.setFont(font20)

    -- INSTANCIANDO AS CENAS/TELAS
    setup = Setup()
    mainGame = MainGame()

    scenes = {
        mainGame = mainGame,
        setup = setup
    }

    currentScene = "mainGame"
end

function love.update(dt)
    scenes[currentScene]:update(dt)

    if love.keyboard.isDown("q") then
        love.event.quit()
    end

end

function love.draw()
    scenes[currentScene]:draw()
end
