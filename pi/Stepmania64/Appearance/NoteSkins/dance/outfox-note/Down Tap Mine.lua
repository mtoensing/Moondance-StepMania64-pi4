return Def.ActorFrame{
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_new', 'mine' );
		InitCommand=function(self)
			self:wag():animate(true):effectclock('beat'):effectmagnitude(0,0,6)
		end;
	};
}