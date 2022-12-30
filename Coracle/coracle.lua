import 'CoreLibs/graphics'
import 'CoreLibs/object'

local graphics <const> = playdate.graphics
local _cos, _sin = math.cos, math.sin

width = 400
height = 240
alpha = 1.0
pi = 3.14159265

DrawingMode = {Stroke = "0", Fill = "1", FillAndStroke = "2"}
coracleDrawMode = DrawingMode.Fill

function invertDisplay()
	playdate.display.setInverted(true)
end

function crankChange()
	local change, acceleratedChange = playdate.getCrankChange()
	return change
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
  if(coracleDrawMode == DrawingMode.Fill) 
  then
	coracleDrawMode = DrawingMode.FillAndStroke
  end
end

function fill()
  if(coracleDrawMode == DrawingMode.Stroke)
  then
	coracleDrawMode = DrawingMode.FillAndStroke
  end
end

-- alpha: 0.0 to 1.0
function fill(alpha)
  alpha = alpha
  graphics.setDitherPattern(1.0 - alpha, playdate.graphics.image.kDitherTypeBayer8x8)
  if(mode == DrawingMode.Stroke) 
  then
	mode = DrawingMode.FillAndStroke
  end
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

-- Draw
function circle(x, y, r)
	if(coracleDrawMode == DrawingMode.FillAndStroke)
	  then
		graphics.fillCircleAtPoint(x, y, r)
		graphics.drawCircleAtPoint(x, y, r)
	  elseif(coracleDrawMode == DrawingMode.Fill)
	  then
		graphics.fillCircleAtPoint(x, y, r)
	  else
		graphics.drawCircleAtPoint(x, y, r)
	  end
end

function circleP(p, r)
	if(coracleDrawMode == DrawingMode.FillAndStroke)
	  then
		graphics.fillCircleAtPoint(p.x, p.y, r)
		graphics.drawCircleAtPoint(p.x, p.y, r)
	  elseif(coracleDrawMode == DrawingMode.Fill)
	  then
		graphics.fillCircleAtPoint(p.x, p.y, r)
	  else
		graphics.drawCircleAtPoint(p.x, p.y, r)
	  end
end

function point(x, y)
	graphics.drawPixel(x, y)
end

function line(x1, y1, x2, y2)
	graphics.drawLine(x1, y1, x2, y2)
end