--If a Command has "NOTESKIN:GetMetricA" in it, that means it gets the command from the metrics.ini, else use cmd(); to define command.
--If you dont know how "NOTESKIN:GetMetricA" works here is an explanation.
--NOTESKIN:GetMetricA("The [Group] in the metrics.ini", "The actual Command to fallback on in the metrics.ini");

--The NOTESKIN:LoadActor() just tells us the name of the image the Actor redirects on.
--Oh and if you wonder about the "Button" in the "NOTESKIN:LoadActor( )" it means that it will check for that direction.
--So you dont have to do "Down" or "Up" or "Left" etc for every direction which will save space ;)
local cw5 = JudgmentLineToColor("JudgmentLine_W5");
local cw4 = JudgmentLineToColor("JudgmentLine_W4");
local cw3 = JudgmentLineToColor("JudgmentLine_W3");
local cw2 = JudgmentLineToColor("JudgmentLine_W2");
local cw1 = JudgmentLineToColor("JudgmentLine_W1");
local cwpro5 = JudgmentLineToColor("JudgmentLine_ProW5");
local cwpro4 = JudgmentLineToColor("JudgmentLine_ProW4");
local cwpro3 = JudgmentLineToColor("JudgmentLine_ProW3");
local cwpro2 = JudgmentLineToColor("JudgmentLine_ProW2");
local cwpro1 = JudgmentLineToColor("JudgmentLine_ProW1");

local t = Def.ActorFrame {
	--Hold Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "Hold Explosion" ) .. {
		HoldingOnCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "HoldingOnCommand");
		HoldingOffCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "HoldingOffCommand");
		InitCommand=function(self) self:playcommand("HoldingOff"):finishtweening() end;
	};
	--Roll Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "Hold Explosion" ) .. {
		RollOnCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "RollOnCommand");
		RollOffCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "RollOffCommand");
		InitCommand=function(self) self:playcommand("RollOff"):finishtweening() end;
	};
	--Dim Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "Tap Explosion Dim" ) .. {
		InitCommand=function(self) self:diffusealpha(0) end;
		W5Command=function (self) self:finishtweening():diffuse(cw5):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W4Command=function (self) self:finishtweening():diffuse(cw4):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W3Command=function (self) self:finishtweening():diffuse(cw3):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W2Command=function (self) self:finishtweening():diffuse(cw2):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W1Command=function (self) self:finishtweening():diffuse(cw1):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW1Command=function (self) self:finishtweening():diffuse(cwpro1):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW2Command=function (self) self:finishtweening():diffuse(cwpro2):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW3Command=function (self) self:finishtweening():diffuse(cwpro3):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW4Command=function (self) self:finishtweening():diffuse(cwpro4):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW5Command=function (self) self:finishtweening():diffuse(cwpro5):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		JudgmentCommand=function(self) self:finishtweening() end;
		BrightCommand=function(self) self:visible(false) end;
		DimCommand=function(self) self:visible(true) end;
	};
	--yes yes I know I could do it in another way but I'm lazy and it works doesnt it ;>
	--This code give the Hold OK explosion Dim the same images as Bright
	NOTESKIN:LoadActor( Var "Button", "Tap Explosion Bright" ) .. {
		InitCommand=function(self) self:diffusealpha(0) end;
		HeldCommand=NOTESKIN:GetMetricA("GhostArrowDim", "HeldCommand");
		JudgmentCommand=function(self) self:finishtweening() end;
		BrightCommand=function(self) self:visible(false) end;
		DimCommand=function(self) self:visible(true) end;
	};
	--Bright Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "Tap Explosion Bright" ) .. {
		InitCommand=function(self) self:diffusealpha(0) end;
		W5Command=function (self) self:finishtweening():diffuse(cw5):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W4Command=function (self) self:finishtweening():diffuse(cw4):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W3Command=function (self) self:finishtweening():diffuse(cw3):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W2Command=function (self) self:finishtweening():diffuse(cw2):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W1Command=function (self) self:finishtweening():diffuse(cw1):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW1Command=function (self) self:finishtweening():diffuse(cwpro1):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW2Command=function (self) self:finishtweening():diffuse(cwpro2):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW3Command=function (self) self:finishtweening():diffuse(cwpro3):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW4Command=function (self) self:finishtweening():diffuse(cwpro4):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW5Command=function (self) self:finishtweening():diffuse(cwpro5):diffusealpha(1):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		HeldCommand=NOTESKIN:GetMetricA("GhostArrowBright", "HeldCommand");
		JudgmentCommand=function(self) self:finishtweening() end;
		BrightCommand=function(self) self:visible(true) end;
		DimCommand=function(self) self:visible(false) end;

	};
	--Mine Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "HitMine Explosion" ) .. {
		InitCommand=function(self) self:blend("BlendMode_Add"):diffusealpha(0) end;
		HitMineCommand=NOTESKIN:GetMetricA("GhostArrowBright", "HitMineCommand");
	};
}
return t;