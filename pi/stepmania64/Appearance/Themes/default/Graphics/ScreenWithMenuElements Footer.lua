local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) 
			self:vertalign(bottom):zoomto(SCREEN_WIDTH,44)
			:diffuse( ColorTable["swmeFooter"] )
			:diffusealpha(0.86)
		end;
	},
	Def.Quad {
		InitCommand=function(self) 
			self:vertalign(bottom):zoomto(SCREEN_WIDTH,2):addy(-42)
			self:diffuse( ColorTable["headerStripeA"] ):diffuseleftedge( ColorTable["headerStripeB"] ):diffusealpha(0.5)
		end;
	}
};