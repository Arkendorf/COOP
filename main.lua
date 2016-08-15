require ("middleclass")
require ("middleclass-commons")
require ("LUBE")
require("pickle")

require ("server")
require ("client")

function love.load()
  status = "menu"
  errorMsg = ""
end

function love.update(dt)
  if status == "server" then
    server_update(dt)
  elseif status == "client" then
    client_update(dt)
  end
end

function love.draw()
  if status == "server" then
    server_draw()
  elseif status == "client" then
    client_draw()
  end
  love.graphics.print(status)
  love.graphics.print(errorMsg, 0, 15)
end

function love.keypressed(key)
  if status == "menu" then
    if key == "1" then
      status = "server"
      server_load()
    elseif key == "2" then
      status = "client"
      client_load()
    end
  end
end

function love.quit()
  if status == "server" then
  elseif status == "client" then
    client_quit()
  end
end

function format(table)
  newTable = {}
  for i = 1, #table do
    for i2 = 1, #table[i] do
      newTable[#newTable + 1] = table[i][i2]
    end
    newTable[#newTable + 1] = "stop"
  end
  return newTable
end

function unformat(table)
  newTable = {}
  i2 = 1
  for i = 1, #table do
    if table[i] == "stop" then
      i2 = i2 + 1
      i = i + 1
    end
    newTable[i2][#newTable[i2] + 1] = table[i]
  end
  return newTable
end
