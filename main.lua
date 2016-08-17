require ("middleclass")
require ("middleclass-commons")
require ("LUBE")
require("pickle")
local utf8 = require("utf8")

require ("server")
require ("client")
require ("menu")
require ("graphics")

function love.load()
  status = "menu"
  errorMsg = ""

  w, h = love.graphics.getDimensions()
  translate = {x = w / 2, y = h / 2}
  scale = {x = w / 400, y = h / 300}

  menu_load()
end

function love.update(dt)
  if status == "server" then
    server_update(dt)
  elseif status == "client" then
    client_update(dt)
  elseif status == "menu" then
    menu_update(dt)
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(scale.x, scale.y)

  if status == "server" then
    server_draw()
  elseif status == "client" then
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
  end
end

function love.quit()
  if status == "server" then
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
