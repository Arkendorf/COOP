function game_load()
  x = 0
  y = 0
  xV = 0
  yV = 0
  map = {{1, 1, 1}, {1, 1, 2}, {2, 1, 1}}
  tType = {0, 1}
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
end

function game_draw()
  for i = 1, #players do
    love.graphics.rectangle("fill", players[i].x + offset.x - x  - 16, players[i].y + offset.y - y  - 16, 32, 32)
  end
  for rowsDown = 1, #map do
    for rowsAcross = 1, #map[1] do
      if tType[map[rowsDown][rowsAcross]] == 1 then
        if rowsDown == targetTile.y and rowsAcross == targetTile.x then
          love.graphics.setColor(200, 200, 200)
        else
          love.graphics.setColor(255, 255, 255)
        end
        love.graphics.rectangle("fill", (rowsAcross - 1) * 32 + offset.x - x - 16, (rowsDown - 1) * 32 + offset.y - y - 16, 32, 32)
      end
    end
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(tostring(targetTile.x) ..", ".. tostring(targetTile.y), 200, 0)

  love.graphics.circle("line", offset.x + targetPos.x, offset.y + targetPos.y, 8, 10)
end
