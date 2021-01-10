return Def.ActorFrame{
    -- Transition
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):vertalign(bottom):x(SCREEN_CENTER_X):y(SCREEN_BOTTOM)
			self:diffuse(Color.Black)
		end;
		OnCommand=function(self)
			self:decelerate(0.5):diffusealpha(0)
		end;
    };

};