return Def.BitmapText {
	Font="_Condensed Medium";
	AltText="";
	BeginCommand=function(self)
		self:settextf( LoadModule("Options.OverwriteTiming.lua")() .. " (" .. Screen.String("TimingDifficulty"), GetTimingDifficulty() .. ")" );
		self:diffuse(color("#FFFFFF")):zoom(0.75);
		self:diffusealpha(0):sleep(0.5):smooth(0.3):diffusealpha(1);
	end;
};
