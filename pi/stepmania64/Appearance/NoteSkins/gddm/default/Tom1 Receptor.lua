local NumExplosions = 20

local sButton = Var "Button"
local sPlayer = Var "Player"

local Reverse = string.find(GAMESTATE:GetPlayerState(sPlayer):GetPlayerOptionsString("ModsLevel_Preferred"):lower(), "reverse") and 1 or -1

local Buttons = {
	["Crash"] = "Crash ",
	["Hi-Hat"] = "Hat ",
	["Hi-Hat Pedal"] = "Hi ",
	["Snare"] = "",
	["Tom1"] = "",
	["Kick"] = "Foot ",
	["Tom2"] = "",
	["Tom3"] = "",
	["Ride"] = "Crash "
}

local Colours = {
	["Crash"] = "#FF00FF",
	["Hi-Hat"] = "#00FFFF",
	["Hi-Hat Pedal"] = "#FF00FF",
	["Snare"] = "#FFFF00",
	["Tom1"] = "#00FF00",
	["Kick"] = "#800080",
	["Tom2"] = "#FF0000",
	["Tom3"] = "#FFA500",
	["Ride"] = "#00FFFF"
}

local Pos = {
	["Crash"] = 32,
	["Hi-Hat"] = 32,
	["Hi-Hat Pedal"] = 32,
	["Snare"] = 48,
	["Tom1"] = 32,
	["Kick"] = 32,
	["Tom2"] = 32,
	["Tom3"] = 48,
	["Ride"] = 32
}

local CurBar = 1

local Explosion = Def.ActorFrame{
	W1Command=function(self) self:queuecommand("Increase") end,
	W2Command=function(self) self:queuecommand("Increase") end,
	W3Command=function(self) self:queuecommand("Increase") end,
	IncreaseCommand=function() 
		CurBar = CurBar + 1
		if CurBar > NumExplosions then CurBar = 1 end
	end
}

for i = 1,NumExplosions do
	for j = -1,1,2 do
		Explosion[#Explosion+1] = Def.ActorFrame {
			InitCommand=function(self) self:diffusealpha(0) end,
			W1Command=function(self) self:playcommand("Move") end,
			W2Command=function(self) self:playcommand("Move") end,
			W3Command=function(self) self:playcommand("Move") end,
			MoveCommand=function(self)
				if CurBar == i then
					self:stoptweening()
						:x(96*j)
						:diffusealpha(1)
						:rotationz(0)
						:linear(.5)
						:rotationz(180*j*Reverse)
						:diffusealpha(0)
				end
			end,
			Def.Quad {
				InitCommand=function(self) self:scaletoclipped(32,12):diffuse(color(Colours[sButton])) end,
				W1Command=function(self) self:playcommand("Move") end,
				W2Command=function(self) self:playcommand("Move") end,
				W3Command=function(self) self:playcommand("Move") end,
				MoveCommand=function(self)
					if CurBar == i then
						self:stoptweening()
							:x(-80*j)
							:rotationz(0)
							:linear(.5)
							:rotationz(360*j*Reverse)
					end
				end
			}
		}
	end
end

return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self)
			self:scaletoclipped(64,12):diffuse(1,1,0,1)
		end
	},
	Def.ActorFrame{
		InitCommand=function(self)
			self:y(Pos[sButton]*Reverse)
			if sButton == "Ride" then self:zoomx(-1) end
		end,
		Def.Sprite {
			Texture=NOTESKIN:GetPath( "_Receptor", Buttons[sButton].."Bottom" ),
			InitCommand=function(self)
				self:diffuse(color(Colours[sButton]))
			end,
			PressCommand=function(self)
				self:stoptweening()
					:y(0)
					:bounceend(.075)
					:y(10)
			end,
			LiftCommand=function(self)
				self:stoptweening()
					:bounceend(.075)
					:y(0)
			end
		},
		Def.Sprite {
			Texture=NOTESKIN:GetPath( "_Receptor", Buttons[sButton].."Top" ),
			InitCommand=function(self)
			end,
			PressCommand=function(self)
				self:stoptweening()
					:y(0)
					:bounceend(.075)
					:y(10)
					:diffusealpha(0)
			end,
			LiftCommand=function(self)
				self:finishtweening()
					:bounceend(.075)
					:y(0)
					:diffusealpha(1)
			end
		}
	},
	Explosion
}