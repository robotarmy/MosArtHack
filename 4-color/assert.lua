require('maze')
print('robot')
local N = 9
local amaze = maze:init(N)
assert(#amaze.rooms == N*N)
assert(amaze:bound(1,-1) == 1)
assert(amaze:bound(N,1) == N)


robot = {}
function robot:visited_count()
  return self.vcount
end
function robot:visited(x,y)
  return self.map[amaze:at(x,y)] ~= nil
end
function robot:mark_visit(x,y)
  if not self:visited(x,y) then
    self.map[amaze:at(x,y)] = {x=x,y=y}
    self.vcount = self.vcount +1 
  end
end
function robot:init(maze,x,y)
  self.x = x ; self.y = y
  self.map = {}
  self.maze = maze
  self.vcount = 0
  self:mark_visit(x,y)
  return self
end

local robby = robot:init(amaze,1,1)
assert(robby.x == 1)
assert(robby.y == 1)

function robot:check_bounded(dx,dy) 
  if (self.maze:bound(self.x,dx) == self.x) and
     (self.maze:bound(self.y,dy) == self.y) then
    return true
  end
  return false
end
function robot:check_direction(dx,dy)
  if self:check_bounded(dx,dy) then
    return false
  else
    return self.maze:cat(self.x+dx,self.y+dy) == self.maze:cat(self.x,self.y)
  end
end
function robot:has_visited(dx,dy)
  return self:visited(self.x+dx,self.y+dy)
end
function robot:check_east()
  return self:check_direction(1,0) and not self:has_visited(1,0)
end

function robot:check_west()
  return self:check_direction(-1,0) and not self:has_visited(-1,0)
end

function robot:check_south()
  return self:check_direction(0,1) and not self:has_visited(0,1)
end

function robot:check_north()
  return self:check_direction(0,-1) and not self:has_visited(0,-1)
end

function robot:move(dx,dy)
  if self:check_direction(dx,dy) then
    self.x = self.x + dx
    self.y = self.y + dy
    self:mark_visit(self.x,self.y)
  end
end

function robot:move_north()
  self:move(0,-1)
end

function robot:move_south()
  self:move(0,1)
end
function robot:move_east()
  self:move(1,0)
end

function robot:move_west()
  self:move(-1,0)
end

local robby = robot:init(amaze,1,1)
assert(robby:check_bounded(-1,-1))
assert(robby:check_bounded(-1,0))
assert(robby:check_bounded(0,-1))
assert(not(robby:check_bounded(0,1)))
assert(not(robby:check_bounded(1,0)))
assert(not(robby:check_bounded(1,1)))
assert(not(robby:check_north()))
assert(not(robby:check_west()))
local robby = robot:init(amaze,2,2)
assert(not(robby:check_bounded(-1,-1)))
assert(not(robby:check_bounded(-1,0)))
assert(not(robby:check_bounded(0,-1)))
assert(robby:check_north())
assert(robby:check_west())
assert(robby:check_south())
assert(robby:check_east())
local robby = robot:init(amaze,N,N)
assert(not(robby:check_south()))
assert(not(robby:check_east()))
robby:move(-1,0)
assert(robby.x == N-1)
assert(robby.y == N)
local sx = 3
local sy = 3
local robby = robot:init(amaze,sx,sy)
assert(robby:visited(sx,sy))
--
-- robots keep a map as they travel
robby:move_west()
assert(robby.x == sx - 1)
assert(robby.y == sy)
assert(robby:visited(sx-1,sy))
-- robot's map is unique
-- backtraking doesn't increase visited count
robby:move_east()
assert(robby:visited(sx-1,sy))
assert(robby:visited_count() == 2)
robby:move_north()
assert(robby.x == sx)
assert(robby.y == sy-1)
assert(robby:visited(sx,sy-1))
-- robot's map is unique
-- backtraking doesn't increase visited count
robby:move_south()
robby:move_south()
assert(robby:visited(sx,sy+1))
assert(robby:visited_count() == 4)


function robot:run_maze(dx,dy)
  if dx == nil or dy == nil then
    dx = 0
    dy = 0
  end
  if self:check_north() then
    self:move_north()
    self:run_maze(0,-1)
  end
  if self:check_west() then
    self:move_west()
    self:run_maze(-1,0)
  end
  if self:check_south() then
    self:move_south()
    self:run_maze(0,1)
  end
  if self:check_east() then
    self:move_east()
    self:run_maze(1,0)
  end
  -- backtrack
  -- negate last move
  self:move(-dx,-dy)
  return
end
local N = 3
local amaze = maze:init(N)
local sx = 1
local sy = 1
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 1
local sy = 2
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 1
local sy = 3
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 2
local sy = 1
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 2
local sy = 2
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 2
local sy = 3
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 3
local sy = 1
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 3
local sy = 2
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
print('----')
local N = 3
local amaze = maze:init(N)
local sx = 3
local sy = 3
local robby = robot:init(amaze,sx,sy)
robby:run_maze()
assert(robby:visited_count() == N*N)
