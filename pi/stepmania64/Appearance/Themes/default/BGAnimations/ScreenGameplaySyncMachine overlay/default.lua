local barSleepIn = 0.9
local songAreaWidth = SCREEN_WIDTH*0.4375
local t = Def.ActorFrame {
	-- Global message caller for all the things
    OnCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
    CurrentStepsP1ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
    CurrentStepsP2ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
	CurrentTrailP1ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
	CurrentTrailP2ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
    CurrentCourseChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
    CurrentSongChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end;
};
local function songMeterScale(val) return scale(val,0,1,-380/2,380/2) end	

	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75) end;
		OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end;
		Def.Quad {
			InitCommand=function(self)
				self:xy(0,0):vertalign(top):horizalign(left):zoomto(SCREEN_WIDTH,56) 
			end;
			OnCommand=function(self)
				self:diffuse(color("#0E1A3A")):diffusealpha(0.72)
			end;
		};	
		-- Song title area except it's a help message this time
		Def.ActorFrame {
				Def.Quad {
					InitCommand=function(self) self:vertalign(top):horizalign(center):xy(SCREEN_CENTER_X,0):fadetop(1):zoomto(0,56) end;
					OnCommand=function(self)
						self:sleep(barSleepIn+0.3):decelerate(0.6):zoomto(songAreaWidth,56)
					end;
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage();
						self:diffuse(StageToColor(curStage)):diffusealpha(0.3);
					end;
				};

			-- Song meter
			Def.ActorFrame {
			OnCommand=function(self)
				self:diffuseshift():effectclock("beat"):effectcolor1(color("1,1,1,0.5")):effectcolor2(color("1,1,1,0.8"))
			end;		
				Def.Quad {
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X,56):vertalign(bottom):horizalign(center) 
					end;
					OnCommand=function(self)
						self:zoomto(0,7):sleep(barSleepIn+0.3):decelerate(0.6):zoomto(songAreaWidth,7)
					end;
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage();
						self:diffuse(ColorDarkTone((StageToColor(curStage)))):diffusealpha(0.5);
					end;		
				};	
			};
			Def.SongMeterDisplay {
				InitCommand=function(self) self:xy(SCREEN_CENTER_X,56):vertalign(bottom):horizalign(center) end;
				StreamWidth=songAreaWidth;
				Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream') )..{
					InitCommand=function(self)
						self:vertalign(bottom):diffusealpha(0.4):zoomy(0.5)
					end;
				};
				Tip=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'tip')) .. { 
					InitCommand=function(self)
						self:vertalign(bottom):visible(false)
					end;
				};
			};
				--- Not song info this time
				Def.BitmapText {
					Font="_Bold";
					InitCommand=function(self)
						self:x(SCREEN_CENTER_X):y(26):zoom(0.8):maxwidth(SCREEN_WIDTH*0.421875):diffuse(color("#FFFFFF")):horizalign(center)
					end;
					OnCommand=function(self)
						self:diffusealpha(0):sleep(barSleepIn+0.3+0.9):decelerate(0.7):diffusealpha(0.75)
					end;
					SetMessageCommand=function(self)
						   self:settext(THEME:GetString("ScreenGameplaySyncMachine","HelpMessage"))
					  end;
				};
			};
		};

return t;