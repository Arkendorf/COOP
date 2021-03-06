require ("middleclass")
require ("middleclass-commons")
require ("LUBE")
require("pickle")

require ("server")
require ("client")
require ("menu")
require ("graphics")
require ("game")
require ("gamefunction")

function love.load()
  status = "menu"
  errorMsg = ""

  w, h = love.graphics.getDimensions()
  translate = {x = w / 2, y = h / 2}
  scale = {x = w / 400, y = h / 300}
  offset = {x = 200, y = 150}

  menu_load()
end

function love.update(dt)
  mX = love.mouse.getX() / scale.x
  mY = love.mouse.getY() / scale.y

  if status == "server" then
    game_update(dt)
    server_update(dt)
  elseif status == "client" then
    game_update(dt)
    client_update(dt)
  elseif status == "menu" then
    menu_update(dt)
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(scale.x, scale.y)

  if status == "server" then
    game_draw()
    server_draw()
  elseif status == "client" then
    game_draw()
    client_draw()
  elseif status == "menu" then
    menu_draw()
  end
  love.graphics.print(status)
  love.graphics.print(errorMsg, 0, 15)

  love.graphics.pop()
end

function love.keypressed(key)
  if status == "menu" then
    menu_keypressed(key)
  elseif status == "client" or status == "server" then
    game_keypressed(key)
  end
end

function love.quit()
  if status == "server" then
    server_quit()
  elseif status == "client" then
    client_quit()
  end
end

function love.mousepressed(x, y, button)

  x = x / scale.x
  y = y / scale.y
  if status == "menu" then
    menu_mousepressed(x, y, button)
  end

end

function love.textinput(t)

  if status == "menu" then
    menu_textinput(t)
  end

end

function round(x) return x + 0.5 - (x + 0.5) % 1 end
