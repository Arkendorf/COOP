require("menu")

function server_load()

	server = lube.udpServer()
	server:createSocket()
	server.port = tonumber(port)
	server:_listen()
	server:setPing(true, 75, "hi")


	server_data = {} -- array we are going to send to the client

	x = 0
	y = 0
end

function server_update(dt)

	if love.keyboard.isDown("w") then
		y = y - 1
	end
	if love.keyboard.isDown("s") then
		y = y + 1
	end
	if love.keyboard.isDown("d") then
		x = x + 1
	end
	if love.keyboard.isDown("a") then
		x = x - 1
	end

					  server_data.x = x
						server_data.y = y

						data, id = server:receive() -- snatch that naughty client data up | id = "ip:port"

						if data then
							client_data = bin:unpack(data) -- unpack received data from string to array
						end

						if id ~= "No message." then
							server:send(bin:pack(server_data), id) -- pack server_data into string and send it to client
						end
end

function server_draw()

	love.graphics.rectangle("fill", server_data.x, server_data.y, 32, 32)
	if client_data then
		love.graphics.rectangle("fill", client_data.x, client_data.y, 32, 32)
	end

  -- love.graphics.print("Packed client_data:   "..tostring(data), 10, 565)
  -- love.graphics.print("Packed server_data:  "..tostring(bin:pack(server_data)), 10, 580)
	--
  -- love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)

end
