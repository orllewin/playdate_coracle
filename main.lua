import 'Coracle/coracle'

invertDisplay()

local frame = 0
local z = 0
local a = 0
local x = 0
local y = 0
local yOffset = 80
local g = 0

function playdate.update()	
	background()
	
	frame += 4
	
	for i = 150, 1, -1 do
		z = height * 35 / i
		a = (i * 2) + (frame * 2)
		x = sin(a) * z + (sin(a/width * 1.2) + 2) * 105
		y = cos(a) * z + (sin(a/height * 0.8) + 2) * 105
		fill(z * 0.001)
		circle(x, y - yOffset,  min(150, z * 0.55))
	end
end