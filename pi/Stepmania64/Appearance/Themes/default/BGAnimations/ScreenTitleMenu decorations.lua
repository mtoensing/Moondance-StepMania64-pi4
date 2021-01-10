InitUserPrefs();

local t = Def.ActorFrame {}
-- Retro mode specific
if LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") == "4" then
	t[#t+1] = Def.ActorFrame {
		Def.Quad {
		InitCommand=function(self) 
			self:diffuse(color("#262D27")):zoomto(SCREEN_WIDTH,100)
			:vertalign(top):horizalign(left):xy(SCREEN_LEFT,SCREEN_TOP):fadebottom(0.1) end;
		};	
		Def.Quad {
		InitCommand=function(self) 
			self:diffuse(color("#262D27")):zoomto(SCREEN_WIDTH,50)
			:vertalign(bottom):horizalign(left):xy(SCREEN_LEFT,SCREEN_BOTTOM):fadetop(0.1) end;
		};
	};
end;

t[#t+1] = StandardDecorationFromFileOptional("Logo","Logo");
t[#t+1] = StandardDecorationFromFileOptional("VersionInfo","VersionInfo");
t[#t+1] = 	Def.BitmapText {
	Font="_Medium";
	InitCommand=function(self) self:xy(SCREEN_LEFT+16,SCREEN_TOP+66):horizalign(left):zoom(0.75):diffuse(color("#FFFFFF")):shadowlength(1) end;
	OnCommand=function(self)
		self:settext(Screen.String("CurrentGametype") .. ": " .. GAMESTATE:GetCurrentGame():GetName());
	end;
};

t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("NetworkStatus","NetworkStatus");
--t[#t+1] = StandardDecorationFromFileOptional("SystemDirection","SystemDirection");

t[#t+1] = StandardDecorationFromFileOptional("NumSongs","NumSongs") .. {
	SetCommand=function(self)
		local InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked = 0;
		if SONGMAN:GetRandomSong() then
			InstalledSongs, AdditionalSongs, InstalledCourses, AdditionalCourses, Groups, Unlocked =
				SONGMAN:GetNumSongs(),
				SONGMAN:GetNumAdditionalSongs(),
				SONGMAN:GetNumCourses(),
				SONGMAN:GetNumAdditionalCourses(),
				SONGMAN:GetNumSongGroups(),
				SONGMAN:GetNumUnlockedSongs();
		else
			return
		end

		self:settextf(THEME:GetString("ScreenTitleMenu","%i Songs (%i Groups), %i Courses"), InstalledSongs, Groups, InstalledCourses);
-- 		self:settextf("%i (+%i) Songs (%i Groups), %i (+%i) Courses", InstalledSongs, AdditionalSongs, Groups, InstalledCourses, AdditionalCourses);
	end;
};


return t
