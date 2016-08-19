
love.graphics.setDefaultFilter("nearest", "nearest")

font = love.graphics.newImageFont("font.png",
  " abcdefghijklmnopqrstuvwxyz" ..
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  "123456789.,!?-+/():;%&`'*#=[]\"", 1)
love.graphics.setFont(font)
gui = love.graphics.newImage("gui.png")

buttonRight = love.graphics.newQuad(0, 0, 3, 16, gui:getDimensions())
buttonMid = love.graphics.newQuad(3, 0, 26, 16, gui:getDimensions())
buttonLeft = love.graphics.newQuad(29, 0, 3, 16, gui:getDimensions())

fieldRight = love.graphics.newQuad(32, 0, 3, 16, gui:getDimensions())
fieldMid = love.graphics.newQuad(35, 0, 26, 16, gui:getDimensions())
fieldLeft = love.graphics.newQuad(61, 0, 3, 16, gui:getDimensions())

tilesheet = love.graphics.newImage("tiles.png")
tiles = {}

tiles[1] = love.graphics.newQuad(0, 0, 32, 48, tilesheet:getDimensions())
tiles[2] = love.graphics.newQuad(32, 0, 32, 48, tilesheet:getDimensions())
tiles[3] = love.graphics.newQuad(64, 0, 32, 48, tilesheet:getDimensions())
