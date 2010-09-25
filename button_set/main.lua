--
-- objective : set of squares as buttons
--
--
--

local width,height = 100,100

local d_vcw =  display.viewableContentWidth
local d_vch = display.viewableContentHeight

local x_c = d_vcw / width
local y_c = d_vch / height

local left = 0
local top = 0
local y = 1
local bt = {}
for x = 0,x_c,1 do
  for  y = 0,y_c,1 do
    local rect
    local r = math.random( 0, 200 )
    local g = math.random( 0, 200 )
    local b = math.random( 0, 200 )

    print("left" .. left)
    print("top" .. top)
    left = x*width
    top =  y*height
    rect = display.newRect(left,top,width,height) 
    rect.strokeWidth = 4
    rect:setStrokeColor( 0xFF, 0xFF, 0xFF )
    rect:setFillColor( r, g, b )
    function rect:tap(event) 
      print('-x:'..self.x.. '-y:'..self.y)
      print('-w:'..self.width.. '-h:'..self.height)
    local r = math.random( 0, 200 )
    local g = math.random( 0, 200 )
    local b = math.random( 0, 200 )
    self:setFillColor( r, g, b )
      print(self)
      print('---')
    end
    rect:addEventListener( "tap", rect )
 end
end
