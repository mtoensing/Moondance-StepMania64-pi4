local timer_seconds = THEME:GetMetric(Var "LoadingScreen","TimerSeconds");

return Def.ActorFrame {
	InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
	-- Fade
	Def.Quad {
		InitCommand=function(self) self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) 
			self:diffuse(Color.Black):diffusealpha(0):linear(0.5):diffusealpha(0.25):sleep(timer_seconds/2):linear(timer_seconds/2-0.5):diffusealpha(0.8)
		end;
	},
	
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(Color.Black) end;
	},	
	
	LoadActor("_sound") .. {
		OnCommand=function(self) self:queuecommand("Sound") end;
		SoundCommand=function(self) self:play() end;
	};	
	
	LoadActor(THEME:GetPathG("ScreenGameOver","gameover"))..{
		OnCommand=function(self) self:zoomx(1.1):diffusealpha(0):sleep(1):decelerate(0.6):diffusealpha(1):zoomx(1) end;
	},
	
	Def.BitmapText {
		Font="_Medium";
		Text=ScreenString("Play again soon!");
		InitCommand=function(self) self:y(120) end;
		OnCommand=function(self) self:diffusealpha(0):sleep(3):linear(0.3):diffusealpha(1) end;
	},
	
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(Color.Black):linear(1):diffusealpha(0) end;
	},	
}
