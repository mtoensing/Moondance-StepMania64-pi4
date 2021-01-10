
return Def.ActorFrame {
	OnCommand=function(self) self:diffusealpha(0):smooth(3):diffusealpha(0.93) end;
	OffCommand=function(self) self:stoptweening():smooth(0.5):diffusealpha(0) end;
	Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) self:diffuse(color("#992828")):diffusebottomedge(color("#840F0F")) end
	},	
	Def.Sprite {
		Texture="_strip";
		InitCommand=function(self) self:xy(SCREEN_LEFT+24,SCREEN_CENTER_Y):zoomto(36,1024):diffuse(color("#F6E5B0")):blend('Add'):diffusealpha(0.8) end;
	},
	Def.Sprite {
		Texture="_strip";
		InitCommand=function(self) self:xy(SCREEN_RIGHT-24,SCREEN_CENTER_Y):zoomto(36,1024):diffuse(color("#F6E5B0")):blend('Add'):diffusealpha(0.8) end;
	},
	Def.Sprite {
		Texture="_dragon";
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):blend('Add'):diffusealpha(0.5):zoom(1.25) end;
	},
}

