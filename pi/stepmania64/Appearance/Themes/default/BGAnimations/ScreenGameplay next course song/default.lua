local t = Def.ActorFrame{};

if not GAMESTATE:IsCourseMode() then return t; end;

t[#t+1] = Def.Sprite {
	InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end,
	BeforeLoadingNextCourseSongMessageCommand=function(self) self:LoadFromSongBackground( SCREENMAN:GetTopScreen():GetNextCourseSong() ) end,
	ChangeCourseSongInMessageCommand=function(self) self:scale_or_crop_background() end,
	StartCommand=function(self) self:diffusealpha(0):decelerate(0.6):diffusealpha(1) end,
	FinishCommand=function(self) self:linear(0.3):diffusealpha(0) end
}

return t;
