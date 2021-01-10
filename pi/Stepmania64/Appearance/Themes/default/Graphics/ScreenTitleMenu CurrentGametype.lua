return Def.BitmapText {
	Font="_Medium";
	BeginCommand=function(self)
		self:settextf( Screen.String("CurrentGametype"), GAMESTATE:GetCurrentGame():GetName());
	end;
};