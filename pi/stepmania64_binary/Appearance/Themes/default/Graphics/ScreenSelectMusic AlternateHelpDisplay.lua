local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(512,128):diffuse( ColorTable["SSMHelpPopup"] ):shadowlength(1)
		end;		
	};
	
	Def.BitmapText {
		Font="_Condensed Semibold";	
		InitCommand=function(self) self:horizalign(center):maxwidth(400):xy(0,-30) end;
		OnCommand=function(self) 
			self:settext(THEME:GetString("ScreenSelectMusic","ChangeDifficulty"))
		end;
	};	
	Def.BitmapText {
		Font="_Condensed Semibold";	
		InitCommand=function(self) self:horizalign(center):maxwidth(400):xy(0,30) end;
		OnCommand=function(self) 
			self:settext(THEME:GetString("ScreenSelectMusic","ChangeSort"))
		end;
	};
};