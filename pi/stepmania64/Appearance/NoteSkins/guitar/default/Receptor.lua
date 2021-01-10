local sButton = Var "Button"
local sPlayer = Var "Player"

if sButton == "Strum Up" then return Def.ActorFrame{} end

local Reverse = string.find(GAMESTATE:GetPlayerState(sPlayer):GetPlayerOptionsString("ModsLevel_Preferred"):lower(), "reverse") and 1 or -1


local play = 1
Explosion = Def.ActorFrame {
	W1Command=function(self) self:queuecommand("Move") end,
	W2Command=function(self) self:queuecommand("Move") end,
	W3Command=function(self) self:queuecommand("Move") end,
	MoveCommand=function(self)
		play = play + 1
		if play > 15 then play = 1 end
	end
}

for i=1,6 do
	for i2=1,15 do
		Explosion[#Explosion+1] = Def.Sprite{
			Texture=NOTESKIN:GetPath( "_"..sButton, "Part" ),
			InitCommand=function(self) self:diffusealpha(0) end,
			W1Command=function(self) self:queuecommand("Move") end,
			W2Command=function(self) self:queuecommand("Move") end,
			W1Command=function(self) self:queuecommand("Move") end,
			W4Command=function(self) self:diffusealpha(0) end,
			W5Command=function(self) self:diffusealpha(0) end,
			MoveCommand=function(self)
				if play == i2 then
					self:finishtweening()
						:diffusealpha(1)
						:x(-1)
						:y(-1)
						:bounceend(1)
						:x(30*math.random(-4,4))
						:y((15*math.random(2,8))*Reverse)
						:diffusealpha(0)
				end
			end
		}
	end
end

return Def.ActorFrame {
	Def.Sprite {
		Texture=NOTESKIN:GetPath( "_"..Var "Button", "Receptor Go" ),
		InitCommand=function(self) self:effectclock("beat") end,
		NoneCommand=NOTESKIN:GetMetricA("ReceptorArrow", "NoneCommand"),
		W5Command=NOTESKIN:GetMetricA("ReceptorArrow", "W5Command"),
		W4Command=NOTESKIN:GetMetricA("ReceptorArrow", "W4Command"),
		W3Command=NOTESKIN:GetMetricA("ReceptorArrow", "W3Command"),
		W2Command=NOTESKIN:GetMetricA("ReceptorArrow", "W2Command"),
		W1Command=NOTESKIN:GetMetricA("ReceptorArrow", "W1Command")
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( "_"..Var "Button", "Receptor Press" ),
		InitCommand=function(self) self:diffusealpha(0) end,
		PressCommand=NOTESKIN:GetMetricA("ReceptorArrow", "PressCommand"),
		LiftCommand=NOTESKIN:GetMetricA("ReceptorArrow", "LiftCommand")
	},
	Explosion
}