local ShowFlashyCombo = LoadModule("Config.Load.lua")("FlashyCombo","Save/OutFoxPrefs.ini")
return Def.ActorFrame {
	LoadActor("explosion") .. {
		InitCommand=function(self) self:diffusealpha(0):blend('BlendMode_Add'):hide_if(not ShowFlashyCombo):y(20) end;
		MilestoneCommand=function(self) self:rotationz(0):zoom(0.2):diffusealpha(0.3):linear(0.3):zoom(0.6):diffusealpha(0) end;
	};
};