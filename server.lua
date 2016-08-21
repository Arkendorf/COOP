function server_load()

  players = {msg = "players", {name = "Server Host"}}
  errorMsg = ""
  if tonumber(num) ~= nil then
    preferences = {maxPlayers = tonumber(num)}
  else
    preferences = {maxPlayers = 2}
  end

  server = lube.udpServer()

  if tonumber(port) ~= nil then
    server:listen(tonumber(port))
  else
    server:listen(25565)
  end
end

function server_update(dt)
  if #players > preferences.maxPlayers then
    server:send(pickle({msg = "disconnect", err = "Maximum players reached"}), lastConnect)
  end

  players[1].x = x
  players[1].y = y

  if tileChange ~= nil then
    server:send(pickle(tileChange))
    tileChange = nil
  end

  server:send(pickle(players))
  server:update(dt)

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
  server:send(pickle(map), clientid)
end

function onDisconnect(clientid)
  for i = 1, #players do
    if players[i].name == clientid then
      players[i] = nil
      break
    end
  end
end

function server_quit()
  server:send(pickle({msg = "disconnect", err = "Server closed"}))
  server:listen(99999)
end

function onClientReceive(data, clientid)
  data = unpickle(data)
  if data.msg == "coords" then
    for i = 1, #players do
      if players[i].name == clientid then
        players[i].x = data[1]
        players[i].y = data[2]
        break
      end
    end
  elseif data.msg == "tile" then
    map[data.y][data.x] = data.tile
  end

end
