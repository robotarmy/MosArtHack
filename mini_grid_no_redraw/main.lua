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

maxigrid = {}

function maxigrid:draw(mini,scale)
  scale = scale / 100
  local d_vcw =  display.viewableContentWidth
  local d_vch = display.viewableContentHeight
  square_width = scale * mini.width
  dw = d_vcw / square_width
  dh = d_vch / square_width
  for x = 0,dw,1 do
    for y = 0,dh,1 do
      left = (x*square_width) 
      top =  (y*square_width) 
      print("left" .. left)
      print("top" .. top)
      local s = display.newRect(left,top,width,width) 
      local el = (x+y) % mini.num + 1
      print(el)
      print(mini.set[el].r)
      s:setFillColor(mini.set[el].r,mini.set[el].g,mini.set[el].b)
    end
  end
end
minigrid = {}

function minigrid:rect(startx,starty,num,width) 
  self.set = {}
  self.num = num * num
  self.width = width
  local this = self
  local left = 0
  local top = 0
  for x = 0,num-1,1 do
    for  y = 0,num-1,1 do
      print("left" .. left)
      print("top" .. top)
      left = (x*width) + startx
      top =  (y*width)  + starty
      local s = display.newRect(left,top,width,width) 
      radColor(s)
      table.insert(self.set,s)
      function s:tap(event) 
        print('-x:'..self.x.. '-y:'..self.y)
        print('-w:'..self.width.. '-h:'..self.height)
        radColor(self) 
        print(self)
        print('---')
        maxigrid:draw(this,50)
      end
      s:addEventListener( "tap", s )
    end
  end
  return self
end

grid = minigrid:rect(0,20,2,width)
assert(#grid.set == 4)

