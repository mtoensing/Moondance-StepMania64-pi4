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

local function Explosion(self)
	self:rotationz(0)
		:stoptweening()
		:diffusealpha(1)
		:zoom(.75)
		:linear(.15)
		:zoom(1)
		:rotationz(90)
		:diffusealpha(0)
end

return Def.ActorFrame{
	-- Put in empty ActorFrane, Else colour doesnt work.
	Def.Sprite {
		Texture=NOTESKIN:GetPath( "_Tap", "Explosion" ),
		InitCommand=function(self) self:diffuse(color(Colours[sButton])) end,
		W1Command=function(self) Explosion(self) end,
		W2Command=function(self) Explosion(self) end,
		W3Command=function(self) Explosion(self) end,
		W4Command=function(self) self:diffusealpha(0) end,
		W5Command=function(self) self:diffusealpha(0) end
	}
}

