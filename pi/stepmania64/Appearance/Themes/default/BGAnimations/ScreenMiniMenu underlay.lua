return Def.ActorFrame {
	OnCommand= function(self) self:queuecommand("Recenter") end,
	RecenterCommand= function(self) SCREENMAN:GetTopScreen():xy(0, 0) end,
	Def.Quad{
		InitCommand=function(self) self:scaletocover(-SCREEN_WIDTH*2,SCREEN_TOP,SCREEN_WIDTH*2,SCREEN_BOTTOM):diffuse(color("0,0,0,0.5")) end,
		OnCommand=function(self) self:diffusealpha(0):linear(0.135):diffusealpha(0.5) end,
		OffCommand=function(self) self:linear(0.135):diffusealpha(0) end,
	};
};