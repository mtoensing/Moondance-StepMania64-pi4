return Def.ActorFrame {
		-- BG animation
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,1):vertalign(top):x(SCREEN_CENTER_X):y(SCREEN_TOP)
			self:diffuse(color("#750000")):diffusealpha(0.9)
		end;
		StartTransitioningCommand=function(self)
			self:decelerate(0.4):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		end;
	  };
	-- Scanline
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,5):vertalign(top):x(SCREEN_CENTER_X):y(SCREEN_TOP)
			self:diffuse(color("#e57b7b"))
		end;
		StartTransitioningCommand=function(self)
			self:decelerate(0.4):y(SCREEN_BOTTOM)
		end;
	  };
	  
	---Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:vertalign(middle):zoomto(SCREEN_WIDTH,0):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse(color("#990c0c")):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:decelerate(0.2):zoomtoheight(120)
		end;
	};
	Def.Sprite {
		Texture="_failed",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:diffusealpha(0):sleep(0.18):linear(0.2):diffusealpha(1)
		end;
	};
	-- };
	
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen():diffuse(color("#000000")):diffusealpha(0)
		end;
		StartTransitioningCommand=function(self)
			self:finishtweening():sleep(1.0):linear(2):diffusealpha(1)
		end;
	};
	LoadActor(THEME:GetPathS( Var "LoadingScreen", "failed" ) ) .. {
		StartTransitioningCommand=function(self) self:play() end;
	};

};