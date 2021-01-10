return LoadActor(THEME:GetPathG("MusicWheelItem", "ModeItem")) .. {
	OnCommand=function(self) self:diffuse(color("#666666")) end;
};