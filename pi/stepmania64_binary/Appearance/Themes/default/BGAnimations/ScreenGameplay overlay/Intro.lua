local playMode = GAMESTATE:GetPlayMode()
local sStage = ""
sStage = GAMESTATE:GetCurrentStage()

if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
  sStage = playMode;
end;
local curStage = GAMESTATE:GetCurrentStage();

local titleFadeIn = 0.3
local titleAnimLength = 1
local titleWait = 2
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage")

local t = Def.ActorFrame {};

    t[#t+1] = Def.Quad {
        InitCommand=function(self)
            self:diffuse(color("#000000")):vertalign(bottom):zoomto(SCREEN_WIDTH,240):fadetop(1):xy(SCREEN_CENTER_X,SCREEN_BOTTOM)
        end,
        OnCommand=function(self)
            self:diffusealpha(0):sleep(titleFadeIn)
            :decelerate(titleAnimLength):diffusealpha(1)
            :sleep(titleWait):decelerate(0.5):diffusealpha(0)
        end
    };

	-- Difficulty and author credits
	for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
	local credit_position = string.find(pn, "P1") and SCREEN_LEFT+20 or SCREEN_RIGHT-20;
	local credit_alignment = string.find(pn, "P1") and left or right;
	local credit_x_start = string.find(pn, "P1") and -20 or 20;
	local credit_x_add = string.find(pn, "P1") and 1 or -1;
	local profileLoc =  CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini"
	local peak,npst,NMeasure,mcount = LoadModule("Chart.GetNPS.lua")( GAMESTATE:GetCurrentSteps(pn) )
	GAMESTATE:Env()["ChartData"..pn] = {peak,npst,NMeasure,mcount}
	
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:xy(credit_position,SCREEN_BOTTOM-130) end;
		OnCommand=function(self)
			self:diffusealpha(0):addx(credit_x_start):sleep(titleFadeIn)
            :decelerate(titleAnimLength):diffusealpha(1):addx(20*credit_x_add)
			:sleep(titleWait):decelerate(0.5):diffusealpha(0) 
		end;
			Def.Sprite {
				InitCommand=function(self) self:horizalign(credit_alignment):y(10) end;
				Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"];
				OnCommand=function(self)
					self:zoomto(46,46)
				end;
			};
			Def.BitmapText {
				Font="_Bold";
				InitCommand=function(self) self:horizalign(credit_alignment):addx(56*credit_x_add) end;
				OnCommand=function(self) self:playcommand("Set") end;
				SetCommand=function(self)
				local steps_data = GAMESTATE:GetCurrentSteps(pn)
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse();
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
				else
					SongOrCourse = GAMESTATE:GetCurrentSong();
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
				end;
				if GAMESTATE:GetCurrentSong() then 
					if steps_data ~= nil then
						local st = steps_data:GetStepsType();
						local diff = steps_data:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
							if steps_data:IsAnEdit() then
								self:settext(steps_data:GetChartName() .. "  " .. steps_data:GetMeter());
							else
								self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)) .. "  " .. steps_data:GetMeter());
							end;
						self:diffuse(ColorLightTone(CustomDifficultyToColor(cd)));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			 end;
			};
			Def.BitmapText {
				Font="_Condensed MedBold";
				InitCommand=function(self) 
					self:y(24):horizalign(credit_alignment):zoom(1):addx(56*credit_x_add)
					:diffuse(color("#FFFFFF")):strokecolor(color("#000000")):maxwidth(300) end;
				OnCommand=function(self) 
				self:playcommand("Set") end;
				SetCommand=function(self)
				local steps_data = GAMESTATE:GetCurrentSteps(pn)
				if GAMESTATE:GetCurrentSong() then
					if steps_data ~= nil then
						self:settext(steps_data:GetAuthorCredit())
					end
				else
					self:settext("")
				end
			 end
			};
			Def.Quad {
				InitCommand=function(self) 
					self:y(49):horizalign(credit_alignment):diffuse(PlayerColor(pn)):zoomto(200,3)
					if pn == PLAYER_1 then self:faderight(0.6) else self:fadeleft(0.6) end;
				end;
			};
		};
	end;

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_RIGHT-16,SCREEN_BOTTOM-60)
	end;
	OnCommand=function(self)
		self:diffusealpha(0):addx(20)
		:sleep(titleFadeIn):decelerate(titleAnimLength):diffusealpha(1):addx(-20)
        :sleep(titleWait):decelerate(0.5):diffusealpha(0)
	end;
	Def.BitmapText {
		Font="SongSubTitle font";
		InitCommand=function(self)
			self:diffuse(color("#FFFFFF")):zoom(1.25):maxwidth(SCREEN_WIDTH*0.5)
			self:horizalign(right)
		end;
		OnCommand=function(self)
			if not GAMESTATE:IsCourseMode() then
				local text = nativeTitle and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitMainTitle()
				self:settext( text, GAMESTATE:GetCurrentSong():GetTranslitMainTitle() )
				if GAMESTATE:GetCurrentSong():GetDisplaySubTitle() ~= "" then
					self:addy(-22)
				end;
			else
				self:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle())
			end;
		end;
	};
	Def.BitmapText {
		Font="SongSubTitle font",
		InitCommand=function(self)
			self:diffuse(color("#FFFFFF")):zoom(0.75):maxwidth(SCREEN_WIDTH*0.5):y(2)
			self:horizalign(right)
		end;
		OnCommand=function(self)
			if not GAMESTATE:IsCourseMode() then
				local text = nativeTitle and GAMESTATE:GetCurrentSong():GetDisplaySubTitle() or GAMESTATE:GetCurrentSong():GetTranslitSubTitle()
				self:settext( text, GAMESTATE:GetCurrentSong():GetTranslitSubTitle() )
			end;
		end;
	};
	Def.BitmapText {
		Font="SongTitle font";
		InitCommand=function(self)
			self:diffuse(color("#FFFFFF")):zoom(0.8):maxwidth((SCREEN_WIDTH*0.5)/0.8):y(26)
			self:horizalign(right)
		end;
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:settext(ToEnumShortString( GAMESTATE:GetCurrentCourse():GetCourseType() ))
			else
				local text = nativeTitle and GAMESTATE:GetCurrentSong():GetDisplayArtist() or GAMESTATE:GetCurrentSong():GetTranslitArtist()
				self:settext( text, GAMESTATE:GetCurrentSong():GetTranslitArtist() )
			end;
		end;
	};
};

-- Stage graphic
local stage_num_actor= THEME:GetPathG("ScreenStageInformation", "Stage " .. ToEnumShortString(sStage), true)
if stage_num_actor ~= "" and FILEMAN:DoesFileExist(stage_num_actor) then
	stage_num_actor= LoadActor(stage_num_actor)
else
	-- Midiman:  We need a "Stage Next" actor or something for stages after
	-- the 6th. -Kyz
	stage_num_actor= Def.BitmapText{
		Font= "_SemiBold";
		Text= thified_curstage_index(false) .. " Stage",
		InitCommand= function(self)
			self:zoom(1.5)
			self:diffuse(StageToColor(curStage));
			self:diffuserightedge(ColorLightTone(StageToColor(curStage)));
		end
	}
end

t[#t+1] = stage_num_actor .. {
	InitCommand=function(self) 
		self:horizalign(left):vertalign(bottom)
		:x(SCREEN_LEFT+10):y(SCREEN_BOTTOM-10)
		:zoom(1):diffusealpha(1) 
	end;
	OnCommand=function(self) 
		self:diffusealpha(0):addx(-20):sleep(titleFadeIn):decelerate(titleAnimLength):diffusealpha(1):addx(20)
        :sleep(titleWait):decelerate(0.5):diffusealpha(0)
	end;
};

return t;