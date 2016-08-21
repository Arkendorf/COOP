function game_load()
  x = 0 -- coordinates and velocity of the player
  y = 0
  xV = 0
  yV = 0
  if status == "server" then
    map = {msg = "map", {1, 1, 1}, {1, 1, 2}, {2, 1, 1}} -- sets up map
  else
    map = {{1}} -- placeholder until servers sends real map
  end
  tType = {0, 1, 3} -- the tile type: 0 is no collision, 1 is collision, and 3 is roof
  tStrength = {0, 1, 1} -- time (in seconds) it takes to break each tile
  mouseDown = {time = 0} -- how long the mouse has been held for
  currentBlock = 2 -- the tile the player will place
end

function game_update(dt)
  if love.keyboard.isDown("w") then -- adjust player velocity
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

  movePlayer() -- checks collision and adjusts players coords

  xV = xV * 0.8
  yV = yV * 0.8

  targetAngle = math.atan2(mY - offset.y, mX - offset.x)  -- gets targeted tile
  targetPos = {x = 32 * math.cos(targetAngle), y = 32 * math.sin(targetAngle)}
  targetTile = {x = round((targetPos.x + x) / 32) + 1, y = round((targetPos.y + y) / 32) + 1}

  if love.mouse.isDown(1) and mouseDown.x == targetTile.x and mouseDown.y == targetTile.y then -- how long mouse is held on tile
    mouseDown.time = mouseDown.time + dt
  else
    mouseDown.time = 0
    mouseDown.x = targetTile.x
    mouseDown.y = targetTile.y
  end

  build() -- breaks or builds at tile location
end

function game_draw()
  for rowsDown = 1, #map do -- renders tiles
    for rowsAcross = 1, #map[1] do
        love.graphics.draw(tilesheet, tiles[map[rowsDown][rowsAcross]], (rowsAcross - 1) * 32 + offset.x - x, (rowsDown - 1) * 32 + offset.y - y, 0, 1, 1, 16, 32)
      -- if roof[rowsDown][rowsAcross][1] ~= 0 then
      --   love.graphics.draw(tilesheet, tiles[roof[rowsDown][rowsAcross][1]], (rowsAcross - 1) * 32 + offset.x - x, (rowsDown - 1) * 32 + offset.y - y, 0, 1, 1, 16, 32)
      -- end
    end
  end

  love.graphics.rectangle("fill", offset.x - 16, offset.y - 16, 32, 32) -- renders player
  for i = 2, #players do -- draws all other players
    love.graphics.rectangle("fill", players[i].x + offset.x - x  - 16, players[i].y + offset.y - y  - 16, 32, 32)
  end

  love.graphics.circle("line", offset.x + targetPos.x, offset.y + targetPos.y, 8, 10) -- draws target
end
