local barSleepIn = 0.9
local songAreaWidth = SCREEN_WIDTH*0.4375
local nativeTitle = tobool(PREFSMAN:GetPreference("ShowNativeLanguage"))
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
local t = Def.ActorFrame {
	-- Global message caller for all the things
    OnCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
    CurrentStepsP1ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
    CurrentStepsP2ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
    CurrentCourseChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end,
    CurrentSongChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("Set") end
}

local function GetPlScore(pl)
	local primary_score = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetScore()
	local secondary_score = FormatPercentScore(STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetPercentDancePoints())

	if PREFSMAN:GetPreference("PercentageScoring") then
		primary_score, secondary_score = secondary_score, primary_score
	end
	
	return primary_score
end

	local stpenable = {}

	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(0).."/OutFoxPrefs.ini") then
			t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(1)
		end
		stpenable[1] = LoadModule("Config.Load.lua")("OverTopGraph",CheckIfUserOrMachineProfile(string.sub(PLAYER_1,-1)-1).."/OutFoxPrefs.ini")
	end
	
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(1).."/OutFoxPrefs.ini") then
			t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(2)
		end
		stpenable[2] = LoadModule("Config.Load.lua")("OverTopGraph",CheckIfUserOrMachineProfile(string.sub(PLAYER_2,-1)-1).."/OutFoxPrefs.ini")
	end

	local mast = GAMESTATE:GetMasterPlayerNumber()

	local enabledstp = GAMESTATE:GetNumPlayersEnabled() > 1 and (stpenable[1] or stpenable[2])
	local singlestp = GAMESTATE:GetNumPlayersEnabled() == 1 and LoadModule("Config.Load.lua")("OverTopGraph",CheckIfUserOrMachineProfile(string.sub(mast,-1)-1).."/OutFoxPrefs.ini")

	local possiblepos = { 
		["PlayerNumber_P1"] = SCREEN_CENTER_X*1.420,
		["PlayerNumber_P2"] = SCREEN_CENTER_X*0.580,
		SCREEN_CENTER_X
	}

	local songareapos = ((stpenable[1] or stpenable[2]) and GAMESTATE:GetNumPlayersEnabled() < 2) and possiblepos[mast] or possiblepos[1]
	
	-- Colors for each player
	local quads = Def.ActorFrame {
		OnCommand=function(self) 
			self:diffusealpha(0):sleep(barSleepIn+0.8):linear(0.2):diffusealpha(0.9):decelerate(2):diffusealpha(0.7)
		end
	}

	for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
		quads[#quads+1] = Def.Quad {
			InitCommand=function(self) 
				self:visible(GAMESTATE:IsHumanPlayer(pn)):x( pn == PLAYER_2 and SCREEN_RIGHT or 0)
				:align( pn == PLAYER_2 and 1 or 0 ,0):zoomto(320,56)
				self:diffuse(ColorMidTone(PlayerColor(pn)))
				:fadeleft( pn == PLAYER_2 and 1 or 0 ):faderight( pn == PLAYER_1 and 1 or 0 )
			end
		}
	end

	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75) end,
		OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end,
		Def.Quad {
			InitCommand=function(self) self:align(0,0):zoomto(SCREEN_WIDTH,56) end,
			OnCommand=function(self) self:diffuse(ColorTable["gameplayHeader"]) end
		},
		-- Colors for each player
		quads,
		-- Song title area
		Def.ActorFrame {
			Condition=(not enabledstp),
				Def.Quad {
					InitCommand=function(self) self:align(0.5,0):xy(songareapos,0):zoomto(0,56) end,
					OnCommand=function(self)
						self:sleep(barSleepIn+0.3):decelerate(0.6):zoomto(songAreaWidth,56)
					end,
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage()
						self:diffuse(ColorTable["gameplayTitle"]):diffusealpha(0.3)
					end,
				},

			-- Song meter
			Def.ActorFrame {
			OnCommand=function(self)
				self:diffuseshift():effectclock("beat"):effectcolor1(color("1,1,1,0.5")):effectcolor2(color("1,1,1,0.8"))
			end,	
				Def.Quad {
					InitCommand=function(self) self:xy(songareapos,56):align(0.5,1) end,
					OnCommand=function(self)
						self:zoomto(0,7):sleep(barSleepIn+0.3):decelerate(0.6):zoomto(songAreaWidth,7)
					end,
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage()
						self:diffuse(ColorTable["gameplayMeter"]):diffusealpha(0.5)
					end,		
				}
			},
			Def.SongMeterDisplay {
				InitCommand=function(self) self:xy(songareapos,56):align(0.5,1) end,
				StreamWidth=songAreaWidth,
				Stream=LoadActor( THEME:GetPathG( 'SongMeterDisplay', 'stream') )..{
					InitCommand=function(self)
						self:valign(1):diffusealpha(0.4):zoomy(0.5)
					end,
				},
				Tip=Def.ActorFrame{}
			},
			--- Song info
			Def.BitmapText {
				Font="SongTitle font",
				InitCommand=function(self)
					self:x(songareapos+(SCREEN_WIDTH*0.21)):y(26):zoom(1):maxwidth(SCREEN_WIDTH*0.421875):diffuse(color("#FFFFFF")):horizalign(right)
				end,
				OnCommand=function(self)
					self:diffusealpha(0):sleep(barSleepIn+0.3+0.9):decelerate(0.7):diffusealpha(1)
				end,
				SetMessageCommand=function(self)
					   	local song = GAMESTATE:GetCurrentSong()
					   	self:settext("")
						   if song then
							self:settext(nativeTitle and song:GetDisplayMainTitle() or song:GetTranslitMainTitle(), song:GetTranslitMainTitle() )
							self:y(song:GetDisplaySubTitle() ~= "" and  26-14 or 26-6)
						end
				  end,
			},
			Def.BitmapText {
				Font="SongSubTitle font",
				InitCommand=function(self)
					self:xy(songareapos+(SCREEN_WIDTH*0.21),26+6):zoom(0.6):maxwidth(SCREEN_WIDTH*0.578125):diffuse(color("#FFFFFF")):horizalign(right)
				end,
				OnCommand=function(self)
					self:diffusealpha(0):sleep(barSleepIn+0.3+0.9):decelerate(0.7):diffusealpha(1)
				end,
				SetMessageCommand=function(self)
					local song = GAMESTATE:GetCurrentSong()
					self:settext("")
					if song then
						self:settext(nativeTitle and song:GetDisplaySubTitle() or song:GetTranslitSubTitle())
					end
				end
			},
			--- Stage
			Def.ActorFrame {
				InitCommand=function(self)
					self:y(26):diffuse(color("#FFFFFF")):halign(1)
					self:x(songareapos-(SCREEN_WIDTH*( IsWidescreen() and 0.18 or 0.17)))
				end,
				OnCommand=function(self)
					self:diffusealpha(0):sleep(barSleepIn+0.3+0.7):decelerate(0.7):diffusealpha(1)
				end,
					Def.BitmapText {
					Font="_Bold",
					Condition=not PREFSMAN:GetPreference("EventMode") or GAMESTATE:IsCourseMode(),
					InitCommand=function(self)
						self:y(-7):maxwidth(88):skewx(-0.15)
					end,
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage()
						local text = ""
						if GAMESTATE:IsCourseMode() then
							local stats = STATSMAN:GetCurStageStats()
							if not stats then
								return
							end
							local mpStats = stats:GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
							local songsPlayed = mpStats:GetSongsPassed() + 1
							if GAMESTATE:GetPlayMode() == "PlayMode_Endless" then
								text = string.format( "%i", songsPlayed )
							else
								text = string.format( "%i / %i", songsPlayed, GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() )
							end
						else
							text = string.format( "%s", ToEnumShortString(curStage) )
						end
						self:settext( ToUpper(text) )
						self:diffuse(ColorLightTone(StageToColor(curStage)))
					end
				},
				Def.BitmapText {
					Font="_Bold",
					Condition=not PREFSMAN:GetPreference("EventMode") or GAMESTATE:IsCourseMode(),
					InitCommand=function(self) self:y(12):skewx(-0.15) end,
					SetMessageCommand=function(self)
						local curStage = GAMESTATE:GetCurrentStage()
						self:settext( ToUpper(GAMESTATE:IsCourseMode() and "Songs" or "Stage") )
						self:zoom(0.6):diffuse(ColorLightTone(StageToColor(curStage)))
					end
				}
			}
		}
	}

	
	-- Score and Difficulty
	for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		t[#t+1] = Def.Actor{
			CurrentSongChangedMessageCommand=function(s)
				local peak,npst,NMeasure,mcount = LoadModule("Chart.GetNPS.lua")( GAMESTATE:GetCurrentSteps(pn) )
				GAMESTATE:Env()["ChartData"..pn] = {peak,npst,NMeasure,mcount}
			end,
		}
		local alreadyfadedpercentage = false
		local stp = LoadModule("Config.Load.lua")("OverTopGraph",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
		if stp then
			local maxwidth = scale( SCREEN_WIDTH, 960, 1152, 360, 394 ) > 394 and 394 or scale( SCREEN_WIDTH, 960, 1152, 360, 394 )
			local maxheight = 35
			local SctMargin = {
				Left = -(maxwidth/2),
				Right = (maxwidth/2)
			}
			local pnum = pn == PLAYER_1 and 1 or 2
			local ppos = THEME:GetMetric("ScreenGameplay","PlayerP".. pnum .."MiscX")+( pnum == 2 and 26 or -26 )
			local verts = {}
		
			t[#t+1] = Def.Quad{
				OnCommand=function(s)
					s:zoomto( maxwidth, maxheight*2 ):MaskDest():halign(0):diffuse( color("#222222") ):xy( ppos+( SctMargin.Left ), 21 ):playcommand("Update")
					s:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
				end,
				OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end
			}
	
			t[#t+1] = Def.ActorMultiVertex{   
				OnCommand=function(s)
					s:xy( ppos, 20 )
					s:MaskDest():SetDrawState{Mode="DrawMode_QuadStrip"}
					:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
				end,
				CurrentSongChangedMessageCommand=function(s)
					if GAMESTATE:GetCurrentSong() then
						local data = GAMESTATE:Env()["ChartData"..pn]
						local tnp, npst = data[1],data[2]
						local SongMargin = {
							Start = math.min(GAMESTATE:GetCurrentSong():GetTimingData():GetElapsedTimeFromBeat(0), 0),
							End = GAMESTATE:GetCurrentSong():GetLastSecond(),
						}
						-- Grab every instance of the NPS data.
						verts = {}
						if npst then
							for k,v in pairs( npst ) do
									-- Each NPS area is per MEASURE. not beat. So multiply the area by 4 beats.
									local t = GAMESTATE:GetCurrentSong():GetTimingData():GetElapsedTimeFromBeat((k-1)*4)
									-- With this conversion on t, we now apply it to the x coordinate.
									local x = scale( t, SongMargin.Start, SongMargin.End, SctMargin.Left, SctMargin.Right )
									-- Now scale that position on v to the y coordinate.
									local y = math.round( scale( v, 0, tnp, maxheight, -maxheight ) )
									-- And send them to the table to be rendered.
									if x <= SctMargin.Right then
										if #verts > 2 and verts[#verts][1][2] == y and verts[#verts-2][1][2] == y then
											verts[#verts][1][1] = x
											verts[#verts-1][1][1] = x
										else
											verts[#verts+1] = {{x, maxheight, 0}, PlayerColor(pn) }
											verts[#verts+1] = {{x, y, 0}, ColorDarkTone(PlayerColor(pn))}
										end
									end
							end
							s:SetNumVertices( #verts ):SetVertices( verts )
						end
					end
				end,
				OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end
			}

			t[#t+1] = Def.Quad{
				OnCommand=function(s)
					s:zoomto( 0, maxheight*2 ):MaskDest():halign(0):diffuse( color("#00000099") ):xy( ppos+SctMargin.Left, 20 )
				end,
				CurrentSongChangedMessageCommand=function(s)
					s:playcommand("Update")
				end,
				UpdateCommand=function(s)
					if GAMESTATE:GetCurrentSong() then
						local SongMargin = {
							Start = math.min(GAMESTATE:GetCurrentSong():GetTimingData():GetElapsedTimeFromBeat(0), 0),
							End = GAMESTATE:GetCurrentSong():GetLastSecond(),
						}
						local length = scale( GAMESTATE:GetCurMusicSeconds(), SongMargin.Start, SongMargin.End, 0, SctMargin.Right*2 )
						s:zoomtowidth( GAMESTATE:GetCurMusicSeconds() > 0 and (length > SctMargin.Right*2 and SctMargin.Right*2 or length) or 0)
					end
					s:sleep(1/20):queuecommand("Update")
				end,
				OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end
			}
		end

		local life_x_position = string.find(pn, "P1") and SCREEN_LEFT+32 or SCREEN_RIGHT-32
		local score_x_position = string.find(pn, "P1") and SCREEN_LEFT+(SCREEN_WIDTH*0.16796875) or SCREEN_RIGHT-(SCREEN_WIDTH*0.16796875)
		
		t[#t+1] = Def.ActorFrame{
			OnCommand=function(self)
				if stp then
					self:playcommand("CheckForTime")
				end
				self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75)
			end,
			CheckForTimeCommand=function(s)
				if GAMESTATE:GetCurMusicSeconds() > GAMESTATE:GetCurrentSong():GetLastSecond()*.6 and not alreadyfadedpercentage then
					s:queuecommand("FadePercentage")
					alreadyfadedpercentage = true
				end
				s:sleep(1/30):queuecommand("CheckForTime")
			end,
			FadePercentageCommand=function(s)
				s:accelerate(1):diffusealpha(0.4)
			end,
			CurrentSongChangedMessageCommand=function(s)
				if stp and alreadyfadedpercentage then
					s:diffusealpha(1)
					alreadyfadedpercentage = false
					s:queuecommand("CheckForTime")
				end
			end,

				Def.BitmapText {
					Condition = GAMESTATE:GetPlayMode() ~= "PlayMode_Endless",
					Font="_Plex Numbers 40px",
					InitCommand=function(self)
						self:shadowlength( stp and 2 or 0 )
						:xy(score_x_position,26):zoom(0.75)
						:diffuse(ColorLightTone(PlayerCompColor(pn))):diffusebottomedge(PlayerColor(pn)):maxwidth(SCREEN_WIDTH*0.2234375)
						:settext(PREFSMAN:GetPreference("PercentageScoring") and " 0.00%" or 0)
					end,
					JudgmentMessageCommand=function(self,p) if p.Player == pn then
						self:finishtweening():sleep(0.01):queuecommand("RedrawScore") end
					end,
					RedrawScoreCommand=function(self) self:settext(GetPlScore(pn)) end,
					OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end
				},

				Def.BitmapText {
					Condition = GAMESTATE:GetPlayMode() == "PlayMode_Endless",
					Font="_Plex Numbers 40px",
					InitCommand=function(self)
						self:shadowlength( stp and 2 or 0 ):xy(score_x_position,26):zoom(0.75)
						:diffuse(ColorLightTone(PlayerCompColor(pn))):diffusebottomedge(PlayerColor(pn))
						:maxwidth(SCREEN_WIDTH*0.2234375)
						:settext(PREFSMAN:GetPreference("PercentageScoring") and " 0.00%" or 0)
						:queuecommand("UpdateTimer")
					end,
					UpdateTimerCommand=function(self)
						local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( pn )
						self:finishtweening():settext( SecondsToMMSSMsMs( vStats:GetAliveSeconds() ) )
						:sleep(1/60):queuecommand("UpdateTimer")
					end,
					OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end
				}
		}
		

		t[#t+1] = Def.ActorFrame {
		OffCommand=function(self) self:sleep(0.15):decelerate(0.3):addy(-75) end,
			Def.ActorFrame {
				InitCommand=function(self) self:xy(life_x_position,SCREEN_TOP+28) end,
				OnCommand=function(self) self:addy(-75):sleep(barSleepIn):decelerate(0.5):addy(75) end,
				-- Quad
				Def.ActorFrame {
					["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
						SetCommand=function(self)
							local steps_data = GAMESTATE:GetCurrentSteps(pn)
							if GAMESTATE:GetCurrentSong() then
								if steps_data == nil then return end
								local st = steps_data:GetStepsType();
								local diff = steps_data:GetDifficulty();
								local cd = GetCustomDifficulty(st, diff);
								self:diffuse(CustomDifficultyToColor(cd)):diffuserightedge(ColorLightTone(CustomDifficultyToColor(cd))):diffusealpha(0.8);
							end
						end,
						
						Def.Quad {
							InitCommand=function(self)
								self:zoomto(62,56):diffuse(color("#8F8F8F")):diffusebottomedge(color("#E0E0E0"))
							end
						};
				};
				-- Number
				Def.BitmapText {
					Font="_Plex Numbers 40px",
					InitCommand=function(self) self:maxwidth(40/0.8):y(-2):zoom(0.8) end,
					OnCommand=function(self)
						self:playcommand("Set"):diffusealpha(0):sleep(barSleepIn+0.3):linear(0.3):diffusealpha(1)
					end,
					["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end,
					SetCommand=function(self)
						local steps_data = GAMESTATE:GetCurrentSteps(pn)
						if GAMESTATE:GetCurrentSong() and steps_data then
							self:settext(steps_data:GetMeter())
						end
					end
				};
			};
		};
	end;

return t;