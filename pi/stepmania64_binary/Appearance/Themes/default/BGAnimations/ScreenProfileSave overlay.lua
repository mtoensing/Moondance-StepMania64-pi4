local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
local x = Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self) self:diffusealpha(0):vertalign(bottom):y(SCREEN_BOTTOM+120) end;
		OnCommand=function(self) self:decelerate(0.2):addy(-118):diffusealpha(1) end;		
		OffCommand=function(self) self:sleep(0.4):decelerate(0.2):addy(118):diffusealpha(0) end;
		
		Def.Quad{
			InitCommand=function(self) self:vertalign(bottom):zoomto(SCREEN_WIDTH,120):x(SCREEN_CENTER_X):diffuse(ColorTable["promptBG"]):diffusealpha(1) end;
		};
		Def.BitmapText {
			Font="_SemiBold";
			Text=ScreenString("Saving Profiles");
			OnCommand=function(self) self:xy(60,-76):horizalign(left):diffuse(color("#EEF1FF")):zoom(1.5) end;
		};
	};
};

x[#x+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1); end;
		self:queuecommand("Load");
	end;
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue(); end;
};

return x;
