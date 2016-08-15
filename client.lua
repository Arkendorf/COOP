function client_load()
  errorMsg = ""
  players = {}

  client = lube.udpClient()
	success, err = client:connect("127.0.0.1", 25565)
end

function client_update(dt)
  client:update(dt)

  if success == false then
    status = "menu"
    errorMsg = "Invalid IP or port"
  end
end

function client_draw()
  love.graphics.print("Players online: " .. tostring(#players), 0, 15)
  for i = 1, #players do
    love.graphics.print(tostring(players[i].name), 0, 15 + i * 15)
  end
end

function client_quit()
  client:disconnect()
end

function onReceive(data)
  data = unpickle(data)
  if data.msg == "disconnect" then
    client:disconnect()
    status = "menu"
    errorMsg = "Disconnected by server"
  else
    players = data
  end
end
