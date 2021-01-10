local barSleepIn = 0.9
local songAreaWidth = SCREEN_WIDTH*0.4375
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage") and 1 or 0
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );
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
-- Progress bar function
local function UpdateTime(self)
	local c = self:GetChildren();
	for pn in ivalues(PlayerNumber) do
		local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn );
		local vTime;
		local obj = self:GetChild( string.format("RemainingTime" .. PlayerNumberToString(pn) ) );
		if vStats and obj then
			vTime = vStats:GetLifeRemainingSeconds()
			obj:settext( SecondsToMMSSMsMs( vTime ) );
		end;
	end;
end
local function songMeterScale(val) return scale(val,0,1,-380/2,380/2) end	

local function GetPlScore(pl, scoretype)
	local primary_score = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetScore()
	local secondary_score = FormatPercentScore(STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetPercentDancePoints())

	if PREFSMAN:GetPreference("PercentageScoring") then
		primary_score, secondary_score = secondary_score, primary_score
	end

	if scoretype == "primary" then
		return primary_score
	else
		return secondary_score
	end
end

	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(0).."/OutFoxPrefs.ini") then
			t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(1)
		end
	end

	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(1).."/OutFoxPrefs.ini") then
			t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(2)
		end
	end

	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75) end;
		OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end;
		Def.Quad {
			InitCommand=function(self)
				self:xy(0,0):vertalign(top):horizalign(left):zoomto(SCREEN_WIDTH,56) 
			end;
			OnCommand=function(self)
				self:diffuse(ColorTable["gameplayHeader"])
			end;
		};	
		-- Colors for each player
		Def.ActorFrame {
			OnCommand=function(self) 
				self:diffusealpha(0):sleep(barSleepIn+0.8):linear(0.2):diffusealpha(0.9):decelerate(2):diffusealpha(0.7)
			end;
			Def.Quad {
				InitCommand=function(self) 
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):x(SCREEN_LEFT):y(0):vertalign(top):horizalign(left):zoomto(320,56)
					self:diffuse(ColorMidTone(PlayerColor(PLAYER_1))):faderight(1)
				end
			};		
			Def.Quad {
				InitCommand=function(self) 
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2)):x(SCREEN_RIGHT):y(0):vertalign(top):horizalign(right):zoomto(320,56)
					self:diffuse(ColorMidTone(PlayerColor(PLAYER_2))):fadeleft(1)
				end
			};
		};		
	};

	-- Score and Difficulty
	for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		local playerpos
		local life_x_position = string.find(pn, "P1") and SCREEN_LEFT+32 or SCREEN_RIGHT-32;
		local score_x_position = string.find(pn, "P1") and SCREEN_LEFT+(SCREEN_WIDTH*0.16796875) or SCREEN_RIGHT-(SCREEN_WIDTH*0.16796875);
		local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn );
		
		t[#t+1] = Def.Sprite{
			OnCommand=function(self)
				if SCREENMAN:GetTopScreen() and GAMESTATE:IsPlayerEnabled( pn ) then
					playerpos = SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(pn)):GetX()
				end
				self:xy(playerpos-180,SCREEN_TOP+28):halign(0):customtexturerect(0,0,1,1):texcoordvelocity(1,0):cropbottom(0.08):zoomx(0.826)
				self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
			end,
			LifeChangedMessageCommand=function(s,param)
				if param.Player == pn then
					s:cropright( 1 - param.LifeMeter:GetLife() )
				end
			end,
			OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end;
			Texture=THEME:GetPathG("StreamDisplay","normal"),
		}

		t[#t+1] = Def.BitmapText {
			Font="_Plex Numbers 60px",
			InitCommand=function(self)
				self:shadowlength(1):zoom(0.75)
				:horizalign(center):maxwidth(SCREEN_WIDTH*0.2234375)
				if PREFSMAN:GetPreference("PercentageScoring") then
					self:settext("0.00%")
				else
					self:settext("0")
				end
			end,
			OnCommand=function(self)
				self:xy(playerpos,30)
				self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
				if GAMESTATE:GetPlayMode() == "PlayMode_Endless" then
					self:queuecommand("UpdateTimer")
				end
			end;
			JudgmentMessageCommand=function(self)
				if GAMESTATE:GetPlayMode() == "PlayMode_Endless" then
					self:queuecommand("UpdateTimer")
				else
					self:queuecommand("RedrawScore")
				end
			end,
			UpdateTimerCommand=function(self)
				self:finishtweening():settext( SecondsToMMSSMsMs( vStats:GetAliveSeconds() ) )
				:sleep(1/60):queuecommand("UpdateTimer")
			end;
            RedrawScoreCommand=function(self)
				self:settext(GetPlScore(pn, "primary"))
			end;
			OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end;
		};

		t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) self:visible(GAMESTATE:IsHumanPlayer(pn)) end;
		OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end;
			Def.ActorFrame {
				InitCommand=function(self)
					self:horizalign(center)
				end;
				OnCommand=function(self)
					self:xy(playerpos-210,SCREEN_TOP+28):addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
				end;
				-- Quad
				Def.ActorFrame {
					["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
						SetCommand=function(self)
								local steps_data = GAMESTATE:GetCurrentSteps(pn)
								local song = GAMESTATE:GetCurrentSong();
									if song then
										if steps_data ~= nil then
										local st = steps_data:GetStepsType();
										local diff = steps_data:GetDifficulty();
										local cd = GetCustomDifficulty(st, diff);
										self:diffuse(CustomDifficultyToColor(cd)):diffuserightedge(ColorLightTone(CustomDifficultyToColor(cd))):diffusealpha(0.8);
									end
								end
						end;			
					Def.Quad {
						InitCommand=function(self)
							self:horizalign(center):zoomto(62,56):diffuse(color("#8F8F8F")):diffusebottomedge(color("#E0E0E0"))
						end;
					};
				};
				-- Number
				Def.BitmapText {
					Font="_plex sans condensed score 32px";
					InitCommand=function(self)
						self:zoom(1):horizalign(center):maxwidth(40):y(-4)
						end;
					OnCommand=function(self)
						self:playcommand("Set"):diffusealpha(0):sleep(barSleepIn+0.3):linear(0.3):diffusealpha(1)
					end;
					["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
					SetCommand=function(self)
							local steps_data = GAMESTATE:GetCurrentSteps(pn)
							local song = GAMESTATE:GetCurrentSong();
								if song then
									if steps_data ~= nil then
									local st = steps_data:GetStepsType();
									local diff = steps_data:GetDifficulty();
									local cd = GetCustomDifficulty(st, diff);
									self:settext(steps_data:GetMeter())
									self:diffuse(Color.White);
								end
							end
					end;
				};
			};
		};
	end;

return t;