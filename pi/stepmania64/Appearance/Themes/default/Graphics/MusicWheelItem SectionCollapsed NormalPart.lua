return Def.ActorFrame {
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,68):diffuse(getenv("sectionWheelItemColorA")):diffuserightedge(getenv("sectionWheelItemColorB")) end;
	};		
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,68):diffuse(color("#000000")):diffusealpha(0.35) end;
	};		
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,2):vertalign(top):y(-34):diffuse(getenv("sectionWheelItemColorB")):diffusealpha(0.55) end;
	};	
};