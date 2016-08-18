function game_load()
  x = 0
  y = 0
  xV = 0
  yV = 0
  map = {{0, 0, 0}, {0, 0, 1}, {1, 0, 0}}
end

function game_update(dt)
  if love.keyboard.isDown("w") then
    yV = yV - 0.5
  end
  if love.keyboard.isDown("s") then
    yV = yV + 0.5
  end
  if love.keyboard.isDown("a") then
    xV = xV - 0.5
  end
  if love.keyboard.isDown("d") then
    xV = xV + 0.5
  end

  if x + round(xV) >= 0 and x + round(xV) <= #map[1] * 32 and y + round(yV) >= 0 and y + round(yV) <= (#map - 1) * 32 then

    x = x + round(xV)
    if map[round((y - 16) / 32) + 1][round((x - 16) / 32) + 1] == 1 or map[round((y + 15) / 32) + 1][round((x + 15) / 32) + 1] == 1 or map[round((y - 16) / 32) + 1][round((x + 15) / 32) + 1] == 1 or map[round((y + 15) / 32) + 1][round((x - 16) / 32) + 1] == 1 then
      x = x - round(xV)
      xV = 0
    end
    y = y + round(yV)
    if map[round((y - 16) / 32) + 1][round((x - 16) / 32) + 1] == 1 or map[round((y + 15) / 32) + 1][round((x + 15) / 32) + 1] == 1 or map[round((y - 16) / 32) + 1][round((x + 15) / 32) + 1] == 1 or map[round((y + 15) / 32) + 1][round((x - 16) / 32) + 1] == 1 then
      y = y - round(yV)
      yV = 0
    end

  else
    xV = 0
    yV = 0
  end

  xV = xV * 0.8
  yV = yV * 0.8
end

function game_draw()
  for i = 1, #players do
    love.graphics.rectangle("fill", players[i].x + 200 - x, players[i].y + 150 - y, 32, 32)
  end
  for rowsDown = 1, #map do
    for rowsAcross = 1, #map[1] do
      if map[rowsDown][rowsAcross] == 1 then
        love.graphics.rectangle("fill", (rowsAcross - 1) * 32 + 200 - x, (rowsDown - 1) * 32 + 150 - y, 32, 32)
      end
    end
  end
end
