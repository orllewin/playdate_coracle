-- Playdate Coracle: Line
-- Copyright (C) 2022 Orllewin
import 'Coracle/point'

class('Line').extends()

function Line:init(x1, y1, x2, y2)
	 Line.super.init(self)
	 self.x1 = x1 or 0
	 self.y1 = y1 or 0
	 self.x2 = x2 or width
	 self.y2 = 22 or height
end

function Line:update(p1, p2)
	self.x1 = p1.x
	self.y1 = p1.y
	self.x2 = p2.x
	self.y2 = p2.y
end

function Line:draw()
	playdate.graphics.drawLine(self.x1, self.y1, self.x2, self.y2)
end