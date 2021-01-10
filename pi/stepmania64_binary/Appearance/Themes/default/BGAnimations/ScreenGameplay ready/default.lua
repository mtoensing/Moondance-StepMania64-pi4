if LoadModule("Config.Load.lua")("GameplayReadyPrompt","Save/OutFoxPrefs.ini") then
	if IsNetSMOnline() then
		-- don't show "Ready" online; it will obscure the immediately-starting steps.
		return Def.ActorFrame{}
	end
	local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
	return Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self) self:vertalign(middle):zoomto(SCREEN_WIDTH,0):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse( ColorTable["promptBG"] ):draworder(105) end,
			StartTransitioningCommand=function(self)
				self:decelerate(0.3):zoomtoheight(120):sleep(1.6):diffusealpha(0)
			end;
		};
		Def.Sprite {
			Texture="ready",
			InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105) end,
			StartTransitioningCommand=function(self)
				self:diffusealpha(0):sleep(0.3):linear(0.13):diffusealpha(1):sleep(1.6-0.13):diffusealpha(0)
			end;
		};
	};
else
	return Def.ActorFrame{}
end;