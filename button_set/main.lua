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
    local r = math.random( 0, 255 )
    local g = math.random( 0, 255 )
    local b = math.random( 0, 255 )

    print("left" .. left)
    print("top" .. top)
    left = x*width
    top =  y*height
    rect = display.newRect(left,top,width,height) 
    rect:setStrokeColor( r, g, b )
    rect:setFillColor( r, g, b )
    function rect:tap(event) 
      print('-x:'..self.x.. '-y:'..self.y)
      print('-w:'..self.width.. '-h:'..self.height)
      print(self)
      print('---')
    end
    rect:addEventListener( "tap", rect )
 end
end
