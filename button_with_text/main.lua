-- corana lua
-- app
-- robotarmy (cc)2010 gpl
local textObject = display.newText( "Hello World!", 50, 50, nil, 24 )
textObject:setTextColor( 255, 50, 50 )

local button = display.newImage( "button.png" )
button.x = display.contentWidth / 2
button.y = display.contentHeight - 50
function button:tap( event )
  local r = math.random( 0, 255 )
  local g = math.random( 0, 255 )
  local b = math.random( 0, 255 )

  textObject:setTextColor( r, g, b )
end

button:addEventListener( "tap", button )
