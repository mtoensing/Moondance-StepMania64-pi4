local sButton = Var "Button"

local sRotations =
{
	Left = 90,
	UpLeft = 45,
	Up = 0,
	UpRight = -45,
	Right = -90
}


return Def.ActorFrame{
	Def.Sprite{
		Texture=NOTESKIN:GetPath("_Receptor", "Arrow")
	},
	Def.Sprite{
		Texture=NOTESKIN:GetPath("_Receptor", "Light"),
		OnCommand=function(self) 
			self:rotationz(sRotations[sButton])
				:zoomx(0):zoomy(999)
		end,
		PressCommand=function(self) self:stoptweening():zoomx(.8) end,
		LiftCommand=function(self) self:linear(.2):zoomx(0) end,
	}
}