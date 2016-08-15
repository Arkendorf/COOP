Class = require "class"
require "Binary"
require "LUBE"
require "menu"
require "client"
require "server"

function love.load()
  love.window.setMode(1, 1, {fullscreen = true})
  w, h = love.graphics.getDimensions()
  love.graphics.setDefaultFilter("nearest", "nearest")
  currentstate = "menu"
  translate = {x = w / 2, y = h / 2}
  scale = {x = w * 4 / 800, y = h * 4 / 600}
  menu_load()
end

function love.update(dt)

	if currentstate == "menu" then
		menu_update(dt)
	elseif currentstate == "client" then
		client_update(dt)
	elseif currentstate == "server" then
		server_update(dt)
	end

end

function love.draw()
  offset()

	if currentstate == "menu" then
		menu_draw()

	elseif currentstate == "client" then
		client_draw()
	elseif currentstate == "server" then
		server_draw()
	end


  love.graphics.print("currentstate = "..currentstate, 50, 0)
  love.graphics.pop()
end

function love.mousepressed(x, y, button)

  x = x / scale.x
  y = y / scale.y
  if currentstate == "menu" then
    menu_mousepressed(x, y, button)
  end

end

function love.textinput(t)

  if currentstate == "menu" then
    menu_textinput(t)
  end

end

function love.keypressed(key)

	if currentstate == "menu" then
		menu_keypressed(key)
	end

	if key == 'escape' then
    love.event.quit()
  end

end

function offset()
  love.graphics.push()
  love.graphics.scale(scale.x, scale.y)
end
