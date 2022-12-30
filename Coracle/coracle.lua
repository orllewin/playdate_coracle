import 'CoreLibs/graphics'
import 'CoreLibs/object'

local graphics <const> = playdate.graphics
local _cos, _sin = math.cos, math.sin
local _random = math.random

width = 400
height = 240
alpha = 1.0
pi = 3.14159265
tau = 6.28318

DrawingMode = {Stroke = "0", Fill = "1"}
coracleDrawMode = DrawingMode.Fill

function invertDisplay()
	playdate.display.setInverted(true)
end

function crankChange()
	local change, acceleratedChange = playdate.getCrankChange()
	return change
end

function aPressed()
  return playdate.buttonJustPressed(playdate.kButtonA)
end

function bPressed()
  return playdate.buttonJustPressed(playdate.kButtonB)
end

function upPressed()
  return playdate.buttonIsPressed(playdate.kButtonUp)
end

function downPressed()
  return playdate.buttonIsPressed(playdate.kButtonDown)
end

function leftPressed()
  return playdate.buttonIsPressed(playdate.kButtonLeft)
end

function rightPressed()
  return playdate.buttonIsPressed(playdate.kButtonRight)
end

function background()
  graphics.clear(graphics.kColorWhite)
end

function noStroke()
  coracleDrawMode = DrawingMode.Fill
end

function noFill()
  coracleDrawMode = DrawingMode.Stroke
  graphics.setDitherPattern(0.0, playdate.graphics.image.kDitherTypeScreen)
end

function stroke()
 coracleDrawMode = DrawingMode.Stroke
end

function fill()
  coracleDrawMode = DrawingMode.Fill
end

-- alpha: 0.0 to 1.0
function fill(_alpha)
  alpha = _alpha
  graphics.setDitherPattern(1.0 - alpha, playdate.graphics.image.kDitherTypeBayer8x8)
  coracleDrawMode = DrawingMode.Fill
end

-- Maths
function random(a, b)
	return math.random(a, b)
end

function cos(value)
	return _cos(value)
end

function sin(value)
	return _sin(value)
end

function random(a, b)
  if(a == nil and b == nil)then
    return _random()
  elseif(b == nil)then
    return _random(a)
  else
    return _random(a, b)
  end
end

function perlinNoise(x, y)
	return playdate.graphics.perlin(x, y, 1)
end

-- Draw

function text(text, x, y)
  graphics.drawText(text, x, y)
end

function circle(x, y, r)
	if(coracleDrawMode == DrawingMode.Fill) then
		graphics.fillCircleAtPoint(x, y, r)
  	else
		graphics.drawCircleAtPoint(x, y, r)
  	end
end

function circleP(p, r)
	if(coracleDrawMode == DrawingMode.Fill)
	  then
		graphics.fillCircleAtPoint(p.x, p.y, r)
	  else
		graphics.drawCircleAtPoint(p.x, p.y, r)
	  end
end

function circleV(vector, r)
	if(coracleDrawMode == DrawingMode.Fill)
	  then
		graphics.fillCircleAtPoint(vector.x, vector.y, r)
	  else
		graphics.drawCircleAtPoint(vector.x, vector.y, r)
	  end
end

function point(x, y)
	graphics.drawPixel(x, y)
end

function line(x1, y1, x2, y2)
	graphics.drawLine(x1, y1, x2, y2)
end