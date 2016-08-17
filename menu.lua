function menu_load()
  joinButton = renderGui("button", "Join", 19)
  hostButton = renderGui("button", "Host", 21)
  startButton = renderGui("button", "Start", 25)
  menuStatus = "menu"
  ip = ""
  port = ""
  num = ""
end

function menu_update(dt)
  if menuStatus == "server" then
    portField = renderGui("field", port, 29)
    numField = renderGui("field", num, 5)
  elseif menuStatus == "client" then
    ipField = renderGui("field", ip, 77)
    portField = renderGui("field", port, 29)
  end
end

function menu_draw()

  if menuStatus == "menu" then
    love.graphics.print("Menu", 200 - stringPix("Menu"), 100, 0, 2, 2)
  	love.graphics.draw(hostButton, 187, 125)
    love.graphics.draw(joinButton, 188, 142)
  elseif menuStatus == "server" then
    love.graphics.print("Server Setup", 131, 100, 0, 2, 2)
    love.graphics.print("Port:", 131, 129)
    love.graphics.draw(portField, 269 - 35, 125)
    love.graphics.print("Max Players:", 131, 146)
    love.graphics.draw(numField, 269 - 11, 142)
    love.graphics.draw(startButton, 188, 159)
  elseif menuStatus == "client" then
    love.graphics.print("Join Server", 139, 100, 0, 2, 2)
    love.graphics.print("IP:", 139, 129)
    love.graphics.draw(ipField, 261 - 83, 125)
    love.graphics.print("Port:", 139, 146)
    love.graphics.draw(portField, 261 - 35, 142)
    love.graphics.draw(startButton, 188, 159)
  end

end

function menu_mousepressed(x, y, button)
  if menuStatus == "menu" then
  	if x > 187  and x < 187 + 27  and y > 125 and y < 125 + 16 then
      menuStatus = "server"

  	elseif x > 188 and x < 188 + 25 and y > 142 and y < 142 + 16 then
      menuStatus = "client"

  	end
  elseif menuStatus == "server" then
    if x > 269 - 35 and x < 269 and y > 125 and y < 125 + 16 then
      selectedField = "port"
    elseif x > 269 - 11 and x < 269 and y > 142 and y < 142 + 16 then
      selectedField = "num"
    elseif x > 188 and x < 188 + 31 and y > 159 and y < 159 + 16 then
      status = "server"
      server_load()
    else
      selectedField = nil
    end
  elseif menuStatus == "client" then
    if x > 261 - 83 and x < 261 and y > 125 and y < 125 + 16 then
      selectedField = "ip"
    elseif x > 261 - 35 and x < 261 and y > 142 and y < 142 + 16 then
      selectedField = "port"
    elseif x > 188 and x < 188 + 31 and y > 159 and y < 159 + 16 then
      status = "client"
      client_load()
    else
      selectedField = nil
    end
  end
end

function renderGui(type, text, l, color)
	if type == "button" then
		canvas = love.graphics.newCanvas(6 + l, 16)
		love.graphics.setCanvas(canvas)
		love.graphics.draw(gui, buttonRight, 0, 0)
		love.graphics.draw(gui, buttonMid, 3, 0, 0, l / 26, 1)
		love.graphics.draw(gui, buttonLeft, 3 + l, 0)
		if color ~= nil then
			love.graphics.setColor(color[1], color[2], color[3])
		end
		love.graphics.print(text, 3, 4)
	elseif type == "field" then
		canvas = love.graphics.newCanvas(6 + l, 16)
		love.graphics.setCanvas(canvas)
		love.graphics.draw(gui, fieldRight, 0, 0)
		love.graphics.draw(gui, fieldMid, 3, 0, 0, l / 26, 1)
		love.graphics.draw(gui, fieldLeft, 3 + l, 0)
		if color ~= nil then
			love.graphics.setColor(color[1], color[2], color[3])
		end
		love.graphics.print(text, 3, 4)
	end
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)
	return canvas
end

function menu_keypressed(key)
  if key == "escape" then
    if menuStatus == "menu" then
      love.event.quit()
    elseif menuStatus == "server" or menuStatus == "client" then
      menuStatus = "menu"
    end
  elseif key == "backspace" then
    if selectedField == "port" then
      port = string.sub(port, 1, -2)
    elseif selectedField == "ip" then
      ip = string.sub(ip, 1, -2)
    elseif selectedField == "num" then
      num = string.sub(num, 1, -2)
    end
  end
end

function menu_textinput(t)

	  if selectedField == "port" and stringPix(port .. t) <= 29 then
			port = port .. t
		elseif selectedField == "ip" and stringPix(ip .. t) <= 77 then
			ip = ip .. t
    elseif selectedField == "num" and stringPix(num .. t) <= 5 then
      num = num .. t
		end


end

function stringPix(string)
  l = -1
  for i = 1, string.len(string) do
    if string.find(" abcdeghjmnopqrsuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ023456789?-+&#+" , string.sub(string, i, i)) ~= nil then
      l = l + 6
    elseif string.find("fk" , string.sub(string, i, i)) ~= nil then
      l = l + 5
    elseif string.find("tI1/()%[]\"" , string.sub(string, i, i)) ~= nil then
      l = l + 4
    elseif string.find("l`*" , string.sub(string, i, i)) ~= nil then
      l = l + 3
    elseif string.find("i.m!:;'", string.sub(string, i, i)) ~= nil then
      l = l + 2
    end
  end
  return l
end
