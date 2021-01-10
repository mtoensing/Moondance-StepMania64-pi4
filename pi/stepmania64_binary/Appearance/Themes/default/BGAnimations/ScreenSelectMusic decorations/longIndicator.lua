return Def.ActorFrame {
	OnCommand=function(self) self:playcommand("Set") end;
	CurrentSongChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
	CurrentLanguageChangedMessageCommand=function(self) self:finishtweening():playcommand("Set") end;
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
	local hiddenindicator = 0
		if song then
			if song:IsLong() then
				self:decelerate(0.15):diffusealpha(1)
				MESSAGEMAN:Broadcast("SetLongSong")
				hiddenindicator = 0
			elseif song:IsMarathon() then
				self:decelerate(0.15):diffusealpha(1)
				MESSAGEMAN:Broadcast("SetMarathonSong")
				hiddenindicator = 0
			else
				if hiddenindicator ~= 1 then
					hiddenindicator = 1
					self:decelerate(0.15):diffusealpha(0)
				end;
			end
		else
			self:decelerate(0.15):diffusealpha(0)
		end;
	end;
	OffCommand=function(self) self:stoptweening():decelerate(0.3):diffusealpha(0) end;
	LoadActor(THEME:GetPathB("_frame","3x1"),"rounded light", 160-16) .. {
		InitCommand=function(self) self:diffuse(color("#666666")) end;
		SetLongSongMessageCommand=function(self) self:decelerate(0.08):diffuse(color("#29739b")) end;
		SetMarathonSongMessageCommand=function(self) self:decelerate(0.08):diffuse(color("#29419b")) end;
	};
	Def.BitmapText {
		Font="_Semibold",
		InitCommand=function(self) self:maxwidth(150):vertalign(middle) end,
		SetLongSongMessageCommand=function(self) 
			self:settext( ToUpper(THEME:GetString("ScreenSelectMusic","LongSong")) )
		end,
		SetMarathonSongMessageCommand=function(self) 
			self:settext( ToUpper(THEME:GetString("ScreenSelectMusic","MarathonSong")) )
		end
	}
}