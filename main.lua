function love.load()

    -- Músicas do battleship (NES)
    -- https://downloads.khinsider.com/game-soundtracks/album/battleship-nes

    -- IMPORTANDO OUTROS ARQUIVOS
    Class = require "classic"
    require "scenes/setup"
    require "scenes/game"
    require "scenes/mainGame"
    require "scenes/classes/ship"

    -- TAMANHO DA JANELA
    windowWidth = 1334
    windowHeight = 768
    love.window.setMode(windowWidth, windowHeight)

    -- EFEITOS SONOROS
    wrongEffect = love.audio.newSource("sounds/wrong.wav", "static")
    moveShipEffect = love.audio.newSource("sounds/moveShip.mp3", "static")

    -- FONTES
    font20 = love.graphics.newFont("fonts/wheatonCapitals.otf", 20)
    font30 = love.graphics.newFont("fonts/wheatonCapitals.otf", 30)
    font40 = love.graphics.newFont("fonts/wheatonCapitals.otf", 40)
    font90 = love.graphics.newFont("fonts/wheatonCapitals.otf", 90)
    love.graphics.setFont(font20)

    -- TAMANHO DO TABULEIRO
    grid = {
        -- columnsQuantity = 15,
        -- linesQuantity = 10,
        columnsQuantity = 12,
        linesQuantity = 8
    }

    -- INSTANCIANDO AS CENAS/TELAS
    setup = Setup()
    mainGame = MainGame()
    game = Game()

    scenes = {
        mainGame = mainGame,
        setup = setup,
        game = game
    }

    currentScene = "setup"
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
