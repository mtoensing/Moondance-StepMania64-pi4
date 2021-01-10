return Def.ActorFrame{
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_down', 'tap mine' );
		Frame0000=0;
		Delay0000=1;
		InitCommand=function(self)
			self:spin():effectclock('beat'):effectmagnitude(0,0,-33)
		end;
	};
};
