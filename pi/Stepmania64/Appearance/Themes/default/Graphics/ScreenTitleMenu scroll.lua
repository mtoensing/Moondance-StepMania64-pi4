local gc = Var("GameCommand");
local item_width = 260;
local item_height = 36;
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )

return Def.ActorFrame {
	OnCommand=function(self) self:diffusealpha(0):decelerate(0.3):diffusealpha(1) end;
	OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
	Def.Quad {
	InitCommand=function(self) self:zoomto(item_width,item_height):diffuse(color("#001232")):diffusealpha(0.75) end;
	},
-- Fade BG
	Def.ActorFrame {
		GainFocusCommand=function(self) self:stoptweening():linear(0.08):diffusealpha(1) end;
		LoseFocusCommand=function(self) self:stoptweening():linear(0.08):diffusealpha(0.5) end;
			Def.Quad {InitCommand=function(self) self:fadeleft(1):zoomto(item_width/2,item_height):horizalign(right):x(item_width/2):diffuse( ColorTable["titlemenuBlockGlow"] ) end,},
			Def.Quad {InitCommand=function(self) self:faderight(1):zoomto(item_width/2,item_height):horizalign(left):x(-item_width/2):diffuse( ColorTable["titlemenuBlockGlow"] ) end,},
	};
-- Stripes
	Def.ActorFrame {
		GainFocusCommand=function(self) self:stoptweening():linear(0.16):diffusealpha(1):zoomx(1) end;
		LoseFocusCommand=function(self) self:stoptweening():linear(0.16):diffusealpha(0):zoomx(0) end;
			Def.Quad {InitCommand=function(self) self:zoomto(item_width,4):vertalign(top):y(-item_height/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) end,},	
			Def.Quad {InitCommand=function(self) self:zoomto(item_width,4):vertalign(bottom):y(item_height/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) end,},	
	};	
	Def.BitmapText {
		Font="_SemiBold";
		Text=THEME:GetString("ScreenTitleMenu",gc:GetText());
		InitCommand=function(self) self:maxwidth(320):skewx(-0.15) end;
		GainFocusCommand=function(self) self:stoptweening():linear(0.08):diffuse( ColorTable["menuTextGainFocus"] ):diffusealpha(1) end;
		LoseFocusCommand=function(self) self:stoptweening():linear(0.08):diffuse( ColorTable["menuTextLoseFocus"] ):diffusealpha(0.3) end;
	};
	Def.Quad {
		InitCommand=function(self) self:zoomto(item_width,item_height):diffuse(color("#666666")) end;
		DisabledCommand=function(self) self:diffuse(color("0,0,0,0.6")) end;
		EnabledCommand=function(self) self:diffuse(color("1,1,1,0")) end;
	};	
};