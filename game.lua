function game_load()
  x = 0
  y = 0
  xV = 0
  yV = 0
  if status == "server" then
    map = {msg = "map", {1, 1, 1}, {1, 1, 2}, {2, 1, 1}}
    formatRoof()
  else
    map = {{1}}
  end
  tType = {0, 1, 3}
  tStrength = {0, 1, 1}
  mouseDown = {time = 0}
  currentBlock = 3
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

      tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = 1} -- BLOCK REMOVED!
      breakRoof(mouseDown.x, mouseDown.y)
    elseif love.mouse.isDown(2) then
      if tType[currentBlock] == 3 and roof[mouseDown.y][mouseDown.x][1] == 0 then
        addRoof(mouseDown.x, mouseDown.y, currentBlock) -- ROOF ADDED!


      elseif tType[currentBlock] ~= 3 and map[mouseDown.y][mouseDown.x] == 1 then
        map[mouseDown.y][mouseDown.x] = currentBlock
        tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = 2} -- BlOCK ADDED!
      end
    end
  end
end

function game_draw()
  for rowsDown = 1, #map do
    for rowsAcross = 1, #map[1] do
        love.graphics.draw(tilesheet, tiles[map[rowsDown][rowsAcross]], (rowsAcross - 1) * 32 + offset.x - x, (rowsDown - 1) * 32 + offset.y - y, 0, 1, 1, 16, 32)
      if roof[rowsDown][rowsAcross][1] ~= 0 then
        love.graphics.draw(tilesheet, tiles[roof[rowsDown][rowsAcross][1]], (rowsAcross - 1) * 32 + offset.x - x, (rowsDown - 1) * 32 + offset.y - y, 0, 1, 1, 16, 32)
      end
    end
  end

  love.graphics.rectangle("fill", offset.x - 16, offset.y - 16, 32, 32)
  for i = 2, #players do
    love.graphics.rectangle("fill", players[i].x + offset.x - x  - 16, players[i].y + offset.y - y  - 16, 32, 32)
  end

  love.graphics.circle("line", offset.x + targetPos.x, offset.y + targetPos.y, 8, 10)
end

function addRoof(x, y, roofType) -- check if roof can be built at location (and adds supports)
  local support = {}

  if tType[map[y][x]] == 1 then
    roof.support[#roof.support + 1] = {x, y}
    support[#support + 1] = #roof.support
  end
  if x < #map[1] then
    if roof[y][x + 1][1] ~= 0 then
      for i = 1, #roof[y][x + 1][2] do
        support[#support + 1] = roof[y][x + 1][2][i]
      end
    end
  end
  if x > 1 then
    if roof[y][x - 1][1] ~= 0 then
      for i = 1, #roof[y][x - 1][2] do
        support[#support + 1] = roof[y][x - 1][2][i]
      end
    end
  end
  if y < #map then
    if roof[y + 1][x][1] ~= 0 then
      for i = 1, #roof[y + 1][x][2] do
        support[#support + 1] = roof[y + 1][x][2][i]
      end
    end
  end
  if y > 1 then
    if roof[y - 1][x][1] ~= 0 then
      for i = 1, #roof[y - 1][x][2] do
        support[#support + 1] = roof[y - 1][x][2][i]
      end
    end
  end

  simplify(support)

  if #support > 0 then
    for rowsDown = 1, #roof do
      for rowsAcross = 1, #roof[1] do
        if roof[rowsDown][rowsAcross][1] ~= 0 then
          for i = 1, #support do
            if has_value(roof[rowsDown][rowsAcross][2], support[i]) == true then
              roof[rowsDown][rowsAcross][2] = support
              break
            end
          end
        end
      end
    end
    roof[y][x] = {roofType, support}
  end
end

function breakRoof(x, y) -- check if broken block is a support, and affect roofs supported by it
  local result, position = has_value(roof.support, {x, y})
  if result == true then
    roof.support[position] = nil

    for rowsDown = 1, #roof do
      for rowsAcross = 1, #roof[1] do
        if roof[rowsDown][rowsAcross][1] ~= 0 then
          local result2, position2 = has_value(roof[rowsDown][rowsAcross][2], position)
          if result2 == true then
            roof[rowsDown][rowsAcross][2][position2] = nil
            if #roof[rowsDown][rowsAcross][2] < 1 then
              roof[rowsDown][rowsAcross] = {0, {}}  -- ROOF REMOVED!
            end
          end
        end
      end
    end
  end

end

function formatRoof() -- creates the roof table
  roof = {support = {}}
  for rowsDown = 1, #map do
    roof[rowsDown] = {}
    for rowsAcross = 1, #map[1] do
      roof[rowsDown][rowsAcross] = {0, {}}
    end
  end
end


function has_value(table, val) -- check if table contains value
  if type(val) == "table" then
    for index, value in ipairs (table) do
      if value[1] == val[1] and value[2] == val[2] then
        return true, index
      end
    end
  else
    for index, value in ipairs (table) do
      if value == val then
        return true, index
      end
    end
  end
  return false
end

function simplify(table) -- removes duplicate table elements
  local hash = {}
  local newTable = {}
  for _,v in ipairs(table) do
     if (not hash[v]) then
         newTable[#newTable+1] = v
         hash[v] = true
     end
     return newTable
  end
end
