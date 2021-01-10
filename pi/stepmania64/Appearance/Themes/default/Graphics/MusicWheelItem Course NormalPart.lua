return Def.ActorFrame {
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,68):diffuse(getenv("musicWheelItemColor")):diffusealpha(0.75) end;
	};		
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,2):vertalign(top):y(-34):diffuse(color("#FFFFFF10")) end;
	};	
};