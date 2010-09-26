--
-- objective : set of squares as buttons
--
--
--
local width = 100

local ram = {color = {0x000000,0x888888,0x333555,0xFFFFFF}, sci = 1}
function ram:current_color()
  return self.color[self.sci]
end

function ram:next_color(o)
  col = self:current_color()

  self.sci = (self.sci) % #self.color + 1

  local r = math.floor(col / 256 / 256)
  local g = math.floor((col / 256) % 256)
  local b = math.floor((col % 256) % 256)
  o.r = r
  o.g = g
  o.b = b
  o:setFillColor( o.r, o.g, o.b )
end

function ram:draw_swap(current_image,id)
  id = id or 1
  local d = spite:get(id)
  d.sprite_id = id
  d.x = current_image.x
  d.y = current_image.y
  return d
end

local sprite = {src = {'1.png','2.png','white.png'}}
function sprite:get(i)
  i = i or 1
  local s = display.newImageRect(self.src[i%#self.src+1],100,100)
  s:setReferencePoint(display.TopLeftReferencePoint)
  return s
end

local generate = {}
function generate:tile(xmax,ymax,width,callback,startx,starty)
  startx = startx or 0
  starty = starty or 0
  local sprite_id = 1
  for x = 1, xmax, 1 do
    for y = 1, ymax, 1 do
      index = ((x-1)*ymax+y)
      left = ((x-1)*width) + startx
      top =  ((y-1)*width) + starty
      callback(index,sprite_id,left,top,ymax,x,y) 
    end
  end
end


local maxigrid = {}
function maxigrid:new(mini,scale)
  self.mini = mini
  self.set = {}
  self.scale = scale / 100
  self.d_vcw =  display.viewableContentWidth
  self.d_vch = display.viewableContentHeight
  self.square_width = math.floor(self.scale * self.mini.width)
  self.dw = math.floor(self.d_vcw / self.square_width)  
  self.dh = math.floor(self.d_vch / self.square_width)
  return self
end
  
function maxigrid:draw()
  print('begin')
  local this = self
  this.group = display.newGroup()
  generate:tile(self.dw,self.dh,self.square_width,function(index,sid,x,y,m,i,j)
    i = i % m +1 
    j = j % m +1
    local el = (((i-1)*m+j))
    print("index"..index)
    o = sprite:get(sid)
    o.x = x
    o.y = y
    o.width = self.square_width
    o.height = self.square_width
    this.set[#this.set] = o
    this.group:insert(o)
  end)
  return self
end
--
--
--  Scan throught the maxi grid searching for
-- effective id matches
--
function maxigrid:redraw_for(obj)
  local this = self
  id = obj.id
  generate:tile(self.dw,self.dh,self.square_width,function(index,sid,x,y,m,i,j)
    print('i...' ..i )
    print('j...' ..j )
    i = i % math.sqrt(this.mini.num) +1 
    j = j % math.sqrt(this.mini.num) +1
    -- convert to effective id 
    local el = (((i-1)*math.sqrt(this.mini.num)+j)) 
    print(".in : " ..index)
    print(".eeel :" ..el)
    print(".id chaged - " ..id)
    if el == id then
      obj:trade_in(id)
    end
  end)
end

local minigrid = {}

function minigrid:new(startx,starty,num,width)
  self.set = {}
  self.num = num * num
  self.width = width
  self.maxi = maxigrid:new(self,50)
  self.maxi:draw()
  minigrid:drawTile(startx,starty,num,width) 
  print(#self.set)
  assert(#self.set == self.num)
  return self
end


function minigrid:drawTile(startx,starty,num,width) 
  self.group = display.newGroup()
  local this = self 
  local tile = {}
  
  function tile:new(id,sprite_id)
    self.id = id
    a_tile = self
    self.sprite_id = sprite_id
    self.display = sprite:get(sprite_id)
    this.set[self.id] = tile
    this.group:insert(self.display)
    function tap(event)
      a_tile.sprite_id = a_tile.sprite_id + 1
      this.maxi:redraw_for(self)
      self:redraw()
      return true
    end
    self.display.tap = tap
    return self 
  end

  function tile:trade_in(id)
    if id == self.id then
      self:unlisten()
      new_ = sprite:get(self.sprite_id)
      new_.x = self.display.x
      new_.y = self.display.y
      new_.width = self.display.width
      new_.height = self.display.height
      this.group:remove(self.display)
      this.set[self.id] = nil
      this.set[self.id] = new_
      self.display = nil
      self.display = new_
      self:listen()
    end
  end

  function tile:redraw()
    local parent = self.display.parent
    parent:insert(self.display)
  end


  function tile:listen()
    self.display:addEventListener("tap", self.display )
  end

  function tile:unlisten()
    self.display:removeEventListener("tap", self.display )
  end

  return generate:tile(num,num,width,function (id,sprite_id,top,left)
    print("---- id " .. id)
   local atile = tile:new(id,sprite_id)
    print(width)
    atile.display.width = width
    atile.display.height = width
    print(top)
    atile.display.x = top
    print(left)
    atile.display.y = left
    print("listen for : ")
    print(atile.display)
    atile:listen()
  end,startx,starty)
end




function show()
  return  minigrid:new(20,20,3,width)
end
