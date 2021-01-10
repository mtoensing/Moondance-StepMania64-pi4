local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
return Def.ActorFrame {
	LoadModule("Options.SmartTiming.lua"),
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
		OnCommand=function(self) self:diffuse(color("#000000")):diffusebottomedge( ColorTable["serviceBG"] )  end
	},
	LoadActor (GetSongBackground()) .. {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
		OnCommand=function(self)
			self:diffusealpha(0.1)
			GAMESTATE:UpdateDiscordGameMode(GAMESTATE:GetCurrentGame():GetName())
			GAMESTATE:UpdateDiscordScreenInfo("Editing a Song","",1)
		end;
	};
};