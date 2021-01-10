--If a Command has "NOTESKIN:GetMetricA" in it, that means it gets the command from the metrics.ini, else use cmd(); to define command.
--If you dont know how "NOTESKIN:GetMetricA" works here is an explanation.
--NOTESKIN:GetMetricA("The [Group] in the metrics.ini", "The actual Command to fallback on in the metrics.ini");

--The NOTESKIN:LoadActor() just tells us the name of the image the Actor redirects on.
--Oh and if you wonder about the "Button" in the "NOTESKIN:LoadActor( )" it means that it will check for that direction.
--So you dont have to do "Down" or "Up" or "Left" etc for every direction which will save space ;)


local t = Def.ActorFrame {
	--Dim Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "Tap Explosion Dim" ) .. {
		InitCommand=function(self) self:diffusealpha(0) end;
		W5Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W4Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W3Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W2Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		W1Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.1) end;
		ProW1Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW2Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW3Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW4Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW5Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.7):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
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
		W5Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		W4Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		W3Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		W2Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		W1Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW1Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW2Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW3Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW4Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
		ProW5Command=function (self) self:finishtweening():diffuse(color("#FFFFFF")):zoom(1):diffusealpha(0.8):sleep(.1):decelerate(.2):diffusealpha(0):zoom(1.3) end;
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