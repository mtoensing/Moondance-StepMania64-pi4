local sButton = Var "Button"

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

local Extras = Def.ActorFrame{}

if sButton == "Hi-Hat Pedal" or sButton == "Kick" then
	Extras = Def.ActorFrame{
		InitCommand=function(self)
			if sButton == "Hi-Hat Pedal" then self:zoomx(-1) end
		end,
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Tap Note", "Foot" ),
			InitCommand=function(self)
				self:diffuse(color(Colours[sButton])):effectclock("beat"):wag()
			end
		},
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Tap Note", "Foot" ),
			InitCommand=function(self)
				self:blend("Modulate"):effectclock("beat"):wag()
			end
		}
	}
elseif sButton == "Crash" or sButton == "Ride" then
	Extras = Def.ActorFrame{
		InitCommand=function(self)
			self:zoom(.5)
			if sButton == "Ride" then self:zoomx(-.5) end
		end,
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Receptor Crash", "Bottom" ),
			InitCommand=function(self)
				self:diffuse(color(Colours[sButton])):effectclock("beat"):squish()
			end
		},
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Receptor Crash", "Top" ),
			InitCommand=function(self)
				self:effectclock("beat"):squish()
			end
		}
	}
elseif sButton == "Hi-Hat" then
	Extras = Def.ActorFrame{
		InitCommand=function(self)
			self:zoom(.5)
		end,
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Receptor Hat", "Bottom" ),
			InitCommand=function(self)
				self:diffuse(color(Colours[sButton])):effectclock("beat"):squish()
			end
		},
		Def.Sprite{
			Texture=NOTESKIN:GetPath( "_Receptor Hat", "Top" ),
			InitCommand=function(self)
				self:effectclock("beat"):squish()
			end
		}
	}
end

return Def.ActorFrame{
	Extras,
	Def.Quad {
		InitCommand=function(self)
			self:scaletoclipped(64,12)
				:diffuse(color(Colours[sButton]))
		end
	}
}