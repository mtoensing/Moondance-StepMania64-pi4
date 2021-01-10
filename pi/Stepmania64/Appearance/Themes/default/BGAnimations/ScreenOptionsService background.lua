local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) self:diffuse( ColorTable["serviceBG"] ) end,
	},
}