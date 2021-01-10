local t = LoadFallbackB();
local baseQuadWidth=614
local artistStripeHeight=48
local playerStripeHeight=56
local p2paneoffset=331
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

t[#t+1] = Def.Actor {
	InitCommand=function(self)
		setenv("musicWheelItemColor", ColorTable["wheelSongItem"] );
		setenv("sectionWheelItemColorA", ColorTable["wheelSectionItemA"] );
		setenv("sectionWheelItemColorB", ColorTable["wheelSectionItemB"] );
		setenv("CurrentlyInSong",false);
	end;
};

if IsWidescreen() == true then
-- Base quad
t[#t+1] = Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):y(63):x(SCREEN_LEFT):zoomto(862,baseQuadWidth) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):decelerate(0.4):diffusealpha(0.2) end;
		OffCommand=function(self) self:sleep(0.36):decelerate(0.4):diffusealpha(0) end;
	}

-- BPM + Time Quad
t[#t+1] = Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):x(SCREEN_CENTER_X+22):y(63):zoomto(200,206) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.32) end;
		OffCommand=function(self) self:sleep(0.36+.08):decelerate(0.4):diffusealpha(0) end
	}
	
-- Course list BG
	t[#t+1] = Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):x(SCREEN_LEFT):y(SCREEN_TOP+269):zoomto(862,229+46) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.4) end;
		OffCommand=function(self) self:sleep(0.36+.08):decelerate(0.4):diffusealpha(0) end
	}
else
	t[#t+1] = Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):xy(SCREEN_CENTER_X-81,64-4):zoomto(143,127) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):decelerate(0.4):diffusealpha(0.2) end;
		OffCommand=function(self) self:sleep(0.36+.12):decelerate(0.4):diffusealpha(0) end;
	}
end;
	

----- /
-- What we're here for
----- /	
t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");

----- /	
	
t[#t+1] = StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = nil;
		local length = 0.0;
		if GAMESTATE:IsCourseMode() then
			curSelection = GAMESTATE:GetCurrentCourse();
			self:playcommand("Reset");
			if curSelection then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
				if trail then
					length = TrailUtil.GetTotalSeconds(trail);
				else
					length = 0.0;
				end;
			else
				length = 0.0;
			end;
		else
			curSelection = GAMESTATE:GetCurrentSong();
			self:playcommand("Reset");
			if curSelection then
				length = curSelection:MusicLengthSeconds();
				if curSelection:IsLong() then
					self:playcommand("Long");
				elseif curSelection:IsMarathon() then
					self:playcommand("Marathon");
				else
					self:playcommand("Reset");
				end
			else
				length = 0.0;
				self:playcommand("Reset");
			end;
		end;
		self:settext( SecondsToMSS(length) );
	end;
	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
};

t[#t+1] = Def.BitmapText {
	Font="_Medium";
	Text=ToUpper(THEME:GetString("MusicWheel","LengthText")),
	InitCommand=function(self) self:horizalign(left):zoom(0.8)
	:x(IsWidescreen() and SCREEN_CENTER_X+46 or SCREEN_CENTER_X-470):y(IsWidescreen() and SCREEN_CENTER_Y-270+30 or SCREEN_CENTER_Y-140+30)
	end;
	OnCommand=function(self) self:diffusealpha(0):decelerate(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
	};
	
t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
	
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(IsWidescreen() and SCREEN_CENTER_X+46 or SCREEN_CENTER_X-470+120)
	:y(IsWidescreen() and SCREEN_CENTER_Y-200+30 or SCREEN_CENTER_Y-110) end;
	OnCommand=function(self) self:diffusealpha(0):sleep(0.12):decelerate(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:sleep(0.12):decelerate(0.2):diffusealpha(0) end;	
		Def.BitmapText {
			Font="_SemiBold";
			InitCommand=function(self) self:horizalign(left):zoom(1):y(-34) end;
			OnCommand=function(self) self:playcommand("Set") end;
			CurrentCourseChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
			ChangedLanguageDisplayMessageCommand=function(self) self:finishtweening():playcommand("Set") end;			
			SetCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse(); 
               if course then
                    self:settext(course:GetEstimatedNumStages()); 
                    self:queuecommand("Refresh");
				else
					self:settext("");
					self:queuecommand("Refresh"); 	
               end			
			end;
		};
		Def.BitmapText {
			Font="_Medium";
			InitCommand=function(self) self:horizalign(left):zoom(0.8) end;
			OnCommand=function(self) self:playcommand("Set") end;
			SetCommand=function(self)
				self:settext(THEME:GetString("ScreenSelectCourse","SongCount"));
			end;
		};
	};	
	
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:x(IsWidescreen() and SCREEN_CENTER_X+46 or SCREEN_CENTER_X-470+160+90)
	:y(IsWidescreen() and SCREEN_CENTER_Y-140 or SCREEN_CENTER_Y-140) end;
	OnCommand=function(self) self:diffusealpha(0):sleep(0.12*2):decelerate(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:sleep(0.12*2):decelerate(0.2):diffusealpha(0) end;
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self) self:horizalign(left):zoom(1):maxwidth(164):addy(2) end;
				OnCommand=function(self) self:playcommand("Set") end;
				CurrentCourseChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
				ChangedLanguageDisplayMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
				SetCommand=function(self)
				  local course = GAMESTATE:GetCurrentCourse();
					if course then
						self:settext( ToUpper(CourseTypeToLocalizedString(course:GetCourseType())) ); 
						self:queuecommand("Refresh");
					else
						self:settext("");
						self:queuecommand("Refresh"); 	
					end 
				end;
		};			
		Def.BitmapText {
			Font="_Medium";
			Text=ToUpper(THEME:GetString("ScreenSelectCourse","Type")),
			InitCommand=function(self) self:horizalign(left):zoom(0.8):addy(30) end;
		};	
	};

----- /
-- Info pane loop
----- /	
t[#t+1] = LoadActor("panels");

----- /
-- Options prompt
----- /
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self) self:visible(false) end;
	ShowPressStartForOptionsCommand=function(self) self:visible(true):diffusealpha(0):vertalign(bottom):y(SCREEN_BOTTOM+120):decelerate(0.3):addy(-120):diffusealpha(1) end;		
	ShowEnteringOptionsCommand=function(self) self:sleep(0.4):decelerate(0.3):addy(120):diffusealpha(0) end;
	HidePressStartForOptionsCommand=function(self) self:sleep(0.4):decelerate(0.3):addy(120):diffusealpha(0) end;
	
	Def.Quad{
		InitCommand=function(self) self:vertalign(bottom):zoomto(SCREEN_WIDTH,120):x(SCREEN_CENTER_X):diffuse(ColorTable["promptBG"]):diffusealpha(0) end;
		ShowPressStartForOptionsCommand=function(self) self:diffusealpha(1) end;
	};
	StandardDecorationFromFileOptional("SongOptions","SongOptionsText") .. {
		ShowPressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsShowCommand");
		ShowEnteringOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsEnterCommand");
		HidePressStartForOptionsCommand=THEME:GetMetric(Var "LoadingScreen","SongOptionsHideCommand");
	};
};


return t;