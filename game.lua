function game_load()
  x = 0
  y = 0
end

function game_update(dt)
  if love.keyboard.isDown("w") then
    y = y - 1
  end
  if love.keyboard.isDown("s") then
    y = y + 1
  end
  if love.keyboard.isDown("a") then
    x = x - 1
  end
  if love.keyboard.isDown("d") then
    x = x + 1
  end
end

function game_draw()
  for i = 1, #players do
    love.graphics.circle("fill", players[i].x + 200 - x, players[i].y + 150 - y, 10, 10)
  end
end
