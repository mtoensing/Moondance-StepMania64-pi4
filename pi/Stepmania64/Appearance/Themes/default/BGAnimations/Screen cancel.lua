return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,1):vertalign(top):x(SCREEN_CENTER_X):y(SCREEN_TOP)
			self:diffuse(Color.Black):draworder(12000)
		end;
		OnCommand=function(self)
			self:decelerate(0.2):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		end;
	};
	LoadActor(THEME:GetPathS("_Screen","cancel")) .. {
		IsAction= true,
		StartTransitioningCommand=function(self) self:play() end;
	};

};