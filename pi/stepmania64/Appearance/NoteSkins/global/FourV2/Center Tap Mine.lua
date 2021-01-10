return Def.ActorFrame {
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Center', 'Tap Mine Underlay' ),
		Frames=Sprite.LinearFrames( 1, 1 ),
		InitCommand=function(self)
			self:diffuseshift()
				:effectcolor1(0.4,0,0,1)
				:effectcolor2(1,0,0,1)
				:effectclock('beat')
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Center', 'Tap Mine Base' ),
		Frames=Sprite.LinearFrames( 1, 1 ),
		InitCommand=function(self)
			self:spin():
				effectclock('beat')
				:effectmagnitude(0,0,80)
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Center', 'Tap Mine Overlay' ),
		Frames=Sprite.LinearFrames( 1, 1 ),
		InitCommand=function(self)
			self:spin()
				:effectclock('beat')
				:effectmagnitude(0,0,-40)
		end
	}
}
