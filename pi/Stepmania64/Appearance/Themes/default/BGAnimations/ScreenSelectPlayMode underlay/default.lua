local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )

return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:vertalign(top):xy(SCREEN_CENTER_X-200,SCREEN_TOP):zoomto(400,0):diffuse(color("#000000")):diffusealpha(0.5) end;
		OnCommand=function(self) self:linear(0.14):zoomto(400,SCREEN_HEIGHT) end;
		OffCommand=function(self) self:sleep(0.2):decelerate(0.15):addy(SCREEN_HEIGHT) end;
	};	
	Def.Quad {
		InitCommand=function(self) self:vertalign(top):xy(SCREEN_CENTER_X+200,SCREEN_TOP):zoomto(400,0):diffuse( ColorTable["midShadeA"] ):diffusealpha(0.6) end;
		OnCommand=function(self) self:linear(0.14):zoomto(400,SCREEN_HEIGHT) end;
		OffCommand=function(self) self:sleep(0.2):decelerate(0.15):addy(-SCREEN_HEIGHT) end;
	};
};