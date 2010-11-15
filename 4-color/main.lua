-- behaviour objective
-- california rush
-- 
-- given a blank surface
-- given a tile in the upper left corner color 'blue'
-- when the user touches the surface
-- then a 'blue' tile will appear
-- and a tile in the upper right corner will change to 'red'
--
-- given a tile in the upper left corner color 'blue'
-- when the user touches the 'blue' tile in the upper corner
-- then a dialog will appear with the the name 'Crocadile Grid'
-- and the user will see "Create Rows of 4 of the same color to clear space"
--
--
local game_title = 'California Rush'
local game_objective = 'Create Rows of 4 same color to clear space'


-- Robot Army Made Helpers
local ram = {version = 2,color = {0x0000AA,0xAA0000,0x00AA00}, ci = 1}
function ram:current_color_id()
  return self.ci
end

function ram:current_color()
  return self.color[self.ci]
end
function ram:clear(o)
  o.strokeWidth = 2
  o.alpha = 1.0
  o:setStrokeColor( 0xFF, 0xFF, 0xFF )
  o:setFillColor( 0xff,0xff,0xff )
end
function ram:color_on(o)
  col = self:current_color()
  -- very good lesson below
  -- on extracting digits from a number
  local r = math.floor(col / 256 / 256)
  local g = math.floor((col / 256) % 256)
  local b = math.floor((col % 256) % 256)
  o.r = r
  o.g = g
  o.b = b
  o:setFillColor( o.r, o.g, o.b )
end

function ram:next_color()
  self.ci = (self.ci) % #self.color + 1
end
--
--
--
local create = {}
local counter = 100
function create:score_tile()
  local score = {
    text_display = display.newText("score",200,50,native.systemFont,40),
    score_display = display.newText(counter,400,50,native.systemFontBold,40)
  }
  score.score_display:setTextColor(0xff,0xff,0xff)
  score.text_display:setTextColor(0xff,0xff,0xff )
  return score
end

function create:next_color_tile() 
  local width,height = 100,100
  left = 0 
  top = 0
  local next_color_tile = display.newRect(left,top,width,height) 
  next_color_tile.strokeWidth = 2
  next_color_tile:setStrokeColor( 0xFF, 0xFF, 0xFF )
  ram:color_on(next_color_tile)
  return next_color_tile;
end
function create:board(event_callback)
  local width,height = 100,100

  local d_vcw =  display.viewableContentWidth
  local d_vch = display.viewableContentHeight

  local x_c = math.floor(d_vcw / width)
  local y_c = math.floor(d_vch / height)

  local grid_group = display.newGroup()
  local left = 0
  local top = 0
  if x_c > y_c then
    grid_size = x_c
  else
    grid_size = y_c
  end
  local grid = maze:init_with_func(grid_size,function(x,y)
    left = x*width
    top =  y*height
    local rect = display.newRect(left,top,width,height) 
    rect.ix = x
    rect.iy = y
    ram:clear(rect)
    rect:addEventListener('tap',event_callback )
    return rect
  end)
end
--
--
--
--
--
--
local n = create:next_color_tile()
local s = create:score_tile()

require('score')
require('robot')
create:board(function(event) 
  print('TOUCH')
  print(event)
  print(event.target)
  local o = event.target
  local room = o.room
  local grid = o.maze
  -- turn on current color for target
  -- if the current room has no color
  if room._maze_color == 0 then
    ram:color_on(o)
    grid:mark_grid(
    o.ix,
    o.iy,
    ram:current_color_id())
    score = grid:score_for(o.ix,o.iy,
    ram:current_color_id())         
    if score > 3 then
      print('BING BING BING SCORE : ' .. score)
      -- when we detect this case
      -- we want to implement the rule
      -- Any same color tiles that form
      -- a sequence of 4 will be cleared
      -- from the board - and any same
      -- color tiles connected to the 4
      -- will be also removed and counted
      -- the fine score is the total removed is
      -- count * (score-3)
      local rob = robot:init(grid,o.ix,o.iy)
      rob:run_maze()
      print('RAN MAZE... maze score :' .. rob:visited_count())
      print('Clear Maze - ANIMATION HERE')
      local array = rob:visit_list()
      local visit_score = #array
      for i,node in ipairs(array) do
        grid:color(node._maze_x,
        node._maze_y,
        0)
        transition.to(node.parent, {time=100, alpha=0,
        onComplete = function()
          ram:clear(node.parent)
        end})
      end
      print("POINTS UP")
      points = (score-3)*visit_score
      counter = counter +  points
      s.score_display.text = counter
    end
    -- change to new color
    ram:next_color()
    -- update next color tile
    -- with next color
    ram:color_on(n)
  end
end)


