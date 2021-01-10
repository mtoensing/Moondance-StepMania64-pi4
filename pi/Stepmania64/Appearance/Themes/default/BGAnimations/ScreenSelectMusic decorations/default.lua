local t = LoadFallbackB();
local baseQuadWidth= SCREEN_WIDTH <= 1280 and scale( SCREEN_WIDTH, 1151, 1280, 734, 862) or 862
local isUltraWide=SCREEN_WIDTH > 1280
local artistStripeHeight=48
local playerStripeHeight=56
local p2paneoffset=331
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

t[#t+1] = Def.Actor {
	InitCommand=function(self)
		setenv("musicWheelItemColor", ColorTable["wheelSongItem"] );
		setenv("sectionWheelItemColorA", ColorTable["wheelSectionItemA"] );
		setenv("sectionWheelItemColorB", ColorTable["wheelSectionItemB"] );
	end;
};


if GAMESTATE:IsCourseMode() == false then
if IsWidescreen() then
t[#t+1] = Def.ActorFrame {
-- Base quad
	Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):y(63):x( isUltraWide and SCREEN_CENTER_X-640 or SCREEN_LEFT):zoomto(baseQuadWidth,SCREEN_HEIGHT) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):decelerate(0.4):diffusealpha(0.2) end;
		OffCommand=function(self) self:sleep(0.36):decelerate(0.4):diffusealpha(0) end;
	};

-- BPM + Time Quad
	Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):x( isUltraWide and SCREEN_CENTER_X+22 or scale( SCREEN_WIDTH, 1151, 1280, SCREEN_CENTER_X-42, SCREEN_CENTER_X+22) ):y(63):zoomto(200,206) end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.32) end;
		OffCommand=function(self) self:sleep(0.36+.08):decelerate(0.4):diffusealpha(0) end
	};
};
end;
t[#t+1] = Def.ActorFrame {
	StandardDecorationFromFileOptional("SongTime","SongTime") .. {
	SetCommand=function(self)
		local curSelection = nil;
		local length = 0.0;
		local ColorTable = {
			Reset = { color("#FFFFFF"), color("#EEEEEE") },
			-- why do we have this
			Autogen = { Color("Blue"), color("#FFFFFF") },
			Long = { color("#29739b"), color("#FFFFFF") },
			Marathon = { color("#29419b"), color("#FFFFFF") },
		};
		self:diffuse( ColorTable["Reset"][1] ):diffusebottomedge( ColorTable["Reset"][2] )
		curSelection = GAMESTATE:GetCurrentSong();
		if curSelection then
			length = curSelection:MusicLengthSeconds();
			if curSelection:IsLong() then
				self:diffuse( ColorTable["Long"][1] )
				:diffusebottomedge( ColorTable["Long"][2] )
			elseif curSelection:IsMarathon() then
				self:diffuse( ColorTable["Marathon"][1] )
				:diffusebottomedge( ColorTable["Marathon"][2] )
			end
		end;
		self:settext( SecondsToMSS(length) );
		if length > 3600 then
			self:settext( SecondsToHHMMSS(length) );
		end
	end;
	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	};

	Def.BitmapText{
		Font="_Medium";
		Text=ToUpper(THEME:GetString("MusicWheel","LengthText")),
		InitCommand=function(self) self:horizalign(left):zoom(0.9)
		:x(IsWidescreen() and ( isUltraWide and SCREEN_CENTER_X+46 or scale( SCREEN_WIDTH, 1152, 1280, SCREEN_CENTER_X-20 , SCREEN_CENTER_X+46)) or SCREEN_CENTER_X-470):y(IsWidescreen() and SCREEN_CENTER_Y-270+30 or SCREEN_CENTER_Y-95+30)
		end;
		OnCommand=function(self) self:diffusealpha(0):decelerate(0.2):diffusealpha(1) end;
		OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
	};
	
	StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
	
	Def.BitmapText{
		Font="_Medium";
		Text=ToUpper("BPM"),
		InitCommand=function(self) self:horizalign(left):zoom(0.9)
		:x(IsWidescreen() and ( isUltraWide and SCREEN_CENTER_X+46 or scale( SCREEN_WIDTH, 1152, 1280, SCREEN_CENTER_X-20 , SCREEN_CENTER_X+46)) or SCREEN_CENTER_X-470+120):y(IsWidescreen() and SCREEN_CENTER_Y-205+30 or SCREEN_CENTER_Y-95+30) end;
		OnCommand=function(self) self:playcommand("Set"):diffusealpha(0):sleep(0.12):decelerate(0.2):diffusealpha(1) end;
		OffCommand=function(self) self:sleep(0.12):decelerate(0.2):diffusealpha(0) end;	
	};

	Def.ActorFrame {
	InitCommand=function(self) self:x(IsWidescreen() and ( isUltraWide and SCREEN_CENTER_X+46 or scale( SCREEN_WIDTH, 1152, 1280, SCREEN_CENTER_X-20 , SCREEN_CENTER_X+46)) or SCREEN_CENTER_X-470+160+90)
	:y(IsWidescreen() and SCREEN_CENTER_Y-140 or SCREEN_CENTER_Y-95) end;
	OnCommand=function(self) self:diffusealpha(0):sleep(0.12*2):decelerate(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:sleep(0.12*2):decelerate(0.2):diffusealpha(0) end;	
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self) self:horizalign(left):zoom(1.25):maxwidth(IsWidescreen() and 135 or 105):addy(2) end;
			OnCommand=function(self) self:playcommand("Set") end;
			CurrentSongChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
			CurrentCourseChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
			ChangedLanguageDisplayMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
			SetCommand=function(self)
			  local song = GAMESTATE:GetCurrentSong();
			   if song then
					self:settext( song:GetGenre() ~= "" and song:GetGenre() or "N/A" )
					self:diffusealpha( song:GetGenre() ~= "" and 1 or 0.5 )
				end
				self:playcommand("Refresh")
			end;
		};			
		Def.BitmapText {
			Font="_Medium";
			Text=ToUpper( THEME:GetString("MusicWheel","GenreText") ),
			InitCommand=function(self) self:horizalign(left):zoom(0.9):addy(30) end;
		};	
	};
};
	
-- Difficulty List Quad
if IsWidescreen() then
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:horizalign(left):vertalign(top):xy( isUltraWide and SCREEN_CENTER_X+22 or scale( SCREEN_WIDTH, 1151, 1280, SCREEN_CENTER_X-42, SCREEN_CENTER_X+22) ,63+206):zoomto(200,408) end;
	OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):decelerate(0.4):diffusealpha(0.5) end;
	OffCommand=function(self) self:sleep(0.36+.12):decelerate(0.4):diffusealpha(0) end;
	}
else
t[#t+1] = Def.Quad {
	InitCommand=function(self) self:horizalign(left):vertalign(top):xy(SCREEN_CENTER_X-81,64-4):zoomto(143,257) end;
	OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0):decelerate(0.4):diffusealpha(0.5) end;
	OffCommand=function(self) self:sleep(0.36+.12):decelerate(0.4):diffusealpha(0) end;
	}
end;

t[#t+1] = StandardDecorationFromFileOptional("DifficultyList","DifficultyList");

-- CDTitle
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:draworder(49):x( isUltraWide and SCREEN_CENTER_X-595 or SCREEN_LEFT+45):y(IsWidescreen() and ( isUltraWide and SCREEN_CENTER_Y-130 or scale( SCREEN_WIDTH, 1152, 1280, SCREEN_CENTER_Y-120, SCREEN_CENTER_Y-130)) or SCREEN_CENTER_Y-200):addx(-SCREEN_WIDTH/0.75):decelerate(0.8):addx(SCREEN_WIDTH/0.75) end;
		OffCommand=function(self) self:decelerate(0.75):addx(-SCREEN_WIDTH/0.75) end;
		Def.Sprite {
			Name="CDTitle";
			OnCommand=function(self) self:draworder(49):diffusealpha(1):zoom(0):bounceend(0.35):zoom(0.75):playcommand("Set") end;
			BackCullCommand=function(self) self:diffuse(color("0.5,0.5,0.5,1")) end;
			CurrentSongChangedMessageCommand=function(s) s:playcommand("Set") end,
			SetCommand=function(s)
				s:visible(false)
				if GAMESTATE:GetCurrentSong() then
					local song = GAMESTATE:GetCurrentSong()
					if song then
						if song:HasCDTitle() then
							s:visible(true)
							s:Load(song:GetCDTitlePath())
						end
					end

					local height = s:GetHeight()
					local width = s:GetWidth()

					if height >= 70 and width >= 70 then
						if height >= width then
							s:zoom(70/height)
						else
							s:zoom(70/width)
						end
					elseif height >= 70 then
						s:zoom(70/height)
					elseif width >= 70 then
						s:zoom(70/width)
					else 
						s:zoom(1)
					end
				end
			end,
		};	
	};
	
----- /
-- Long?
----- /	
t[#t+1] = LoadActor("longIndicator") .. {
	InitCommand=function(self)
		self:horizalign(center):vertalign(middle):x(SCREEN_CENTER_X-90):y(SCREEN_CENTER_Y-268):draworder(50):diffusealpha(0)
		if SCREEN_WIDTH < 1280 then
			self:addx( scale( SCREEN_WIDTH, 960, 1151, -75, -45 ) ):addy(-8):zoom(0.75)
		end;
	end;
}

----- /
-- Player 1 info pane
----- /	
t[#t+1] = LoadActor("panels");

----- /
-- Artist Text
----- /	
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self) self:horizalign(left):x( isUltraWide and SCREEN_CENTER_X-630 or SCREEN_LEFT+10):y(IsWidescreen() and SCREEN_CENTER_Y-68 or SCREEN_CENTER_Y-150) end;
	OffCommand=function(self) self:sleep(0.24):decelerate(0.4):diffusealpha(0) end;
	Def.BitmapText {
		Font="_Bold",
		Text=ToUpper(THEME:GetString("MusicWheel","ArtistText") .. ":"),
		InitCommand=function(self) self:horizalign(left):maxwidth(78):zoom(1.25) end;
	};

	Def.BitmapText {
		Font="_Medium";
		InitCommand=function(self) self:horizalign(left):addx(106):zoom(1):maxwidth(IsWidescreen() and scale( SCREEN_WIDTH, 1151, 1280, 410, 520) or 266):queuecommand("Set") end;
		OnCommand=function(self) self:playcommand("Set") end;
		CurrentSongChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
		ChangedLanguageDisplayMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
		DisplayLanguageChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage")
			local text = ""
			if song then
				text = nativeTitle and song:GetDisplayArtist() or song:GetTranslitArtist()
				self:settext( text, song:GetTranslitArtist() )
			end
			self:playcommand("Refresh")
		end;
	};
};
end;
t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");


----- /
-- Options prompt
----- /
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self) self:visible(false) end;
	ShowPressStartForOptionsCommand=function(self) self:visible(true):diffusealpha(0):vertalign(bottom):y(SCREEN_BOTTOM+120):decelerate(0.25):addy(-118):diffusealpha(1) end;		
	ShowEnteringOptionsCommand=function(self) self:sleep(0.4):decelerate(0.2):addy(118):diffusealpha(0) end;
	HidePressStartForOptionsCommand=function(self) self:sleep(0.4):decelerate(0.2):addy(118):diffusealpha(0) end;
	
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