require('maze')
print('scoring')
local N = 5

local grid = maze:init(N)
assert(#grid.rooms == N*N)
assert(grid:at(1,1)._maze_color == 0)
-- color matrix w 1
-- 4 in row

x= 2
y= 2
grid:color(x,y,1)
x= 3
y= 2
grid:color(x,y,1)
x= 4
y= 2
grid:color(x,y,1)
x= 5
y= 2
grid:color(x,y,1)
assert( grid:cat(5,2) +
grid:cat(4,2) +
grid:cat(3,2) +
grid:cat(2,2) == 4)
assert(bound(1,-1,1,3) == 1)
assert(bound(2,-1,1,3) == 1)
assert(bound(4,-1,1,3) == 3)
assert(bound(3,1,1,3) == 3)
assert(bound(2,1,1,3) == 3)
assert(bound(1,1,1,3) == 2)

--
--
-- sequence of 4 
-- max search space required to find
-- 4 is 5x5
-- assuming the search is done after
-- every entry into the grit
--
-- assuming each grid entry has a coded
-- number where postiton 1 in the coded
-- number refers to color 1 and so forth
--
-- example:
--
-- Last inserted position 4,4 value 0100
-- check sum_four(grid,4,4) => 600
--
-- [ 1000, 1000, 1000,0100, 0100, 0001,0001,
--   0001, 0001, 0000,0100, 0000, 0001,0001,
--   0001, 0001, 0000,0100, 0000, 0001,0001,
--   0000, 0000, 0000,0100, 0000, 0000,0000,
--   0001, 0001, 0000,0100, 0000, 0000,0000,
--   0001, 0001, 0000,0100, 0000, 0000,0000,
--   0000, 0000, 0000,0000, 0000, 0000,0000]
--
-- max sequence horizontally, centered on 4,4
-- has valu 0600 = 600 ~ value 6 for color 3
-- 
-- on boundaries of the grid the search space is
-- truncated to the boundary
-- 
assert(sum_four(grid,5,2) == 4)
assert(sum_four(grid,4,2) == 4)
assert(sum_four(grid,3,2) == 4)
assert(sum_four(grid,2,2) == 4)

-- insight
-- Colors count can be digit in base 8
--

x= 2
y= 2
grid:color(x,y,10)
x= 3
y= 2
grid:color(x,y,10)
x= 4
y= 2
grid:color(x,y,10)
x= 5
y= 2
grid:color(x,y,10)
assert( grid:cat(5,2) +
grid:cat(4,2) +
grid:cat(3,2) +
grid:cat(2,2) == 40)
assert(sum_four(grid,5,2) == 40)
assert(sum_four(grid,4,2) == 40)
assert(sum_four(grid,3,2) == 40)
assert(sum_four(grid,2,2) == 40)

---
--- counting with 2 colors in line
--- max search space alway 5x5
--- max horizontal score '7'
--- color 1 => 1
--- color 2 => 100
local N = 10
local grid = maze:init(N)
assert(#grid.rooms == N*N)
x= 2
y= 2
grid:color(x,y,100)
x= 3
y= 2
grid:color(x,y,100)
x= 4
y= 2
grid:color(x,y,100)
x= 5
y= 2
grid:color(x,y,100)
x= 6
y= 2
grid:color(x,y,100)
x= 7
y= 2
grid:color(x,y,100)
x= 8
y= 2
grid:color(x,y,100)
assert(sum_four(grid,5,2) == 700)
x= 2
y= 2
grid:color(x,y,100)
x= 2
y= 3
grid:color(x,y,10)
x= 2
y= 4
grid:color(x,y,1)
x= 2
y= 5
grid:color(x,y,100)
x= 2
y= 6
grid:color(x,y,100)
x= 2
y= 7
grid:color(x,y,100)
x= 2
y= 8
grid:color(x,y,100)

print(sum_four(grid,2,5))
assert(sum_four(grid,2,5) == 400)

-- 
-- 5,5 ~> horizontal ~> 700
-- 5,5 ~> vertical ~> 600
x= 5
y= 2
grid:color(x,y,100)
x= 5
y= 3
grid:color(x,y,100)
x= 5
y= 4
grid:color(x,y,100)
x= 5
y= 5
grid:color(x,y,100)
x= 5
y= 6
grid:color(x,y,100)
x= 5
y= 7
grid:color(x,y,100)
x= 5
y= 8
grid:color(x,y,100)

x= 2
y= 5
grid:color(x,y,100)
x= 3
y= 5
grid:color(x,y,100)
x= 4
y= 5
grid:color(x,y,100)
x= 5
y= 5
grid:color(x,y,100)
x= 6
y= 5
grid:color(x,y,100)
x= 7
y= 5
grid:color(x,y,100)
x= 8
y= 5
grid:color(x,y,000)
print(sum_four(grid,5,5))
assert(sum_four(grid,5,5) == 700)

assert(sum_grid_func(grid,5,5,3,sum_four) == 7)
assert(sum_grid_func(grid,5,5,2,sum_four) == 0)
assert(sum_grid_func(grid,5,5,1,sum_four) == 0)
x= 5
y= 2
grid:color(x,y,111)
x= 5
y= 3
grid:color(x,y,111)
x= 5
y= 4
grid:color(x,y,111)
x= 5
y= 5
grid:color(x,y,111)
x= 5
y= 6
grid:color(x,y,111)
x= 5
y= 7
grid:color(x,y,111)
x= 5
y= 8
grid:color(x,y,111)

assert(sum_grid_func(grid,5,5,3,sum_four) == 7)
assert(sum_grid_func(grid,5,5,2,sum_four) == 7)
assert(sum_grid_func(grid,5,5,1,sum_four) == 7)
x= 5
y= 2
grid:color(x,y,11)
x= 5
y= 3
grid:color(x,y,11)
x= 5
y= 4
grid:color(x,y,11)
x= 5
y= 5
grid:color(x,y,11)
x= 5
y= 6
grid:color(x,y,11)
x= 5
y= 7
grid:color(x,y,11)
x= 5
y= 8
grid:color(x,y,11)

assert(sum_grid_func(grid,5,5,3,v_sum) == 0)
assert(sum_grid_func(grid,5,5,2,v_sum) == 7)
assert(sum_grid_func(grid,5,5,1,v_sum) == 7)
assert(grid:score_for(5,5,1) == 7)
assert(grid:score_for(5,5,2) == 7)
assert(grid:score_for(5,5,3) == 3) --horiz score
x= 5
y= 2
grid:color(x,y,1)
x= 5
y= 3
grid:color(x,y,1)
x= 5
y= 4
grid:color(x,y,1)
x= 5
y= 5
grid:color(x,y,1)
x= 5
y= 6
grid:color(x,y,1)
x= 5
y= 7
grid:color(x,y,1)
x= 5
y= 8
grid:color(x,y,1)
assert(grid:score_for(5,5,1) == 7)
assert(grid:score_for(5,5,2) == 0)
assert(grid:score_for(5,5,3) == 3) --horiz score
assert(color_code_on(1) == 1)
assert(color_code_on(2) == 10)
assert(color_code_on(3) == 100)

function mark_grid(grid,x,y,color_id)
  grid:color(x,y,color_code_on(color_id))
end
mark_grid(grid,1,1,1)
assert(grid:cat(1,1) == 1)
mark_grid(grid,1,1,2)
assert(grid:cat(1,1) == 10)
mark_grid(grid,1,1,3)
assert(grid:cat(1,1) == 100)

