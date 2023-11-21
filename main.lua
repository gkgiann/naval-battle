function love.load()

    -- Músicas do battleship (NES)
    -- https://downloads.khinsider.com/game-soundtracks/album/battleship-nes

    -- IMPORTANDO OUTROS ARQUIVOS
    Class = require "lib/classic"
    require "scenes/setup"
    require "scenes/game"
    require "scenes/mainGame"
    require "scenes/endGame"
    require "scenes/classes/ship"
    require "scenes/classes/target"
    require "scenes/classes/specialTarget"
    require "scenes/classes/shot"
    require 'lib.sqlite3'

    -- TAMANHO DA JANELA
    windowWidth = 1334
    windowHeight = 768
    love.window.setMode(windowWidth, windowHeight)

    -- EFEITOS SONOROS
    wrongEffect = love.audio.newSource("sounds/wrong.wav", "static")
    moveShipEffect = love.audio.newSource("sounds/moveShip.mp3", "static")
    initialHitEffect = love.audio.newSource("sounds/hit0.wav", "static")
    hitEffect = love.audio.newSource("sounds/hit.wav", "static")

    -- FONTES
    font20 = love.graphics.newFont("fonts/wheatonCapitals.otf", 20)
    font30 = love.graphics.newFont("fonts/wheatonCapitals.otf", 30)
    font40 = love.graphics.newFont("fonts/wheatonCapitals.otf", 40)
    font50 = love.graphics.newFont("fonts/wheatonCapitals.otf", 50)
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
    endGame = EndGame()

    scenes = {
        mainGame = mainGame,
        setup = setup,
        game = game,
        endGame = endGame
    }

    currentScene = "mainGame"
end

function love.update(dt)
    scenes[currentScene]:update(dt)

    if love.keyboard.isDown("q") then
        love.window.close()
        love.event.quit()
    end

end

function love.draw()
    scenes[currentScene]:draw()
end

function createGrid(x, y)
    x, y = x and x or 0, y and y or 0

    love.graphics.setColor(love.math.colorFromBytes(50, 200, 255, 100))
    for i = 1, grid.columnsQuantity do
        for j = 1, grid.linesQuantity do
            love.graphics.rectangle("fill", (i * 40) + x, (j * 40) + y, 38, 38, 2, 2)
        end
    end
    love.graphics.setColor(1, 1, 1)

end
