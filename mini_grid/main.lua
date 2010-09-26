--
-- objective : set of squares as buttons
--
--
--

local width,height = 100,100

function radColor(o)
  local r = math.random( 0, 200 )
  local g = math.random( 0, 200 )
  local b = math.random( 0, 200 )
  o.r = r
  o.g = g
  o.b = b
  o:setFillColor( o.r, o.g, o.b )
end

local draw = {}
function draw:tile(xmax,ymax,width,callback,startx,starty)
  startx = startx or 0
  starty = starty or 0
  local group = display.newGroup()
  for x = 0, xmax, 1 do
    for y = 0, ymax, 1 do
      left = (x*width) + startx
      top =  (y*width)  + starty
      local s = display.newRect(left,top,width,width) 
      group:insert(s)
      callback(s,x,y) 
    end
  end
  return group
end

maxigrid = {}

function maxigrid:draw(mini,scale)
  scale = scale / 100
  local d_vcw =  display.viewableContentWidth
  local d_vch = display.viewableContentHeight
  square_width = scale * mini.width
  dw = d_vcw / square_width
  dh = d_vch / square_width
  self.group = draw:tile(dw,dh,square_width,function(s,x,y)
      local el = (x+y) % mini.num + 1
      print(el)
      print(mini.group[el].r)
      s:setFillColor(mini.group[el].r,mini.group[el].g,mini.group[el].b)
  end)
end

minigrid = {}
function minigrid:new(startx,starty,num,width)
  self.group = minigrid:drawTile(startx,starty,num,width) 
  self.num = num * num
  self.width = width
  print(self.group.numChildren)
  assert(self.group.numChildren == self.num)
  return self
end
function minigrid:redraw()
  local parent = self.group.parent
  parent:insert(self.group)
end
function minigrid:drawTile(startx,starty,num,width) 
  local this = self
  return draw:tile(num-1,num-1,width,function (s)
      radColor(s)
    function s:tap(event) 
        print('-x:'..self.x.. '-y:'..self.y)
        print('-w:'..self.width.. '-h:'..self.height)
        radColor(self) 
        print(self)
        print('---')
       maxigrid:draw(grid,50)
       this:redraw ()
      end
    s:addEventListener( "tap", s )
  end,startx,starty)
end

grid = minigrid:new(0,20,2,width)


