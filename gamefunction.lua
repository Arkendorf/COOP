function build()
  if mouseDown.x > 0 and mouseDown.x <= #map[1] and mouseDown.y > 0 and mouseDown.y <= #map then
    if map[mouseDown.y][mouseDown.x] ~= 1 and tStrength[map[mouseDown.y][mouseDown.x]] <= mouseDown.time then
      map[mouseDown.y][mouseDown.x] = 1

      tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = 1} -- BLOCK REMOVED!
      breakRoof(mouseDown.x, mouseDown.y)
    elseif love.mouse.isDown(2) then
      if tType[currentBlock] == 3 and roof[mouseDown.y][mouseDown.x][1] == 0 then
        addRoof(mouseDown.x, mouseDown.y, currentBlock)


      elseif tType[currentBlock] ~= 3 and map[mouseDown.y][mouseDown.x] == 1 then
        map[mouseDown.y][mouseDown.x] = currentBlock
        tileChange = {msg = "tile", x = mouseDown.x, y = mouseDown.y, tile = currentBlock} -- BlOCK ADDED!
      end
    end
  end
end

function movePlayer()
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
end

function addRoof(x, y, roofType) -- check if roof can be built at location (and adds supports)
  local support = {}
  if tType[map[y][x]] == 1 then
    roof.support[#roof.support + 1] = {{x, y}}
    support[#support + 1] = #roof.support
  end
  if x > 1 then
    if roof[y][x - 1][1] ~= 0 then
      support[#support + 1] = roof[y][x - 1][2]
    end
  end
  if x < #map[1] then
    if roof[y][x + 1][1] ~= 0 and has_value(support, roof[y][x + 1][2]) == false then
      support[#support + 1] = roof[y][x + 1][2]
    end
  end
  if y > 1 then
    if roof[y - 1][x][1] ~= 0 and has_value(support, roof[y - 1][x][2]) == false then
      support[#support + 1] = roof[y - 1][x][2]
    end
  end
  if y < #map then
    if roof[y + 1][x][1] ~= 0 and has_value(support, roof[y + 1][x][2]) == false then
      support[#support + 1] = roof[y + 1][x][2]
    end
  end
  if #support > 1 then
    for i = 2, #support do
      roof.support[support[1]] = merge(roof.support[support[1]], roof.support[support[i]])
      roof.support[support[i]] = nil
      for rowsDown = 1, #roof do
        for rowsAcross = 1, #roof[1] do
          if roof[rowsDown][rowsAcross][1] ~= 0 then
            if roof[rowsDown][rowsAcross][2] == support[i] then
              roof[rowsDown][rowsAcross][2] = support[1]
            elseif roof[rowsDown][rowsAcross][2] > support[i] then
              roof[rowsDown][rowsAcross][2] = roof[rowsDown][rowsAcross][2] - 1
            end
          end
        end
      end
    end
  end
  if #support > 0 then
    roof[y][x] = {roofType, support[1]}
  end
end

function breakRoof(x, y) -- check if broken block is a support, and affect roofs supported by it
  for i = 1, #roof.support do
    if roof.support[i] ~= nil then
      result, position = has_value(roof.support[i], {x, y})
      if result == true then
        roof.support[i][position] = nil
        if #roof.support[i] < 1 then
          roof.support[i] = nil
          for rowsDown = 1, #roof do
            for rowsAcross = 1, #roof[1] do
              if roof[rowsDown][rowsAcross][1] ~= 0 then
                if roof[rowsDown][rowsAcross][2] == i then
                  roof[rowsDown][rowsAcross] = {0}
                end
              end
            end
          end
        end
        break
      end
    end
  end
end

function formatRoof() -- creates the roof table
  roof = {support = {}}
  for rowsDown = 1, #map do
    roof[rowsDown] = {}
    for rowsAcross = 1, #map[1] do
      roof[rowsDown][rowsAcross] = {0}
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
        return true
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

function merge(table1, table2)
  for k,v in pairs(table2) do table1[k] = v end
  return table1
end
