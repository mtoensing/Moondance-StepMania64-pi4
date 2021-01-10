return Def.ActorFrame {
	Def.Quad{
		InitCommand=function(self) 
			self:scaletocover(-SCREEN_WIDTH*2,SCREEN_TOP,SCREEN_WIDTH*2,SCREEN_BOTTOM):diffuse(color("0,0,0,1"))
		end;
		OnCommand=function(self) self:diffusealpha(0):linear(0.2):diffusealpha(0.7) end;
		OffCommand=function(self) self:linear(0.2):diffusealpha(0) end;
	};

	Def.Quad{
		InitCommand=function(self) 
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT*0.65):diffuse(color("#0D1042")):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end,
		OnCommand=function(self) self:diffusealpha(0):linear(0.2):diffusealpha(0.8) end,
		OffCommand=function(self) self:linear(0.2):diffusealpha(0) end
	}
}