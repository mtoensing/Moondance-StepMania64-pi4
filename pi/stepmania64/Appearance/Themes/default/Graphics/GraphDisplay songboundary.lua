return Def.Quad{
	OnCommand=function(self)
		self:zoomto(2,80):diffusealpha(0.25):fadetop(0.1)
	end;
}