return Def.ActorFrame {
	Def.DeviceList {
		Font="_Condensed Semibold",
		InitCommand=function(self)
			self:x(SCREEN_LEFT+30):y(SCREEN_TOP+100):horizalign(left):vertalign(top)
		end;
		OnCommand=function(self)
			self:diffusealpha(0):linear(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:linear(0.3):diffusealpha(0)
		end;
	};

	Def.InputList {
		Font="_Condensed Semibold",
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):horizalign(center):vertalign(top):vertspacing(12)
		end;
	};
};