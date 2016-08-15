require("menu")

function client_load()

	client = lube.udpClient()
	client:createSocket()
	client.host = ip
	client.port = tonumber(port)
	client.connected = true
	client:setPing(true, 25, "hi")


	client_data = {} -- array we are going to send to the server

	x = 0
	y = 0
end

function client_update(dt)

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

					  client_data.x = x
						client_data.y = y

						data = client:_receive() -- incoming server data? it's mine!

						if data then
							server_data = bin:unpack(data) -- unpack received data from string to array
						end

						client:_send(bin:pack(client_data)) -- pack client_data into string and send it to the server
end

function client_draw()

	love.graphics.rectangle("fill", client_data.x, client_data.y, 32, 32)
	if server_data then
		love.graphics.rectangle("fill", server_data.x, server_data.y, 32, 32)
	end

  -- love.graphics.print("Packed client_data:   "..bin:pack(client_data), 10, 565)
  -- love.graphics.print("Packed server_data:  "..tostring(data), 10, 580)
	--
  -- love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)

end
