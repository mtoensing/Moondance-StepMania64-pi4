local playMode = GAMESTATE:GetPlayMode()
local sStage = ""
sStage = GAMESTATE:GetCurrentStage()

if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
  sStage = playMode;
end;
local curStage = GAMESTATE:GetCurrentStage();

local titleFadeIn = 1
local titleAnimLength = 1
local titleWait = 3
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage")

local t = Def.ActorFrame {};

-- Don't play the whole sequence if we're restarting a song from the pause menu.
if getenv("CurrentlyInSong") == false then
	-- BG animation
	t[#t+1] = Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,1):vertalign(top):x(SCREEN_CENTER_X):y(SCREEN_TOP)
			self:diffuse(Color.Black)
		end;
		OnCommand=function(self)
			self:decelerate(0.4):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
		end;
	  };
	-- Scanline
	t[#t+1] = Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,5):vertalign(top):x(SCREEN_CENTER_X):y(SCREEN_TOP)
			self:diffuse(ColorLightTone(StageToColor(curStage)))
		end;
		OnCommand=function(self)
			self:decelerate(0.4):y(SCREEN_BOTTOM)
		end;
	  };

else

	t[#t+1] = Def.Quad {
		InitCommand=function(self)
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse(color("#000000"))
		end;
		OnCommand=function(self)
			self:linear(0.1)
		end;
	};
end

return t;