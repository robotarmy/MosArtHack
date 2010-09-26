--
-- objective : set of squares as buttons
--
--
--

local width = 30

local ram = {color = {0x193310,0x9EFA18,0xD4421E,0xA2C5A7,0x5C0903,0xFFFFFF}, sci = 1}
function ram:current_color()
  return self.color[self.sci]
end

function ram:next_color(o)
  col = self:current_color()
  print("before: " .. self.sci)

  self.sci = (self.sci) % #self.color + 1
  print("after: " .. self.sci)

  local r = math.floor(col / 256 / 256)
  local g = math.floor((col / 256) % 256)
  local b = math.floor((col % 256) % 256)
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
  for x = 1, xmax, 1 do
    for y = 1, ymax, 1 do
      left = (x*width) + startx
      top =  (y*width) + starty
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
  square_width = math.floor(scale * mini.width)
  dw = math.floor(d_vcw / square_width) +1 
  dh = math.floor(d_vch / square_width) +1 -- draw offscreen
  local el  = 0
  self.group = draw:tile(dw,dh,square_width,function(s,x,y)
    el = (el  % mini.group.numChildren )+ 1
    print('el ' .. el)
    s.strokeWidth = 2
    s:setStrokeColor(0xff,0xff,0xff)
    s:setFillColor(mini.group[el].r,mini.group[el].g,mini.group[el].b)
  end)
end

minigrid = {}

function minigrid:new(startx,starty,num,width)
  self.group = minigrid:drawTile(startx,starty,num,width) 
  self.num = num * num
  self.width = width
  assert(self.group.numChildren == self.num)
  return self
end

function minigrid:redraw()
  local parent = self.group.parent
  parent:insert(self.group)
end

function minigrid:drawTile(startx,starty,num,width) 
  local this = self
  return draw:tile(num,num,width,function (s)
    ram:next_color(s)
    s.strokeWidth = 2
    s:setStrokeColor(0xff,0xff,0xff)
    function s:tap(event) 
      print('-x:'..self.x.. '-y:'..self.y)
      print('-w:'..self.width.. '-h:'..self.height)
      ram:next_color(self) 
      print(self)
      print('---')
      maxigrid:draw(grid,50)
      this:redraw ()
    end
    s:addEventListener( "tap", s )
  end,startx,starty)
end

grid = minigrid:new(0,20,8,width)


