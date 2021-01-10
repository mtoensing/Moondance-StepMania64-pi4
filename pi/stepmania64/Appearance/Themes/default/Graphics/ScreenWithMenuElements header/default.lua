local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

return Def.ActorFrame {

-- Base bar
Def.ActorFrame {
	InitCommand=function(self)
		self:vertalign(top)
	end;
	OnCommand=function(self)
		self:addy(-104):decelerate(0.3):addy(104)
	end,
	OffCommand=function(self)
		self:sleep(0.175):decelerate(0.3):addy(-105)
	end;
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(top):horizalign(left):zoomto(SCREEN_WIDTH,64):x(0)
		end;
		OnCommand=function(self)
			self:diffuse( ColorTable["swmeHF"] )
		end,
	},
	-- Stripe
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(top):horizalign(left):zoomto(SCREEN_WIDTH,2):y(62):x(0)
		end;
		OnCommand=function(self)
			self:diffuse( ColorTable["headerStripeA"] ):diffuserightedge( ColorTable["headerStripeB"] ):diffusealpha(0.75)
		end;
	};
};

-- Text
Def.BitmapText {
	Font="_Large Bold",
	Name="HeaderTitle",
	Text=ToUpper(Screen.String("HeaderText")),
	InitCommand=function(self)
		self:xy(SCREEN_LEFT+25,32):horizalign(left):zoom(0.8)
		:diffuse( ColorTable["headerTextColor"] ):diffusebottomedge( ColorTable["headerTextGradient"] ):skewx(-0.15)
	end;
	OnCommand=function(self)
		self:diffusealpha(0):sleep(0.3):smooth(0.2):diffusealpha(1)
		if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetName() == "ScreenSelectMusic" then
			self:maxwidth( WideScale(10,240) )
		end
	end;
	UpdateScreenHeaderMessageCommand=function(self,param)
		self:settext(param.Header)
	end;
	OffCommand=function(self) self:decelerate(0.175):diffusealpha(0) end;
};

};