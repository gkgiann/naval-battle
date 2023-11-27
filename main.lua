function love.load()

    -- Músicas do battleship (NES)
    -- https://downloads.khinsider.com/game-soundtracks/album/battleship-nes

    -- IMPORTANDO OUTROS ARQUIVOS
    Class = require "lib/classic"
    require "scenes/setup"
    require "scenes/game"
    require "scenes/mainGame"
    require "scenes/endGame"
    require "scenes/ranking"
    require "scenes/classes/ship"
    require "scenes/classes/target"
    require "scenes/classes/specialTarget"
    require "scenes/classes/shot"

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
    ranking = Ranking()

    scenes = {
        mainGame = mainGame,
        setup = setup,
        game = game,
        endGame = endGame,
        ranking = ranking
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

function reset()
    setup = Setup()
    mainGame = MainGame()
    game = Game()
    endGame = EndGame()
    ranking = Ranking()

    scenes = {
        mainGame = mainGame,
        setup = setup,
        game = game,
        endGame = endGame,
        ranking = ranking
    }

    currentScene = "mainGame"
end

function savePlayersToFile(players)
    local file = io.open("ranking.txt", "w")

    for _, player in ipairs(players) do
        file:write(string.format("%s %d %d %d\n", player.name, player.shots, player.time, player.won and 1 or 0))
    end

    file:close()
end

function addNewPlayerToRanking(name, totalShots, time, won)
    local players = findPlayers()
    local player = {
        name = name,
        shots = totalShots,
        time = time,
        won = won
    }

    table.insert(players, player)
    savePlayersToFile(players)
end

function findPlayers()
    local players = {}
    local file = io.open("ranking.txt", "r")

    if file then
        for line in file:lines() do
            local name, shots, playtime, won = line:match("(%S+) (%d+) (%d+) (%d+)")
            table.insert(players, {
                name = name,
                shots = tonumber(shots),
                time = tonumber(playtime),
                won = tonumber(won) == 1
            })
        end

        file:close()

        table.sort(players, function(a, b)
            if a.won ~= b.won then
                return a.won
            elseif a.shots ~= b.shots then
                return a.shots < b.shots
            else
                return a.time < b.time
            end
        end)
    end

    return players
end
