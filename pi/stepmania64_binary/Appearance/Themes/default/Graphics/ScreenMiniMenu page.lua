local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
return Def.ActorFrame {
	-- Page
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(middle):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT*0.85)
			self:diffuse(ColorTable["serviceBG"]):diffusealpha(0.8)
		end;
	};	
}