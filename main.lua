-- PUSH
local push = require ("libs/push/push")

-- WINDOW
local gameWidth, gameHeight = 1024, 768
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

-- GLOBAL VARIABLES
gridXCount = 32
gridYcount = 24
cellSize = 32
lives = 3
score = 0
isHighScore = false
isGameOver = false

-- PLAYGROUND
local playground = require("playground")

-- UI Require
local ui = require("ui")

function love.load()      
    timerSpeed = 0.12
    foodPosition = {
        x = love.math.random(playground.startX, gridXCount),
        y = love.math.random(playground.startY, gridYCount),
    }
    reset()
    -- Fonts
    font = love.graphics.newFont("fonts/PressStart2P.ttf", 24)
    -- Keymap
    keyMap = {
        escape = function() love.event.quit(0) end,
        left = function() 
            if directionQueue[#directionQueue] ~= 'left' and directionQueue[#directionQueue] ~= 'right' then 
                table.insert(directionQueue, 'left') 
            end     
        end,
    right = function() 
        if directionQueue[#directionQueue] ~= 'right' and directionQueue[#directionQueue] ~= 'left' then 
            table.insert(directionQueue, 'right') 
        end     
    end,
    up = function() 
        if directionQueue[#directionQueue] ~= 'up' and directionQueue[#directionQueue] ~= 'down' then 
            table.insert(directionQueue, 'up') 
        end 
    end,
    down= function() 
        if directionQueue[#directionQueue] ~= 'down' and directionQueue[#directionQueue] ~= 'up' then
            table.insert(directionQueue, 'down') 
        end 
        end
    }  
end

function love.update(delta)
    local canMove = true
    timer = timer + delta
    if snakeAlive then
        if timer >= timerSpeed then    
            timer = 0        
        
        if #directionQueue > 1 then
            table.remove(directionQueue, 1)
        end
        
        local nextXPos = snakeSegments[1].x
        local nextYPos = snakeSegments[1].y
        
        if directionQueue[1] == 'left' then
            nextXPos = nextXPos - 1
            if nextXPos <= playground.startX then
                canMove = false
            end
        elseif directionQueue[1] == 'right' then
            nextXPos = nextXPos + 1
            if nextXPos > gridXCount then
                canMove = false
            end
        elseif directionQueue[1] == 'up' then
            nextYPos = nextYPos - 1
            if nextYPos <= playground.startY / cellSize then
                canMove = false
            end
        elseif directionQueue[1] == 'down' then
            nextYPos = nextYPos + 1
            if nextYPos > gridYcount then
                canMove = false
            end
        end
        for segmentIndex, segment in ipairs(snakeSegments) do
            if segmentIndex ~= #snakeSegments
                and nextXPos == segment.x
                and nextYPos == segment.y then
                canMove = false
            end
        end
        if canMove then
            table.insert(snakeSegments, 1, {x = nextXPos, y = nextYPos})
        
            if snakeSegments[1].x == foodPosition.x and snakeSegments[1].y == foodPosition.y then
                moveFood()
                score = score + 10
            else
                table.remove(snakeSegments)
            end    
        else
            handleSnakeDead()
            if isGameOver then
                fullReset()
            end
        end
        end
    elseif timer >= 2 then
        love.load()    
    end  
end

function love.draw() 
    push:start()
    love.graphics.setFont(font)  
    love.graphics.setColor(.28, .28, .28)
    love.graphics.rectangle(
      'fill',
      0,
      0,
      gridXCount * cellSize,
      gridYcount * cellSize
    )  
    for segmentIndex, segment in ipairs(snakeSegments) do
        if snakeAlive then
            love.graphics.setColor(.6, 1, .32)
        else
            love.graphics.setColor(.5, .5, .5)
        end
        drawCell(segment.x, segment.y)
    end
  
    love.graphics.setColor(1, .3, .3)
    drawCell(foodPosition.x, foodPosition.y)
    ui.draw()
    push:finish()
end

function love.keypressed(key)
  if(keyMap[key]) then
    keyMap[key]()
  end
end

function drawCell(x, y)
  love.graphics.rectangle(
    'fill',
    (x - 1) * cellSize,
    (y - 1) * cellSize,
    cellSize - 1,
    cellSize - 1
  )
end

function moveFood()
    local possibleFoodPositions = {}
    for foodX = 1, gridXCount do
        for foodY = 1, gridYcount do
        local possible = true                
        for segmentIndex, segment in ipairs(snakeSegments) do
            if foodX == segment.x and foodY == segment.y then
                possible = false
            end
            if foodY <= (playground.startY / cellSize) then
                possible = false
            end
        end                
        if possible then
            table.insert(possibleFoodPositions, {x = foodX, y = foodY})
        end
    end
  end
  foodPosition = possibleFoodPositions[love.math.random(#possibleFoodPositions)]
end

function increaseDifficulty()
    
end
function handleSnakeDead()
    snakeAlive = false
    if lives > 0 then
        lives = lives - 1
    else
        lives = 0
        isGameOver = true
    end
end
function reset()
    snakeSegments = {
        {x = 3, y = 4},
        {x = 2, y = 4},
        {x = 1, y = 4},
    }
    directionQueue = {'right'}
    snakeAlive = true
    timer = 0
    moveFood()
    isGameOver = false
end
function fullReset()
    lives = 3
    score = 0
end
