return Def.ActorFrame {
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong(); 
		if song then
-- 			self:setaux(0);
			self:finishtweening();
			self:decelerate(0.3):diffusealpha(1)
		elseif not song and self:GetZoomX() == 1 then
-- 			self:setaux(1);
			self:finishtweening();
			self:decelerate(0.3):diffusealpha(0)
		end;
	end;
	Def.StepsDisplayList {
		Name="StepsDisplayListRow";
		OnCommand=function(self)
		self:diffusealpha(0):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
		self:decelerate(0.3):diffusealpha(0)
		end;
		CursorP1 = Def.ActorFrame {
			InitCommand=function(self) self:x(-87):player(PLAYER_1) end;
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true):zoom(0):bounceend(1):zoom(1)
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true):bouncebegin(1):zoom(0)
				end;
			end;
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self) self:diffuse(ColorLightTone(PlayerColor(PLAYER_1))):x(8):zoom(0.75) end;
			};			
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self) self:x(8):zoom(0.75):blend('add') end;
				OnCommand=function(self) self:diffuseshift():effectcolor2(color("1,1,1,0.1")):effectcolor1(color("1,1,1,0.3")):effectclock('beatnooffset') end;
			};
		};
		CursorP2 = Def.ActorFrame {
			InitCommand=function(self) self:x(87):player(PLAYER_2):zoom(1) end;
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true):zoom(0):bounceend(1):zoom(1)
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true):bouncebegin(1):zoom(0)
				end;
			end;
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self) self:diffuse(ColorLightTone(PlayerColor(PLAYER_2))):x(-8):zoomy(0.75):zoomx(-0.75) end;
			};	
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self) self:x(-8):zoomy(0.75):zoomx(-0.75):blend('add') end;
				OnCommand=function(self) self:diffuseshift():effectcolor2(color("1,1,1,0.1")):effectcolor1(color("1,1,1,0.3")):effectclock('beatnooffset') end;
			};
		};
		CursorP1Frame = Def.Actor{
			ChangeCommand=function(self) self:stoptweening():decelerate(0.05) end;
		};
		CursorP2Frame = Def.Actor{
			ChangeCommand=function(self) self:stoptweening():decelerate(0.05) end;
		};
	};
};