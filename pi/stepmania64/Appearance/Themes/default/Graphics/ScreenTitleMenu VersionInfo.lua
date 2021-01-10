return Def.ActorFrame {
	Def.BitmapText {
		Font="_Condensed Medium";
		Text=string.format("%s %s", ProductFamily(), ProductVersion());
		AltText="StepMania";
		InitCommand=function(self) self:zoom(1):diffuse(color("#FFFFFF")) end;
	};
	Def.BitmapText {
		Font="_Medium";
		Text=string.format("%s", VersionDate());
		AltText="Unknown Version";
		InitCommand=function(self) self:zoom(0.75):y(21):diffuse(color("#FFFFFF")):diffusealpha(0.75) end;
	};
};