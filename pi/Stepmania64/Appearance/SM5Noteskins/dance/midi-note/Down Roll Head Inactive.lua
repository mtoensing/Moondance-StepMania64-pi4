return Def.Sprite {
	Texture=NOTESKIN:GetPath('Down','Roll Head Active');
	InitCommand=function(self)
		self:diffuse(color("0.5,0.5,0.5,1"))
	end;
};