import 'Coracle/coracle'
import 'Coracle/vector'

local bodyCount = 75
local tailLength = 10
local frame = 0

local speed = 2.75
local scale = 0.010
local bodies = {}

local xOffset = 0.0
local yOffset = 0.0

local epochAge = 0
local epochLength = 100

for i = 1 , bodyCount do
	local boid = {}
	boid.location = Vector(random(width), random(height))
	boid.age = 0
	boid.deathAge = random(50, 200)
	boid.tailXs = {}
	boid.tailYs = {}
	
	for t = 1, tailLength do
		boid.tailXs[t] = -1
		boid.tailYs[t] = -1
	end
	table.insert(bodies, boid)
end
	
xOffset = random(10000)
yOffset = random(10000)

scaleDisplay(2)

function playdate.update()
	background()
	
	frame = frame + 1
	
	for i = 1, #bodies do
		
		local body = bodies[i]
		circle(body.location.x, body.location.y, 1)
		
		for t = 1, tailLength do
			point(body.tailXs[t], body.tailYs[t])
		end
		
		local a = 2 * tau * perlinNoise((body.location.x + xOffset) * scale, (body.location.y + yOffset) * scale)
		body.location.x = body.location.x + (cos(a) * speed)
		body.location.y = body.location.y + (sin(a) * speed)
		
		local tailIndex = frame % tailLength
		body.tailXs[tailIndex] = body.location.x
		body.tailYs[tailIndex] = body.location.y
		
		if (body.location.x > width)then
			body.location.x = random(width)
			body.location.y = random(height)
		end
		if (body.location.x < 0)then 
			body.location.x = random(width)
			body.location.y = random(height)
		end
		if (body.location.y > height)then
			body.location.x = random(width)
			body.location.y = random(height)
		 end
		if (body.location.y < 0)then
			body.location.x = random(width)
			body.location.y = random(height)
		end
		
		body.age = body.age + 1
		
		if(body.age > body.deathAge)then
			body.location.x = random(width)
			body.location.y = random(height)
			body.age = 0
			body.deathAge = random(50, 200)
		end
	end
	
	local crank =  crankChange()
	
	if(crank > 0)then
		scale = scale + 0.0001
	elseif(crank < 0)then
		scale = scale - 0.0001
	end

	epochAge = epochAge + 1
	
	if(epochAge > epochLength)then
		epochAge = 0
		xOffset = random(10000)
		yOffset = random(10000)
	end
end