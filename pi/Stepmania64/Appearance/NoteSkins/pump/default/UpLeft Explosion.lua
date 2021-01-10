local Button = Var "Button"

return Def.ActorFrame {
	--note graphic
	NOTESKIN:LoadActor("UpLeft", "Tap Note") .. {
		InitCommand=function(self) self:blend("BlendMode_Add"):playcommand("Glow") end,
		W1Command=function(self) self:playcommand("Glow") end,
		W2Command=function(self) self:playcommand("Glow") end,
		W3Command=function(self) self:playcommand("Glow") end,
		W4Command=function(self) end,
		W5Command=function(self) end,
		HitMineCommand=function(self) self:playcommand("Glow") end,
		GlowCommand=function(self)
			self:rotationy(string.find(Button, "Right") and -180 or 0)
				:setstate(0)
				:finishtweening()
				:diffusealpha(1.0)
				:zoom(1.0)
				:linear(0.15)
				:diffusealpha(0.9)
				:zoom(1.15)
				:linear(0.15)
				:diffusealpha(0.0)
				:zoom(1.3)
		end,
		HeldCommand=function(self) self:playcommand("Glow") end
	},
	--tap
	NOTESKIN:LoadActor("UpLeft", "Ready Receptor")..{
		TapCommand=function(self)
			self:rotationy(string.find(Button, "Right") and -180 or 0)
				:finishtweening()
				:diffusealpha(1)
				:zoom(1)
				:linear(0.2)
				:diffusealpha(0)
				:zoom(1.2)
		end,
		InitCommand=function(self) self:pause():setstate(2):playcommand("Tap") end,
		HeldCommand=function(self) self:playcommand("Tap") end,
		ColumnJudgmentMessageCommand=function(self) self:playcommand("Tap") end
	},
	--explosion
	LoadActor("_flash")..{
		InitCommand=function(self) self:blend("BlendMode_Add"):playcommand("Glow") end,
		W1Command=function(self) self:playcommand("Glow") end,
		W2Command=function(self) self:playcommand("Glow") end,
		W3Command=function(self) self:playcommand("Glow") end,
		W4Command=function(self) end,
		W5Command=function(self) end,
		HitMineCommand=function(self) self:playcommand("Glow") end,
		HeldCommand=function(self) self:playcommand("Glow") end,
		GlowCommand=cmd(setstate,0;finishtweening;diffusealpha,1;zoom,0.8;linear,0.2;diffusealpha,0;zoom,1.0)
	},
	--thing...
	Def.Quad {
		InitCommand=function(self) self:zoomto(50,5000):diffusealpha(0) end,
		HitMineCommand=function(self) self:finishtweening():diffusealpha(1):linear(0.3):diffusealpha(0) end
	}
}