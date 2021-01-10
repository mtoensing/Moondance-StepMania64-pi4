return Def.ActorFrame {
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Tap Mine' ),
		InitCommand=function(self)
			self:spin():effectclock('beat'):effectmagnitude(0,0,-33)
		end
	}
}
