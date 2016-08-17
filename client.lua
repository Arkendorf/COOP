function client_load()
  errorMsg = ""
  players = {}

  if tonumber(port) ~= nil then
    port = tonumber(port)
  else
    port = 25565
  end

  if ip == "" then
    ip = " "
  end

  client = lube.udpClient()
	success, err = client:connect(ip, port)

  game_load()
end

function client_update(dt)
  if success == false then
    ip = ""
    port = ""
    status = "menu"
    errorMsg = "Invalid IP or port"
  end

  game_update(dt)
  client:send(pickle({msg = "coords", x, y}))
  client:update(dt)
end

function client_draw()
  love.graphics.print("Players online: " .. tostring(#players), 0, 15)
  for i = 1, #players do
    love.graphics.print(tostring(players[i].name), 0, 15 + i * 15)
  end

  game_draw()
end

function client_quit()
  client:disconnect()
end

function onReceive(data)
  data = unpickle(data)
  if data.msg == "disconnect" then
    client:disconnect()
    ip = ""
    port = ""
    status = "menu"
    errorMsg = data.err
  elseif data.msg == "players" then
    players = data
  end
end
