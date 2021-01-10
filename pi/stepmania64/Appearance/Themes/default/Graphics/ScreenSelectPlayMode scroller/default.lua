local gc = Var "GameCommand";
local string_name = gc:GetText();
local string_expl = THEME:GetString(Var "LoadingScreen", gc:GetName() .. "Explanation");
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

return Def.ActorFrame {
GainFocusCommand=function(self) self:finishtweening():visible(true):diffusealpha(0.75):zoom(1.1):decelerate(0.25):zoom(1):diffusealpha(1) end;
LoseFocusCommand=function(self) self:finishtweening():visible(false):zoom(1) end;
-- Emblem Frame
	Def.ActorFrame {
		FOV=90;
		-- Main Emblem
		Def.Sprite {
			Texture="_base";
			InitCommand=function(self) self:diffusealpha(0):zoom(0.75):diffuse(ColorTable["playModeIconsBaseColor"]):diffusebottomedge(ColorTable["playModeIconsBaseGradient"]) end;
			OnCommand=function(self) self:diffusealpha(0):zoom(1.2):sleep(0.2):decelerate(0.3):diffusealpha(1):zoom(1) end;
			GainFocusCommand=function(self) self:finishtweening():zoom(1):diffusealpha(1) end;
			LoseFocusCommand=function(self) self:finishtweening():smooth(0.4):diffusealpha(0):zoom(0.75) end;
			OffFocusedCommand=function(self) self:finishtweening():decelerate(0.3):diffusealpha(0):zoom(1.2) end;
		};		
		LoadActor( gc:GetName() ) .. {
			InitCommand=function(self) self:diffusealpha(0):zoom(0.75):diffuse(ColorTable["playModeIconsEmblem"]) end;
			OnCommand=function(self) self:diffusealpha(0):zoom(1.2):sleep(0.2):decelerate(0.3):diffusealpha(1):zoom(1) end;
			GainFocusCommand=function(self) self:finishtweening():zoom(1):diffusealpha(1) end;
			LoseFocusCommand=function(self) self:finishtweening():smooth(0.4):diffusealpha(0):zoom(0.75) end;
			OffFocusedCommand=function(self) self:finishtweening():decelerate(0.3):diffusealpha(0):zoom(1.2) end;
		};
	};

	-- Text Frame
	Def.ActorFrame {
		OnCommand=function(self) self:diffusealpha(0):sleep(0.2):decelerate(0.3):diffusealpha(1) end;
		Def.BitmapText {
			Font="_Large Bold";
			Text=string_name;
			InitCommand=function(self) self:y(160):skewx(-0.15):zoom(1) end;
			GainFocusCommand=function(self) self:finishtweening():decelerate(0.45):diffusealpha(1) end;
			LoseFocusCommand=function(self) self:finishtweening():decelerate(0.45):diffusealpha(0) end;
			OffFocusedCommand=function(self) self:finishtweening():decelerate(0.3):diffusealpha(0):zoomx(1.1) end;
		};
		Def.BitmapText {
			Font="_Condensed Medium";
			Text=string_expl;
			InitCommand=function(self) self:y(200):wrapwidthpixels(290):vertalign(top) end;
			GainFocusCommand=cmd(decelerate,0.45;diffusealpha,1;);
			LoseFocusCommand=cmd(accelerate,0.4;diffusealpha,0;diffusealpha,0);
			OffFocusedCommand=function(self) self:finishtweening():decelerate(0.3):diffusealpha(0):zoomx(1.1) end;
		};
	};
};