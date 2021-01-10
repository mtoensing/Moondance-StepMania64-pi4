local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
return Def.ActorFrame {
	Def.Sprite {
		Texture=THEME:GetPathG( 'LifeMeter', 'color');
		OnCommand=function(self) 
			self:diffuse(ColorTable["lifeMeter"]):blend("WeightedMultiply")
		end;
	};	
	Def.Sprite {
		Texture=THEME:GetPathG( 'LifeMeter', 'markers');
	};	
	Def.Sprite {
		Texture=THEME:GetPathG( 'LifeMeter', 'frame');
		OnCommand=function(self) 
			self:diffuse(ColorTable["lifeFrame"]) 
		end;
	};
};