## Metaballs
![](./readme_assets/pd_metaballs.gif)
```lua
import 'Coracle/coracle'
import 'Coracle/vector'

scaleDisplay(8)

local maxSpeed = 0.9
local particleCount = 3

local blackhole = Vector(width/2, height/2)
local blackholeMass = 0.12

--Metaball fields
local xD = 0
local yD = 0
local sum = 0
local p = nil

local particles = {}

for i = 1 , particleCount do
	local particle = {}
	particle.location = Vector(math.random(width), math.random(height))
	particle.velocity = Vector(0, 0)
	particle.r = math.random(1,2)
	table.insert(particles, particle)
end

function playdate.update()
	background()
	
	--Central Mass
	local crank = crankChange()
	if(crank > 0)then
		blackholeMass = blackholeMass + 0.01
	elseif (crank < 0) then
		blackholeMass = blackholeMass - 0.01
	end
		
	for i = 1, particleCount do
		
		local body = particles[i]
				
		local blackholeDirection = vectorMinus(blackhole, body.location)
		blackholeDirection:normalise()
		blackholeDirection:times(blackholeMass)
		
		body.velocity:plus(blackholeDirection)
		body.location:plus(body.velocity)
		
		for j = 1, particleCount do
			if (i ~= j) then
				local other = particles[j]
				bodyDirection = vectorMinus(body.location, other.location)
				bodyDirection:normalise()
				bodyDirection:times(0.04)
				body.velocity:plus(bodyDirection)
				body.velocity:limit(maxSpeed)
				body.location:plus(body.velocity)
			end
		end
	end
	
	--Metaballs
	for x = 0, width do
		for y = 0, height do
			sum = 0
			for i = 1, #particles do
				p = particles[i]
				xD = p.location.x - x
			  yD = p.location.y - y
				sum += p.r / math.sqrt(xD * xD + yD * yD)
			end

			if(sum > 0.7)then
				point(x, y)
			end
		end
	end
	
	--For optimising, draw FPS on-screen:
	--playdate.drawFPS(1, 1)
end
```
<hr>

## Perlin Noise Flow Field
![](./readme_assets/pd_perlin_field.gif)
```lua
import 'Coracle/coracle'
import 'Coracle/vector'

local bodyCount = 100
local tailLength = 20
local frame = 0

local speed = 4.0
local scale = 0.003
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

function playdate.update()
  background()
  
  frame = frame + 1
  
  for i = 1, #bodies do
    
    local body = bodies[i]
    circle(body.location.x, body.location.y, 2)
    
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
  
  text('Scale: ' .. scale, 5, height - 20)
  
  
  epochAge = epochAge + 1
  
  if(epochAge > epochLength)then
    epochAge = 0
    xOffset = random(10000)
    yOffset = random(10000)
  end
end
```
<hr>

## Perlin Noise Flow Field (Optimised)

Scales the display: `scaleDisplay(2)` which means less pixels need drawing, the amount of particles and the length of their tales can be reduced.

![](./readme_assets/pd_perlin_field_optimised.gif)

```lua
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
```

## Attractor
Playdate port of [coracle/drawings/ports/attractor](https://orllewin.github.io/coracle/drawings/ports/attractor/)

![](./readme_assets/pd_attractor.gif)

```lua
import 'Coracle/coracle'

local x = 0.0
local y = 0.0
local frame = 0
local f = 0
local change = 0

invertDisplay()

function playdate.update()
  background()
  
  change = crankChange()
  
  if(change < 0) then
    frame = frame - 1
  elseif(change > 0) then
    frame = frame + 1
  end
  
  f = frame/25.0
  
  for i = 0, 600, 1
  do
    x = x * cos(4 * (f/2) + y * 2) + y/4
    y = cos(x + y + x + f/3) - sin(i + x + f)/4
    point((width/2) + (x * (width/2.5)), (height/2) + (y * (height/3)))
  end
end
```
<hr>

## Filaments
Playdate port of [coracle/drawings/ports/filaments/](https://orllewin.github.io/coracle/drawings/ports/filaments/)

![](./readme_assets/pd_filemants_original.gif)

```lua
import 'Coracle/coracle'

local x = 0.0
local y = -1.00
local z = -1.00
local ii = 0

local frame = 0
local change = 0

invertDisplay()

function playdate.update()
  background()
  
  frame = frame + 4
    
  z = -1.00
  y = -1.00
  
  for i = -1000, 1000, 2
  do
    ii = i/1000.00
    x = ii * 2.4 + sin(z/52.0) / 5.0
    y = 4 * cos(ii * y - 2)
    z = 8 + y * sin(3 * ii + (frame/50.0)) * 20.0
    point((width/2) + (width/6) * x, (height/2) + z+y)
  end
end
```

The same 'filaments' code but optimised for Playdate, fewer steps, and change controlled by the crank:

![](./readme_assets/pd_filaments.gif)

```lua
import 'Coracle/coracle'

local x = 0.0
local y = -1.00
local z = -1.00
local ii = 0

local frame = 0
local change = 0

function playdate.update()
  background()
  
  change = crankChange()
  
  if(change < 0) then
    frame = frame - 4
  elseif(change > 0) then
    frame = frame + 4
  end
  
  z = -1.00
  y = -1.00
  
  for i = -100, 100, 2
  do
    ii = i/100.00
    x = ii * 2.4 + sin(z/52.0) / 5.0
    y = 4 * cos(ii * y - 2)
    z = 8 + y * sin(3 * ii + (frame/50.0)) * 20.0
    fill((8 - y/5)/10)
    circle((width/2) + (width/6) * x, (height/2) + z+y, 6 - z/4)
  end
end
```
<hr>

## Particles
![](./readme_assets/pd_particles.gif)

```lua
import 'Coracle/coracle'
import 'Coracle/vector'

local maxSpeed = 2.2
local particleCount = 5

local blackhole = Vector(width/2, height/2)
local blackholeSize = 35
local blackholeMass = 0.4
local particles = {}

for i = 1 , particleCount do
  local boid = {}
  boid.location = Vector(math.random(width), math.random(height))
  boid.velocity = Vector(0, 0)
  table.insert(particles, boid)
end

function playdate.update()
  background()
  
  --Central Mass
  local crank = crankChange()
  if(crank > 0)then
    blackholeSize = blackholeSize + 0.75
    blackholeMass = blackholeMass + 0.01
  elseif (crank < 0) then
    blackholeSize = blackholeSize - 0.75
    blackholeMass = blackholeMass - 0.01
  end
  
  fill(0.25)
  circle(blackhole.x, blackhole.y, blackholeSize)
    
  --Particles
  fill(1.0)

  for i = 1, particleCount do
    
    local body = particles[i]
    
    circle(body.location.x, body.location.y, 10)
    
    local blackholeDirection = vectorMinus(blackhole, body.location)
    blackholeDirection:normalise()
    blackholeDirection:times(blackholeMass)
    
    body.velocity:plus(blackholeDirection)
    body.location:plus(body.velocity)
    
  for j = 1, particleCount 
  do
    if (i ~= j) then
      local other = particles[j]
      bodyDirection = vectorMinus(body.location, other.location)
      bodyDirection:normalise()
      bodyDirection:times(0.04)
      body.velocity:plus(bodyDirection)
      body.velocity:limit(4.0)
      body.location:plus(body.velocity)
    end
  end
  end
end
```
<hr>

## Particles with tails
![](./readme_assets/pd_particle_tails.gif)

```lua
import 'Coracle/coracle'
import 'Coracle/vector'

local maxSpeed = 2.2
local particleCount = 5
local tailLength = 20
local frame = 0

local blackhole = Vector(width/2, height/2)
local blackholeSize = 35
local blackholeMass = 0.4
local particles = {}

for i = 1 , particleCount do
  local boid = {}
  boid.location = Vector(math.random(width), math.random(height))
  boid.velocity = Vector(0, 0)
  boid.tailXs = {}
  boid.tailYs = {}
  
  for t = 1, tailLength do
    boid.tailXs[t] = -1
    boid.tailYs[t] = -1
  end
  table.insert(particles, boid)
end

function playdate.update()
  background()
  frame = frame + 1
  
  --Central Mass
  local crank = crankChange()
  if(crank > 0)then
    blackholeSize = blackholeSize + 0.75
    blackholeMass = blackholeMass + 0.01
  elseif (crank < 0) then
    blackholeSize = blackholeSize - 0.75
    blackholeMass = blackholeMass - 0.01
  end
  
  fill(0.25)
  circle(blackhole.x, blackhole.y, blackholeSize)
    
  --Particles
  fill(1.0)

  for i = 1, particleCount do
    
    local body = particles[i]
    
    fill(1.0)
    circle(body.location.x, body.location.y, 10)
    
    local tailIndex = frame % tailLength
    body.tailXs[tailIndex] = body.location.x
    body.tailYs[tailIndex] = body.location.y
    
    fill(0.5)
    for t = 1, tailLength do
      circle(body.tailXs[t], body.tailYs[t], 3)
    end
    
    local blackholeDirection = vectorMinus(blackhole, body.location)
    blackholeDirection:normalise()
    blackholeDirection:times(blackholeMass)
    
    body.velocity:plus(blackholeDirection)
    body.location:plus(body.velocity)
    
  for j = 1, particleCount 
  do
    if (i ~= j) then
      local other = particles[j]
      bodyDirection = vectorMinus(body.location, other.location)
      bodyDirection:normalise()
      bodyDirection:times(0.04)
      body.velocity:plus(bodyDirection)
      body.velocity:limit(4.0)
      body.location:plus(body.velocity)
    end
  end
  end
end
```

<hr>

## Cells
![](./readme_assets/pd_cells.gif)
```lua
import 'Coracle/coracle'
import 'Coracle/vector'

local maxSpeed <const> = 0.6
local cellWidth = 40.0
local cellRadius = cellWidth/2.0
local cellInnerRadius = cellWidth/4
local cells = {}

local centralMass = Vector(width/2, height/2)

local initial = {}
initial.location = Vector(width/2  + math.random(-5, 5), height/2 + math.random(-5, 5))
initial.velocity = Vector(0, 0)
table.insert(cells, initial)

playdate.startAccelerometer()

function playdate.update()
  background()
    
  for i = 1, #cells do
  
    local cell = cells[i]
    
    noFill()
    stroke()
    circle(cell.location.x, cell.location.y, cellRadius)
    
    fill(0.5)
    circle(cell.location.x, cell.location.y, cellInnerRadius)
    
    local centralMassDirection = vectorMinus(centralMass, cell.location)
    centralMassDirection:normalise()
    centralMassDirection:times(0.2)
    
    cell.velocity:plus(centralMassDirection)
    cell.location:plus(cell.velocity)
    
    local closestDistance = 1000.0
    local closestIndex = -1
    
    for j = 1, #cells do
      if (i ~= j) then
        local other = cells[j]
        local dist = cell.location:distance(other.location)
        if(dist < closestDistance)then
            closestIndex = j
            closestDistance = dist
        end  
      end
    end
    
    local distanceToMass = cell.location:distance(centralMass)
    if(distanceToMass < cellRadius * 2)then
      local direction = vectorMinus(centralMass, cell.location)
      direction:normalise()
      direction:times(-0.9)
      
      cell.velocity:plus(direction)
      cell.velocity:limit(maxSpeed)
    else
      local closest = cells[closestIndex]
      
      if(closestDistance < cellWidth)then
        local direction = vectorMinus(closest.location, cell.location)
        direction:normalise()
        direction:times(-0.7)
        
        cell.velocity:plus(direction)
        cell.velocity:limit(maxSpeed)
      end
    end
    
    cell.location:plus(cell.velocity)
    
    if(cell.location.y > height - cellRadius)then cell.location.y = height - cellRadius end
    if(cell.location.y < cellRadius)then cell.location.y = cellRadius end
    if(cell.location.x > width - cellRadius)then cell.location.x = width - cellRadius end
    if(cell.location.x < cellRadius)then cell.location.x = cellRadius end
  end
    
  -- Crank - change cell size/zoom level
  local crank = crankChange()
  if(crank > 0)then
    cellWidth = cellWidth + 1
    cellRadius = cellWidth/2.0
    cellInnerRadius = cellWidth/4
  elseif(crank < 0 and cellWidth > 20)then
    cellWidth = cellWidth - 1
    cellRadius = cellWidth/2.0
    cellInnerRadius = cellWidth/4
  end
  
  --Add new cell
  if(aPressed())then
      local newCell = {}
      newCell.location = Vector(width/2  + math.random(-5, 5), height/2 + math.random(-5, 5))
      newCell.velocity = Vector(0, 0)
      table.insert(cells, newCell)
  end
  
  --Remove a cell
  if(bPressed())then
    if(#cells > 1)then
      local deleteIndex = math.random(#cells)
      table.remove(cells, deleteIndex)
    end
  end
  
  -- Move food source/central mass
  -- Values are -1.0 to 1.0 we need it in form 0.0 to 1.0
  local x, y, z = playdate.readAccelerometer()
  centralMass.x = 400.0 * ((x + 1.0)/2.0)
  centralMass.y = 240.0 * ((y + 1.0)/2.0)
  fill(1.0)
  circleV(centralMass, cellInnerRadius)
  
  noFill()
  stroke()
  circleV(centralMass, cellRadius)
  
  fill(0.5)
  circleV(centralMass, cellInnerRadius)
end
```
<hr>
