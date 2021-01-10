local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) self:diffuse( ColorTable["serviceBG"] ) end
	},
	
	-- Emblem
	Def.ActorFrame {
		InitCommand=function(self) self:Center():diffusealpha(0.5) end,
		LoadActor("_warning bg")
	},

	-- Text
	Def.ActorFrame {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-120) end;
		OnCommand=function(self) self:diffusealpha(0):linear(0.2):diffusealpha(1) end;
		Def.BitmapText {
			Font="_Large Bold";
			Text=Screen.String("Caution");
			OnCommand=function(self) self:diffuse(color("#FFD1D1")):diffusebottomedge(color("#FFFFFF")):strokecolor(color("#9A0808")):zoom(1) end;
		},
		Def.BitmapText {
			Font="_Medium";
			Text=Screen.String("CautionText");
			InitCommand=function(self) self:y(128) end;
			OnCommand=function(self) self:shadowlength(1):wrapwidthpixels(SCREEN_WIDTH/0.5) end;
		}
	},
--
	Def.Quad {
		InitCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(color("#000000")) end,
		OnCommand=function(self) self:decelerate(0.3):diffusealpha(0) end
	}
}