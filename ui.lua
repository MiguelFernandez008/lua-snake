-- PLAYGROUND
local playground = require("playground")

local ui
ui = {}
ui.color = { 1, 1, 1, 1 }
ui.scoreX = cellSize * 1
ui.scoreY = cellSize * 1
ui.livesX = gridXCount * cellSize - (cellSize * 7)
ui.livesY = cellSize * 1
ui.draw = function()
    love.graphics.setColor(ui.color)
    love.graphics.line(playground.startX, playground.startY, playground.endX, playground.startY)
    love.graphics.printf("Puntuación: " .. score, ui.scoreX, ui.scoreY, cellSize * (gridXCount / 2))
    love.graphics.printf("Vidas: " .. lives, ui.livesX, ui.livesY, cellSize * (gridXCount / 2))
end
ui.update = function (delta)

end
return ui