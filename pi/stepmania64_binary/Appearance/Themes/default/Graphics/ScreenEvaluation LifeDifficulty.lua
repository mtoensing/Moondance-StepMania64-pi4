return Def.BitmapText {
	Font="_Condensed Medium";
	Text=GetLifeDifficulty();
	AltText="";
	BeginCommand=function(self)
		self:settextf( Screen.String("LifeDifficulty"), GetLifeDifficulty() );
		self:diffuse(color("#FFFFFF")):zoom(0.75);
		self:diffusealpha(0):sleep(0.5):smooth(0.3):diffusealpha(1);
	end
};
