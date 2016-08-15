function server_load()

  players = {msg = "players", {name = "Server Host"}}
  errorMsg = ""
  preferences = {maxPlayers = 2}

  server = lube.udpServer()
	server:listen(25565)
end

function server_update(dt)
  server:update(dt)
  if #players > preferences.maxPlayers then
    server:send(pickle({msg = "disconnect"}), lastConnect)
  end

  server:send(pickle(players))

end

function server_draw()
  love.graphics.print("Players online: " .. tostring(#players), 0, 15)
  for i = 1, #players do
    love.graphics.print(tostring(players[i].name), 0, 15 + i * 15)
  end

end

function onConnect(clientid)

  players[#players + 1] = {name = clientid}
  lastConnect = clientid
end

function onDisconnect(clientid)
  for i = 1, #players do
    if players[i].name == clientid then
      players[i] = nil
      break
    end
  end
end
