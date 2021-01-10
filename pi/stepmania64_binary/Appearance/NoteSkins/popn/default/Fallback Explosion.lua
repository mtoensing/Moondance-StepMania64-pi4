--If a Command has "NOTESKIN:GetMetricA" in it, that means it gets the command from the metrics.ini, else use cmd(); to define command.
--If you dont know how "NOTESKIN:GetMetricA" works here is an explanation.
--NOTESKIN:GetMetricA("The [Group] in the metrics.ini", "The actual Command to fallback on in the metrics.ini");

--The NOTESKIN:LoadActor() just tells us the name of the image the Actor redirects on.
--Oh and if you wonder about the "Button" in the "NOTESKIN:LoadActor( )" it means that it will check for that direction.
--So you dont have to do "Down" or "Up" or "Left" etc for every direction which will save space ;)
local t = Def.ActorFrame {
	--Hold Explosion Commands
	Def.Sprite {
		Texture="_flare white";
		HoldingOnCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "HoldingOnCommand");
		HoldingOffCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "HoldingOffCommand");
		InitCommand=function(self)
			self:blend('add'):playcommand("HoldingOff"):finishtweening()
		end;
	};
	--Roll Explosion Commands
	Def.Sprite {
		Texture="_flare white";
		RollOnCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "RollOnCommand");
		RollOffCommand=NOTESKIN:GetMetricA("HoldGhostArrow", "RollOffCommand");
		InitCommand=function(self)
			self:playcommand("RollOff"):finishtweening()
		end;
	};
	--Dim Explosion Commands
	Def.Sprite {
		Texture="_flare white";
		InitCommand=function(self)
			self:diffusealpha(0)
		end;
		W5Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		W4Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		W3Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		W2Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		W1Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		ProW5Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		ProW4Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		ProW3Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		ProW2Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		ProW1Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlashCommand");
		JudgmentCommand=function(self)
			self:finishtweening()
		end;
		BrightCommand=function(self)
			self:visible(false)
		end;
		DimCommand=function(self)
			self:visible(true)
		end;
	};
	--yes yes I know I could do it in another way but I'm lazy and it works doesnt it ;>
	--This code give the Hold OK explosion Dim the same images as Bright
	Def.Sprite {
		Texture="_flare white";
		InitCommand=function(self)
			self:diffusealpha(0)
		end;
		HeldCommand=NOTESKIN:GetMetricA("GhostArrowDim", "HeldCommand");
		JudgmentCommand=function(self)
			self:finishtweening()
		end;
		BrightCommand=function(self)
			self:visible(false)
		end;
		DimCommand=function(self)
			self:visible(true)
		end;
	};
	Def.Sprite {
		Texture="_flare blue";
		InitCommand=function(self)
			self:diffusealpha(0)
		end;
		W5Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		W4Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		W3Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		W2Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		W1Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		ProW5Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		ProW4Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		ProW3Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		ProW2Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		ProW1Command=NOTESKIN:GetMetricA("GhostArrowDim", "FlareCommand");
		JudgmentCommand=function(self)
			self:finishtweening()
		end;
	};
	Def.Sprite {
		Texture="_flare ring";
		InitCommand=function(self)
			self:diffusealpha(0)
		end;
		W5Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		W4Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		W3Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		W2Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		W1Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		ProW5Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		ProW4Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		ProW3Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		ProW2Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		ProW1Command=NOTESKIN:GetMetricA("GhostArrowDim", "RingCommand");
		JudgmentCommand=function(self)
			self:finishtweening()
		end;
	};	
	--Mine Explosion Commands
	NOTESKIN:LoadActor( Var "Button", "HitMine Explosion" ) .. {
		InitCommand=function(self)
			self:blend("BlendMode_Add"):diffusealpha(0)
		end;
		HitMineCommand=NOTESKIN:GetMetricA("GhostArrowBright", "HitMineCommand");
	};
}
return t;