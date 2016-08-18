function game_load()
  x = 0
  y = 0
  xV = 0
  yV = 0
  if status == "server" then
    map = {msg = "map", {1, 1, 1}, {1, 1, 2}, {2, 1, 1}}
  else
    map = {{1}}
  end
  tType = {0, 1}
  tStrength = {0, 1}
  mouseDown = {time = 0}
end

function game_update(dt)
  if love.keyboard.isDown("w") then
    yV = yV - dt * 30
  end
  if love.keyboard.isDown("s") then
    yV = yV + dt * 30
  end
  if love.keyboard.isDown("a") then
    xV = xV - dt * 30
  end
  if love.keyboard.isDown("d") then
    xV = xV + dt * 30
  end

  if x + round(xV) >= 0 and x + round(xV) <= (#map[1] - 1) * 32 then
    x = x + round(xV)
    if tType[map[round((y - 16) / 32) + 1][round((x - 16) / 32) + 1]] == 1 or tType[map[round((y + 15) / 32) + 1][round((x + 15) / 32) + 1]] == 1 or tType[map[round((y - 16) / 32) + 1][round((x + 15) / 32) + 1]] == 1 or tType[map[round((y + 15) / 32) + 1][round((x - 16) / 32) + 1]] == 1 then
      x = x - round(xV)
      xV = 0
    end
  else
    xV = 0
  end

  if y + round(yV) >= 0 and y + round(yV) <= (#map - 1) * 32 then
    y = y + round(yV)
    if tType[map[round((y - 16) / 32) + 1][round((x - 16) / 32) + 1]] == 1 or tType[map[round((y + 15) / 32) + 1][round((x + 15) / 32) + 1]] == 1 or tType[map[round((y - 16) / 32) + 1][round((x + 15) / 32) + 1]] == 1 or tType[map[round((y + 15) / 32) + 1][round((x - 16) / 32) + 1]] == 1 then
      y = y - round(yV)
      yV = 0
    end
  else
    yV = 0
  end

  xV = xV * 0.8
  yV = yV * 0.8

  targetAngle = math.atan2(mY - offset.y, mX - offset.x)
  targetPos = {x = 32 * math.cos(targetAngle), y = 32 * math.sin(targetAngle)}
  targetTile = {x = round((targetPos.x + x) / 32) + 1, y = round((targetPos.y + y) / 32) + 1}

  if love.mouse.isDown(1) and mouseDown.x == targetTile.x and mouseDown.y == targetTile.y then
    mouseDown.time = mouseDown.time + dt
  else
    mouseDown.time = 0
    mouseDown.x = targetTile.x
    mouseDown.y = targetTile.y
  end

  if mouseDown.x > 0 and mouseDown.x <= #map[1] and mouseDown.y > 0 and mouseDown.y <= #map then
    if map[mouseDown.y][mouseDown.x] ~= 1 and tStrength[map[mouseDown.y][mouseDown.x]] <= mouseDown.time then
      map[mouseDown.y][mouseDown.x] = 1

      tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = 1}
    elseif love.mouse.isDown(2) then
      map[mouseDown.y][mouseDown.x] = 2
      tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = 2}
    end
  end
end

function game_draw()
  love.graphics.rectangle("fill", offset.x - 16, offset.y - 16, 32, 32)
  for i = 2, #players do
    love.graphics.rectangle("fill", players[i].x + offset.x - x  - 16, players[i].y + offset.y - y  - 16, 32, 32)
  end
  for rowsDown = 1, #map do
    for rowsAcross = 1, #map[1] do
      if tType[map[rowsDown][rowsAcross]] == 1 then
        love.graphics.rectangle("fill", (rowsAcross - 1) * 32 + offset.x - x - 16, (rowsDown - 1) * 32 + offset.y - y - 16, 32, 32)
      end
    end
  end
  love.graphics.print(tostring(mouseDown.time), 200, 0)

  love.graphics.circle("line", offset.x + targetPos.x, offset.y + targetPos.y, 8, 10)
end
