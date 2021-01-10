local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
return Def.ActorFrame {
	-- Trim
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(bottom):zoomto(SCREEN_WIDTH,3):y(306-68)
			self:diffuse(ColorTable["headerStripeA"]):diffuserightedge(ColorTable["headerStripeB"])
			:diffusealpha(0.6)
		end;
	};
		-- Explanation
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(bottom):zoomto(SCREEN_WIDTH,68):y(306)
			self:diffuse(ColorTable["optionExplanationBG"])
		end;
	};	
}