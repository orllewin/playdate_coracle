## 4 Midi

Not using Coracle but wanted to document this midi player

```lua
local snd = playdate.sound

s = snd.sequence.new('4.mid')

function newsynth()
	local s = snd.synth.new(snd.kWaveTriangle)
	s:setVolume(0.2)
	s:setAttack(0.2)
	s:setDecay(0.25)
	s:setSustain(0.2)
	s:setRelease(0)
	return s
end

function newinst(n)
	local inst = snd.instrument.new()
	for i=1,n do
		inst:addVoice(newsynth())
	end
	return inst
end

local ntracks = s:getTrackCount()
local active = {}
local poly = 0
local tracks = {}

for i=1,ntracks do
	local track = s:getTrackAtIndex(i)
	if track ~= nil then
		local n = track:getPolyphony(i)
		if n > 0 then active[#active+1] = i end
		if n > poly then poly = n end
		print("track "..i.." has polyphony "..n)
	
		if i == 10 then
			--track:setInstrument(druminst(n))
			track:setInstrument(newinst(n))
		else
			track:setInstrument(newinst(n))
		end
	end
end

s:play()
```