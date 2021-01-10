return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen():diffuse(color("0,0,0,0"));
		end;
		StartTransitioningCommand=function(self)
			self:sleep(2):linear(0.3):diffusealpha(1)
		end;
	};

};