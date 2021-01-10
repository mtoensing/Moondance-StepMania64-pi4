local t = Def.ActorFrame {};

-- Players
for p in ivalues(PlayerNumber) do
	local eval_part_offs = string.find(p, "P1") and -310 or 310
	if GAMESTATE:IsHumanPlayer(p) then
		t[#t+1] =  Def.ActorFrame{
			InitCommand=function(self)
				self:vertalign(top):x(_screen.cx + eval_part_offs):y(SCREEN_TOP)
			end;
			  -- Bar
			  Def.Quad {
				InitCommand=function(self) 
					self:zoomto(336,61):vertalign(top) 
					self:diffuse(PlayerColor(p)):diffuserightedge(PlayerCompColor(p)):diffusealpha(0.96)
				end;
				OnCommand=function(self) self:zoomto(336,0):decelerate(0.3):zoomto(336,61) end;
				OffCommand=function(self) self:sleep(0.175):decelerate(0.4):addy(-105) end;
			 };
			 -- Avatar and name
			Def.ActorFrame {
				OnCommand=function(self) 
					self:diffusealpha(0):sleep(0.3):decelerate(0.2):diffusealpha(1) 
				end;
				Def.Sprite {
					InitCommand=function(self) self:horizalign(left):vertalign(top):xy(-164,5) end;
					Texture=LoadModule("Options.GetProfileData.lua")(p)["Image"];
					OnCommand=function(self)
						self:zoomto(52,52)
					end;
					OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
				};
				Def.BitmapText {
					Font="_Medium";
					InitCommand=function(self)
						self:horizalign(left):xy(-100,30):maxwidth(220):skewx(-0.15):queuecommand("Set")
					end;
					OnCommand=function(self) self:diffuse(ColorDarkTone(PlayerDarkColor(p))) end;	
					SetCommand=function(self)
						self:settext(LoadModule("Options.GetProfileData.lua")(p)["Name"])
					end;
					OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
				};
			};
		};

		t[#t+1] = Def.ActorFrame{
			Condition=GAMESTATE:GetNumPlayersEnabled() < 2,
			InitCommand=function(self)
				self:vertalign(top):xy( _screen.cx + (eval_part_offs*-1) ,0)
			end;
			Def.Quad {
				InitCommand=function(self) 
					self:zoomto(336,61):vertalign(top) 
					self:diffuse( ColorDarkTone(PlayerColor(p)) ):diffusealpha(0.96)
				end;
				OnCommand=function(self) self:zoomto(336,0):decelerate(0.3):zoomto(336,61) end;
				OffCommand=function(self) self:sleep(0.175):decelerate(0.4):addy(-105) end;
			},
		
			Def.ActorFrame {
				OnCommand=function(self) 
					self:diffusealpha(0):sleep(0.3):decelerate(0.3):diffusealpha(1) 
				end;
				Def.BitmapText {
					Text=ToUpper(Screen.String("RecentlyPlayed")),
					Font="_Bold";
					InitCommand=function(self)
						self:horizalign(center):y(30):maxwidth(320):zoom(1.25):skewx(-0.15)
					end;
					OnCommand=function(self) self:diffuse( ColorLightTone(PlayerColor(p)) ) end;	
					OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
				};
			}
		}
	end;
end;

-- Shorten the stage transition if we're restarting it
t[#t+1] = Def.Actor {
	OnCommand=function(self)
		setenv("CurrentlyInSong",false)
	end
};

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame {
		LoadActor(THEME:GetPathG("ScreenEvaluation", "StageDisplay")) .. {
			InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_TOP+76):zoom(0.8):visible(not GAMESTATE:HasEarnedExtraStage()) end;
			OnCommand=function(self) self:diffusealpha(0):sleep(0.3):decelerate(0.3):diffusealpha(1) end;
			OffCommand=function(self) self:sleep(0.175):decelerate(0.4):diffusealpha(0) end;
		}
	}
else
	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_TOP+76):zoom(0.8) end;
		OnCommand=function(self) self:diffusealpha(0):sleep(0.3):decelerate(0.3):diffusealpha(1) end;
		OffCommand=function(self) self:sleep(0.175):decelerate(0.4):diffusealpha(0) end;
				Def.BitmapText {
				Font="_Bold";
				InitCommand=function(self) self:y(-1):zoom(1):shadowlength(1) end;
				BeginCommand=function(self)
					self:playcommand("Set")
				end;
				CurrentSongChangedMessageCommand=function(self)
					self:playcommand("Set")
				end;
				SetCommand=function(self)
					local curStage = GAMESTATE:GetCurrentStage();
					local course = GAMESTATE:GetCurrentCourse()
					self:settext(ToEnumShortString( course:GetCourseType() ))
					-- StepMania is being stupid so we have to do this here;
					self:diffuse(StageToColor(curStage)):diffusetopedge(ColorLightTone(StageToColor(curStage)));
					self:diffusealpha(0):smooth(0.3):diffusealpha(1);
				end;
			};
	}
end;

	
if GAMESTATE:HasEarnedExtraStage() then
	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self) self:x(SCREEN_CENTER_X):y(SCREEN_TOP+76):zoom(0.8) end;
		OnCommand=function(self) self:diffusealpha(0):sleep(0.3):decelerate(0.4):diffusealpha(1) end;
		OffCommand=function(self) self:sleep(0.175):decelerate(0.4):diffusealpha(0) end;
			Def.BitmapText {
				Font="_Medium";
				InitCommand=function(self) self:y(-1):zoom(1):shadowlength(1):maxwidth(250) end;
				BeginCommand=function(self)
					self:playcommand("Set")
				end;
				CurrentSongChangedMessageCommand=function(self)
					self:playcommand("Set")
				end;
				SetCommand=function(self)
					local curStage = GAMESTATE:GetCurrentStage();
					local text = THEME:GetString("ScreenEvaluation", "ExtraUnlocked")
					self:settext(text)
					-- StepMania is being stupid so we have to do this here;
					self:diffuse(ColorLightTone(StageToColor(curStage)));
					self:diffusealpha(0):smooth(0.3):diffusealpha(1);
				end;
			};
		};
end;

return t;
