return Def.BitmapText {
	Font="_Condensed Medium";
	Text=LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini");
	AltText="";
	BeginCommand=function(self)
		self:settextf( Screen.String("TimingName"), LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") );
		self:diffuse(color("#FFFFFF")):zoom(0.75);
		self:diffusealpha(0):sleep(0.5):smooth(0.3):diffusealpha(1);
	end
};
