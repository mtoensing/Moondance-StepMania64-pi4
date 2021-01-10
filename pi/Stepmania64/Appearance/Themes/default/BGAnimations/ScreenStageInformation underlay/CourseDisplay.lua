if not GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end; -- short circuit
local titleFadeIn = 1
local titleAnimLength = 1
local titleWait = 3
local course = GAMESTATE:GetCurrentCourse()

local t = Def.ActorFrame{
	-- background
	Def.Sprite{
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
		BeginCommand=function(self)
			if course:GetBackgroundPath() then
				self:Load( course:GetBackgroundPath() )
			else
				-- default to the BG of the first song in the course
				self:LoadFromCurrentSongBackground()
			end
		end;
		OnCommand=function(self)
			self:scale_or_crop_background()
			self:diffusealpha(0):addx(-20):sleep(titleFadeIn):decelerate(titleAnimLength):diffusealpha(0.18):addx(20)
			:sleep(titleWait):decelerate(0.5):diffusealpha(0)
		end;	
		};
	-- alternate background
	Def.Sprite{
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
		BeginCommand=function(self)
			self:LoadFromCurrentSongBackground():scale_or_crop_background():diffusealpha(0)
		end;
		OnCommand=function(self) self:playcommand("Show") end;
		ShowCommand=function(self)
			if course:HasBackground() then
				self:diffusealpha(0):addx(-20):sleep(titleFadeIn):decelerate(titleAnimLength):diffusealpha(0.18):addx(20)
				:sleep(titleWait):decelerate(0.5):diffusealpha(0)
			end
		end;
	};
};

return t;