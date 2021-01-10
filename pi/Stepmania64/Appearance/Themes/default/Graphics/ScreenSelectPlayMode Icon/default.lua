local gc = Var("GameCommand");
local string_name = gc:GetText()
local string_expl = THEME:GetString(Var "LoadingScreen", gc:GetName().."Explanation")
local item_width = 320;
local item_height = 98;
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )

return Def.ActorFrame {
	Def.ActorFrame {
		OnCommand=function(self) self:diffusealpha(0):decelerate(0.15):diffusealpha(1) end;
		OffCommand=function(self) self:decelerate(0.15):diffusealpha(0) end;
		Def.Quad {
		InitCommand=function(self) self:zoomto(item_width,item_height):diffuse( ColorTable["menuBlockBase"] ):diffusealpha(0.6) end;
		},
	-- Fade BG
		Def.ActorFrame {
			GainFocusCommand=function(self) self:stoptweening():linear(0.08):diffusealpha(1) end;
			LoseFocusCommand=function(self) self:stoptweening():linear(0.08):diffusealpha(0.5) end;
			Def.Quad {InitCommand=function(self) self:fadeleft(1):zoomto(item_width/2,item_height):horizalign(right):x(item_width/2):diffuse( ColorTable["menuBlockGlow"] ) end,},
			Def.Quad {InitCommand=function(self) self:faderight(1):zoomto(item_width/2,item_height):horizalign(left):x(-item_width/2):diffuse( ColorTable["menuBlockGlow"] ) end,},
		};
	-- Stripes
		Def.ActorFrame {
			GainFocusCommand=function(self) self:stoptweening():linear(0.16):diffusealpha(0.75):zoomx(1) end;
			LoseFocusCommand=function(self) self:stoptweening():linear(0.16):diffusealpha(0):zoomx(0) end;
			Def.Quad {InitCommand=function(self) self:zoomto(item_width,8):vertalign(top):y(-item_height/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) end,},	
			Def.Quad {InitCommand=function(self) self:zoomto(item_width,8):vertalign(bottom):y(item_height/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) end,},
		};
		Def.BitmapText {
			Font="_Large Bold";
			Text=ToUpper(string_name);
			InitCommand=function(self) self:maxwidth(232):zoom(1):skewx(-0.15) end;
			GainFocusCommand=function(self) self:stoptweening():linear(0.08):diffuse( ColorTable["menuTextGainFocus"] ):diffusealpha(1) end;
			LoseFocusCommand=function(self) self:stoptweening():linear(0.08):diffuse( ColorTable["menuTextLoseFocus"] ):diffusealpha(0.3) end;
		};
		Def.Quad {
			InitCommand=function(self) self:zoomto(item_width,item_height):diffuse(color("#666666")) end;
			DisabledCommand=function(self) self:diffuse(color("0,0,0,0.6")) end;
			EnabledCommand=function(self) self:diffuse(color("1,1,1,0")) end;
		};
	};

};