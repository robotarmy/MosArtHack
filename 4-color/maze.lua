print('maze')
maze = {}
maze.__index = maze
function maze:at(x,y)
  return self.rooms[(x-1)*self.N+y]
end
function maze:init_with_func(n,fc)
  local amze = {rooms = {}, N =n}
  setmetatable(amze,maze)
  for x = 1, n, 1 do
    for y = 1, n, 1 do
      local el = fc(x,y)
      local me =  {}
      assert(el ~= nil)
      me._maze_x = x
      me._maze_y = y
      me._maze_color = 0
      me.parent = el
      amze.rooms[(x-1)*n+y] = me
      el.room = me
      el.maze = amze
    end
  end
  return amze
end
thing = {}
local m = maze:init_with_func(3,function()
  return thing
end)
assert(thing.room ~= nil)
assert(thing.maze ~= nil)
assert(thing.room.parent ~= nil)
assert(thing.room.parent == thing)


function maze:init(n)
  local amze = {rooms = {}, N =n}
  setmetatable(amze,maze)
  for x = 1, n, 1 do
    for y = 1, n, 1 do
      amze.rooms[(x-1)*n+y] = {_maze_x = x, _maze_y= y, _maze_color = 0}
    end
  end
  return amze
end

function maze:bound(v,deltav)
  return bound(v,deltav,1,self.N)
end

function maze:color(x,y,color)
  room = self:at(x,y)
  room._maze_color = color
end

-- used for storing color as a series
-- of digits
function maze:mark_grid(x,y,color_id)
   self:color(x,y,color_code_on(color_id))
end

function maze:cat(x,y)
  return self:at(x,y)._maze_color
end

function maze:dump()
  for x = 1, self.N, 1 do
    for y = 1, self.N, 1 do
      print(x,y,self:cat(x,y))
    end
  end
end

function maze:score_for(x,y,sig_dig)
  local v = sum_grid_func(self,x,y,sig_dig,v_sum)
  local h = sum_grid_func(self,x,y,sig_dig,h_sum)
  if v > h then
    return  v
  else
    return h
  end
end

function color_code_on(color_id)
  local sigd = color_id - 1
  local k = 1
  if sigd > 0 then
    for d = 1,sigd,1 do
      k = math.floor(k * 10)
    end
  end
  return k
end

function bound(v,delta,min,max)
  if v+delta <= max then
    v = v + delta
  else
    v = max
  end
  if v < min then
    v = min
  end
  return v
end
function h_sum(grid,x,y) 
  local N = grid.N
  local sum = 0
  local west  = bound(x,-3,1,N) 
  local east  = bound(x,3,1,N) 
  local code = 0
  local h_sequence_sum = 0
  local h_max = 0
  local last_code = 0
  for fx = west, east, 1 do
    code =  grid:cat(fx,y)
    if last_code == 0 then
      last_code = code 
    end
    if not(last_code == code) then
      h_sequence_sum = 0
    end
    h_sequence_sum = h_sequence_sum + code
    if h_sequence_sum > h_max then
      h_max = h_sequence_sum
    end
    last_code = code
  end
  return h_max
end
function v_sum(grid,x,y)
  local N = grid.N
  local sum = 0
  local north = bound(y,-3,1,N) 
  local south = bound(y,3,1,N)
  local code = 0
  local v_sequence_sum = 0
  local v_max = 0
  local last_code = 0
  for fy = north, south, 1 do
    code = grid:cat(x,fy)
    if last_code == 0 then
      last_code = code 
    end
    if not(last_code == code) then
      v_sequence_sum = 0
    end
    v_sequence_sum = v_sequence_sum + code
    if v_sequence_sum > v_max then
      v_max = v_sequence_sum
    end
    last_code = code
  end
  return v_max
end

function sum_four(grid,x,y)
  local v_max =  v_sum(grid,x,y)
  local h_max =  h_sum(grid,x,y)

  if v_max > h_max then
    return  v_max
  else
    return h_max
  end
end

-- grid => NxN sparse matrix
-- 5,5 => x,y in space matrix
-- 3 => significat digit to sum 
-- agaist in code
function sum_grid_func(grid,x,y,significant_digit,sum_func) 
  local sigd = significant_digit - 1
  -- sigd is number of times to divide the
  -- code by 10
  -- conversly sigm is
  -- code_length - 1 - sigd is the number
  -- of times to mod by 10
  local sum_code = sum_func(grid,x,y)
  local score = 0
  if sum_code > 0 then
    local sigm = #tostring(sum_code) - 1 - sigd
    local k = sum_code
    if sigd > 0 then
      for d = 1,sigd,1 do
        k = math.floor(k / 10)
      end
    end
    if sigm > 0 then
      for d = 1,sigm,1 do
        k = math.floor(k % 10)
      end
    end
    score = k
  end
  return score
end

