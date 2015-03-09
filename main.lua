require ("Life")

local W, H
local DrawGrid
Output = ""

function love.load()
  InitLife(46, 39)

  DrawGrid = false

  Pointer = {}
  Pointer.x = 1
  Pointer.y = 1

end

function love.update(dt)
  if IsRunning() then UpdateLife() end
end

function love.draw()
  local Board = GetBoard()
  W = #Board
  H = #Board[1]

  for i = 1, W do
    for j = 1, H do
      SetColor(i,j)
      love.graphics.rectangle("fill", i*10, j*10, 10, 10)
      if DrawGrid then
        love.graphics.setColor(25, 25, 25)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", i*10, j*10, 10, 10)
      end
    end
  end
  love.graphics.setColor(0,0,0)
  love.graphics.line(Pointer.x*10, Pointer.y*10, Pointer.x*10 + 10, Pointer.y*10 + 10)
  love.graphics.line(Pointer.x*10+10, Pointer.y*10, Pointer.x*10, Pointer.y*10 + 10)

  love.graphics.setColor(255,255,255)

  love.graphics.rectangle("line", 10, 10, W*10, H*10)

  love.graphics.print("Running: " .. tostring(IsRunning()) .. "[r]", 10, H*10+10)
  love.graphics.print("DrawGrid: " .. tostring(DrawGrid) .. "[g]", 10, H*10+22)
  love.graphics.print("Neighbors: " .. GetNeighbors(Pointer.x, Pointer.y), 10, H*10+34)
  love.graphics.print("Press S to save", 10, H*10+48)
  love.graphics.print("Press O to load", 10, H*10+60)
  love.graphics.print(Output, 10, H*10+76)

end

function love.keypressed(key)
  if key == "r" then SetRunning(not IsRunning()) end
  if key == "g" then DrawGrid = not DrawGrid end

  if key == "q" and not IsRunning() then
    Reset()
  end

  if key == "s" and not IsRunning() then
    Save()
    Output = "State saved!"
  end
  if key == "o" and not IsRunning() then
    Load()
    Output = "State loaded!"
  end

  if key == "up" then
    if Pointer.y == 1 then Pointer.y = H
    else Pointer.y = Pointer.y - 1
    end
  end
  if key == "down" then
    if Pointer.y == H then Pointer.y = 1
    else Pointer.y = Pointer.y + 1
    end
  end
  if key == "right" then
    if Pointer.x == W then Pointer.x = 1
    else Pointer.x = Pointer.x + 1
    end
  end
  if key == "left" then
    if Pointer.x == 1 then Pointer.x = W
    else Pointer.x = Pointer.x - 1
    end
  end

  if key == " " and not IsRunning() then
    if GetCell(Pointer.x, Pointer.y) == 1 then
      SetCell(Pointer.x, Pointer.y, 0)
    else
      SetCell(Pointer.x, Pointer.y, 1)
    end
  end

  if key == "escape" then
    love.event.quit()
  end


end
