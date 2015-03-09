require ("Tserial")

local Original = {}
local Updated = {}
local Running = false
local Width, Height
local Time

function InitLife(width, height)
  Width, Height = width, height
  Time = 0

  for i = 1, width do
    Original[i] = {}
    Updated[i] = {}
    for j = 1, height do
      Original[i][j] = 0
      Updated[i][j] = 0
    end
  end
end

function IsRunning() return Running end
function SetRunning(r) Running = r end

function GetBoard() return Original end

function GetCell(x, y) return Original[x][y] end
function SetCell(x, y, c) Original[x][y] = c end

function Save()
  local File = io.open("state.txt", "w")
  if File then
    File:write(Tserial.pack(Original))
    File:flush()
    File:close()
  else
    Output = "File not found!"
  end
end

function Load()
  local File = io.open("state.txt", "r")
  if File then
    Original = Tserial.unpack(File:read())
    File:close()
  else
    Output = "File not found!"
  end
end

function Reset()
  for i = 1, Width do
    Original[i] = {}
    Updated[i] = {}
    for j = 1, Height do
      Original[i][j] = 0
      Updated[i][j] = 0
    end
  end
end

function SetColor(x, y)
  if Original[x][y] == 1 then
    if Running then
      love.graphics.setColor(150, 50, 50)
    else
      love.graphics.setColor(150, 150, 150)
    end
  else
    if Running then
      love.graphics.setColor(75, 75, 100)
    else
      love.graphics.setColor(100, 100, 100)
    end
  end
end

function UpdateState()
  for i = 1, Width do
    for j = 1, Height do
      Original[i][j] = Updated[i][j]
    end
  end
end

function GetNeighbors(x, y)
  local n = 0

  x2 = x - 1
  x3 = x + 1
  y2 = y - 1
  y3 = y + 1

  if x2 < 1 then x2 = Width end
  if x3 > Width then x3 = 1 end
  if y2 < 1 then y2 = Height end
  if y3 > Height then y3 = 1 end

  local Cells = {Original[x2][y2],
                 Original[x2][y],
                 Original[x2][y3],
                 Original[x][y2],
                 Original[x][y3],
                 Original[x3][y2],
                 Original[x3][y],
                 Original[x3][y3]
  };

  for i,v in pairs(Cells) do
    if v == 1 then n = n + 1 end
  end

  return n
end

function UpdateLife()
  Time = Time + 1
  if Time > 5 then
    for i = 1, Width do
      for j = 1, Height do
        local n = GetNeighbors(i,j)

        local Cell = Original[i][j]
        local Result = 0

        if Cell == 1 and n < 2 then Result = 0 end
        if Cell == 1 and n == 2 or n == 3 then Result = 1 end
        if Cell == 1 and n > 3 then Result = 0 end
        if Cell == 0 and n == 3 then Result = 1 end

        Updated[i][j] = Result

      end
    end
    UpdateState()
    Time = 0
  end
end
