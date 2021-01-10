if LoadModule("Config.Load.lua")("GameplayReadyPrompt","Save/OutFoxPrefs.ini") then
if IsNetSMOnline() then
	-- don't show "Ready" online; it will obscure the immediately-starting steps.
	return Def.ActorFrame{}
end

return Def.ActorFrame {
	Def.Quad {
		InitCommand=function(self) self:zoomto(SCREEN_WIDTH,120):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse(color("#246b3a")):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:diffuse(color("#41ba67")):decelerate(0.5):diffuse(color("#246b3a")):sleep(0.2):linear(0.12):zoomtoheight(0)
		end;
	};
	Def.Sprite {
		Texture="_wave",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:diffusealpha(1):linear(0.3):diffusealpha(0):zoomx(1.4)
		end;
	};	
	Def.Sprite {
		Texture="go",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:diffusealpha(1):zoomx(1.2):decelerate(0.5):zoomx(1):linear(0.2):diffusealpha(0)
		end;
	};
};
else
	return Def.ActorFrame{}
end;