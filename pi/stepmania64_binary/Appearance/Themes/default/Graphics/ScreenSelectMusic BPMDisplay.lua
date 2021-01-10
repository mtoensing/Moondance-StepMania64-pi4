return Def.BPMDisplay {
	File=THEME:GetPathF("", "_SemiBold");
	Name="BPMDisplay";
	SetCommand=function(self) self:SetFromGameState() end;
	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
};