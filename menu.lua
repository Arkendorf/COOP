function menu_load()
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

	joinButton = renderGui("button", "Join", 19)
	hostButton = renderGui("button", "Host", 21)

	port = "25565"
	validInput = "1234567890.:"
end

function menu_update(dt)
	if port ~= nil then
		portField = renderGui("field", port, 30)
	else
		portField = renderGui("field", "port", 30, {132, 126, 135})
	end

	if ip ~= nil then
		ipField = renderGui("field", ip, 100)
	else
		ipField = renderGui("field", "IP", 100, {132, 126, 135})
	end
end

function menu_keypressed(key)

if key == "backspace" then
	if fieldSelected == "port" then
		port = string.sub(port, 1, -2)
	elseif fieldSelected == "ip" then
		ip = string.sub(ip, 1, -2)
	end
end

end

function menu_draw()

	love.graphics.draw(hostButton, 1, 0)
	love.graphics.draw(portField, 37, 0)


	love.graphics.draw(joinButton, 3, 17)
	love.graphics.draw(ipField, 37, 17)

end

function menu_textinput(t)
	if string.find(validInput, t) ~= nil then
	  if fieldSelected == "port" and string.len(port) < 5 then
			port = port .. t
		elseif fieldSelected == "ip" and string.len(ip) < 22 then
			ip = ip .. t
		end
	end

end

function menu_mousepressed(x, y, button)

	if x > 1  and x < 1 + 27  and y > 0 and y < 0 + 16 then
		if port ~= nil then
			currentstate = "server"
  		server_load()
		end
	elseif x > 3 and x < 3 + 25 and y > 17 and y < 17 + 16 then
		if ip ~= nil then
			currentstate = "client"
			portStart, portEnd = string.find(ip, ":")
			if portStart ~= nil then			
				port = string.sub(ip, portStart + 1)
				ip = string.sub(ip, 1, portStart - 1)
			else
				port = 25565
			end
	    client_load()
		end
	elseif x > 37 and x < 37 + 36 and y > 0 and y < 0 + 16 then
		fieldSelected = "port"
		port = ""
	elseif x > 37 and x < 37 + 106 and y > 17 and y < 17 + 16 then
		fieldSelected = "ip"
		ip = ""
	else
		fieldSelected = nil
	end
	if fieldSelected ~= "port" and port == "" then
		port = nil
	elseif fieldSelected ~= "ip" and ip == "" then
		ip = nil
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
