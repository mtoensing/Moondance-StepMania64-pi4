return Def.ActorFrame {
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,68):diffuse(getenv("sectionWheelItemColorA")):diffuserightedge(getenv("sectionWheelItemColorB")) end;
	};		
	Def.Quad {
		OnCommand=function(self) self:zoomto(420,2):vertalign(top):y(-34):diffuse(getenv("sectionWheelItemColorB")):diffusealpha(0.80) end;
	};	
};