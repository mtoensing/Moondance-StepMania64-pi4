return Def.ActorFrame {
	-- We want this under the noteskin, so that we it looks like a laser (?)
	LoadActor( NOTESKIN:GetPath("", "_Tap Receptor"), NOTESKIN:LoadActor( Var "Button", "KeypressBlock" ) ) .. {
		InitCommand=function(self)
			self:vertalign(top):blend('add'):diffusealpha(0):fadetop(0.3)
		end;
		-- Press/Lift allows this to appear and disappear
		PressCommand=function(self)
			self:finishtweening():decelerate(0.11):diffusealpha(0.75)
		end;
		LiftCommand=function(self)
			self:stoptweening():decelerate(0.11):diffusealpha(0)
		end;
	};	
	-- Overlay the receptor.
	LoadActor( NOTESKIN:GetPath("", "_Tap Receptor"), NOTESKIN:LoadActor( Var "Button", "Go Receptor" ) );	
	-- Receptor flash to align with default
	LoadActor( NOTESKIN:GetPath("", "_Tap Receptor"), NOTESKIN:LoadActor( Var "Button", "Flash Receptor" ) ) .. {
		InitCommand=NOTESKIN:GetMetricA('ReceptorOverlay', 'InitCommand');
		PressCommand=NOTESKIN:GetMetricA('ReceptorOverlay', 'PressCommand');
		LiftCommand=NOTESKIN:GetMetricA('ReceptorOverlay', 'LiftCommand');
		NoneCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand');
	};
};

