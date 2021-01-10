local isUltraWide = SCREEN_WIDTH > 1280
local t = Def.ActorFrame {
	InitCommand=function(s)
		s:x( isUltraWide and SCREEN_CENTER_X-638 or 0 )
	end,
};
local function baseQuadWidth()
	return IsWidescreen() and scale( SCREEN_WIDTH, 1151, 1280, 500, 614) or 200
end;
local artistStripeHeight=48
local playerStripeHeight=56
local function p2paneoffset()
	return IsWidescreen() and ( isUltraWide and 331 or scale( SCREEN_WIDTH, 1151, 1280, 267, 331)) or 270.5
end;
local switchtosmall1610 = SCREEN_WIDTH >= 1152
local peak,npst

local function WidescreenWidthMax( min, max )
	return SCREEN_WIDTH <= 1280 and scale( SCREEN_WIDTH, 1152, 1280, min, max ) or max
end

local function PercentScore(pn)
	local t = Def.BitmapText {
		Font="_Medium";
		InitCommand=function(self) self:horizalign(left):zoom(1) end;
		BeginCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail;
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
			end;

			local profile, scorelist;
			local text = "";
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType();
				local diff = StepsOrTrail:GetDifficulty();
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
				local cd = GetCustomDifficulty(st, diff, courseType);

				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					profile = PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile();
				end;

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist)
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					text = string.format("%.2f%%", topscore:GetPercentDP()*100.0);
					-- 100% hack
					if text == "100.00%" then
						text = "100%";
					end;
				else
					text = string.format("%.2f%%", 0);
				end;
			else
				text = "";
			end;
			self:settext(text);
		end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
	end

	return t;
end

local maxnps = { ["PlayerNumber_P1"] = 0, ["PlayerNumber_P2"] = 0 }
for pn in ivalues(PlayerNumber) do
local paneloffset = string.find(pn, "P1") and 0 or p2paneoffset();
-- Backdrop
t[#t+1] = Def.ActorFrame {
	OffCommand=function(self) self:sleep(0.24):decelerate(0.4):diffusealpha(0) end;
	Def.Quad {
		InitCommand=function(self)
			self:align(0,0)
			self:x(paneloffset):y(63+206+artistStripeHeight)
			self:zoomto(p2paneoffset(),408-artistStripeHeight):diffuse(color("0,0,0,0"))
		end;
		OnCommand=function(self)
			if GAMESTATE:IsHumanPlayer(pn) == true then
				self:smooth(0.2):diffuse(color("0,0,0,0.5"));
			else
				self:diffusealpha(0):smooth(0.2):diffuse(PlayerDarkColor(pn)):diffusealpha(0.2)
			end;
		end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:smooth(0.2):diffuse(color("0,0,0,0.5"));
			end;
		end;
	};
	-- Difficilty pane
	Def.ActorFrame {
			InitCommand=function(self) self:x(paneloffset) end,
			OnCommand=function(self) self:visible( GAMESTATE:IsHumanPlayer(pn) ) end,
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:visible(true):diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1);
				end
			end,
		Def.Quad {
			InitCommand=function(self)
				self:align(0,0):x(0):y(63+206+artistStripeHeight):zoomto(p2paneoffset(),408-artistStripeHeight):diffuse(color("0,0,0,0"))
			end,
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end,
			SetCommand=function(self)
				local stepsData = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					if stepsData ~= nil then
						local st = stepsData:GetStepsType();
						local diff = stepsData:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:finishtweening():linear(0.2)
						self:diffuse(ColorMidTone(CustomDifficultyToColor(cd))):diffuseleftedge(BoostColor(ColorMidTone(CustomDifficultyToColor(cd)),1.2)):diffusealpha(0.5);
					else
					end
				else
				end
			end
		};
		-- Difficulty underlay
		Def.Quad {
			InitCommand=function(self)
				self:align(0,0):x(0):y(269+artistStripeHeight+playerStripeHeight):zoomto(p2paneoffset(),90)
			end;
			OnCommand=function(self) self:diffuse(color("0,0,0,0.25")):fadebottom(1) end;
		};
		-- Difficulty name
		Def.BitmapText {
		  Font="_Bold";
		  InitCommand=function(self)
			self:zoom(1):y(380+20):x(20):maxwidth(180):horizalign(left)
		  end;
		  OnCommand=function(self)
			self:diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end;
			  PlayerJoinedMessageCommand=function(self,param)
					if param.Player == pn then
						self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(1)
					end;
				end;
			  SetCommand=function(self)
				local stepsData = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong();
				self:settext("")
				if song and stepsData ~= nil then
					local diff = stepsData:GetDifficulty();
						if stepsData:IsAnEdit() then
							self:settext(ToUpper(stepsData:GetChartName()))
						else
							self:settext(ToUpper(THEME:GetString("CustomDifficulty",ToEnumShortString(diff))))
						end;
					self:diffuse(color("#FFFFFF"));
				end
			  end
		};
-- Style
		Def.BitmapText {
		  Font="_Condensed Medium";
		  InitCommand=function(self)
			self:zoom(0.75):y(380+40):x(20):maxwidth(180):horizalign(left)
		  end;
		  OnCommand=function(self)
			self:diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end;
			  PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(1)
				end;
			  end;
			  SetCommand=function(self)
				local stepsData = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong();
				self:settext("")
				if song and stepsData ~= nil then
					local st = stepsData:GetStepsType();
					local diff = stepsData:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
					local cd = GetCustomDifficulty(st, diff, courseType);
					self:settext( ToUpper(THEME:GetString("StepsType",ToEnumShortString(st))) );
					self:diffuse(color("#FFFFFF"));
				end
			  end
		};
		-- Difficulty number
		Def.BitmapText {
		  Font="_Plex Numbers 60px";
		  InitCommand=function(self)
			self:zoom(0.75):y(391+22):maxwidth(180):horizalign(right)
			self:x( p2paneoffset()-16 )
		  end;
		  OnCommand=function(self)
			self:queuecommand("Set"):diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end;
			  PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:queuecommand("Set"):diffusealpha(0):sleep(0.2):smooth(0.3):diffusealpha(1)
				end;
			  end;
			  SetCommand=function(self)
				local stepsData = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong();
				self:settext("")
				if song and stepsData ~= nil then
					local meter = stepsData:GetMeter()
					self:settext(meter)
					self:diffuse(color("#FFFFFF"));
				end
			  end
		};
		Def.BitmapText {
		  Font="_Condensed Medium";
		  InitCommand=function(self)
			self:zoom(0.8):y(445):horizalign(right)
			if IsWidescreen() == true then
				self:maxwidth( scale( SCREEN_WIDTH, 1151, 1280, 309, 389 ) )
			else
				self:maxwidth(310)
			end;
			self:x( p2paneoffset()-16 )
		  end;
		  OnCommand=function(self)
			self:diffusealpha(0):sleep(0.2):smooth(0.2):diffusealpha(0.75)
		  end;
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end;
			  PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(0.75)
				end;
			  end;
			  SetCommand=function(self)
				local stepsData = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong();
				self:settext("")
				if song and stepsData ~= nil then
					local stepauthor = stepsData:GetAuthorCredit()
					if stepauthor ~= "" then
						self:settext(stepauthor):diffusealpha(1)
						else
						self:settext(THEME:GetString("ScreenSelectMusic","NoAuthor")):diffusealpha(0.4)
					end
				end
			  end
		};
	};
};

------- Heading
t[#t+1] = Def.ActorFrame {
	OffCommand=function(self) self:sleep(0.24):decelerate(0.4):diffusealpha(0) end,
	InitCommand=function(self)
		self:align(0,0):x(paneloffset):y(63+206+artistStripeHeight):visible(GAMESTATE:IsHumanPlayer(pn))
	end,
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true):diffusealpha(0):addy(300):decelerate(0.4):diffusealpha(1):sleep(0.2):smooth(0.75):addy(-300)
		end
	end,
	Def.Quad {
		InitCommand=function(self)
			self:align(0,0):zoomto(p2paneoffset(),playerStripeHeight)
		end,
		OnCommand=function(self)
			self:diffuse(PlayerColor(pn)):diffuserightedge(PlayerCompColor(pn))
		end
	},
	Def.Quad {
		InitCommand=function(self) self:align(0,0):zoomto(48,48):xy(6,4) end,
		OnCommand=function(self)
			self:diffuse(ColorDarkTone(PlayerColor(pn)))
		end
	},
	-- Profile picture?
	Def.Sprite {
		InitCommand=function(self) self:align(0,0):xy(6,4) end,
		Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
		OnCommand=function(self)
			self:zoomto(48,48)
		end
	},

	-- Profile name
	Def.BitmapText {
		Font="_Bold";
		InitCommand=function(self)
			self:align(0,0):addx(60):addy(22):zoom(1):maxwidth(IsWidescreen() and 220 or 150):skewx(-0.15):queuecommand("Set")
		end;
		OnCommand=function(self) self:diffuse(ColorDarkTone(PlayerDarkColor(pn))) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:queuecommand("Set")
			end
		end,
		SetCommand=function(self)
			self:settext(LoadModule("Options.GetProfileData.lua")(pn)["Name"])
		end
	}
}

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:align(0,0):x(paneloffset):y(63+210+artistStripeHeight):visible(GAMESTATE:IsHumanPlayer(pn))
	end;
	OffCommand=function(self) self:sleep(0.24):decelerate(0.4):diffusealpha(0) end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true):diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1);
		end;
	end;
	Def.Quad {
		InitCommand=function(self)
			self:align(0,0):xy(-1,IsWidescreen() and 240 or 235):zoomto(p2paneoffset(),120)
		end;
		OnCommand=function(self) self:diffuse(Color.Black):diffusealpha(0.3) end;
	};
	LoadActor(THEME:GetPathG("PaneDisplay","Text"),pn).. {
		InitCommand=function(self)
			self:x(switchtosmall1610 and WidescreenWidthMax( 104, 127 ) or 100):y(167)
			:zoom(switchtosmall1610 and WidescreenWidthMax( 0.8, 0.95 ) or 0.86)
		end;
	};
	-- High score
	Def.ActorFrame {
	InitCommand=function(self) self:diffusealpha(0):sleep(0.96):linear(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:finishtweening():linear(0.1):diffusealpha(0) end;
	["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(s)
		if GAMESTATE:GetCurrentSong() then
			s:finishtweening():linear(0.2):diffusealpha(1):sleep(2):queuecommand("ShowAMV")
		end
	end,
	ShowAMVCommand=function(s) s:finishtweening():linear(0.2):diffusealpha(0) end,
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self) self:horizalign(left):xy(25,254):zoom(0.65):diffuse(color("0.9,0.9,0.9")):shadowlength(1)  end;
			Text=ToUpper(THEME:GetString("ScreenSelectMusic","HighScore") .. ":");
		};
		StandardDecorationFromTable("PercentScore"..ToEnumShortString(pn), PercentScore(pn)) .. {
			InitCommand=function(self) self:xy(25,274):maxwidth(160):zoom(0.8) end;
		};
		Def.Sprite	{
			InitCommand=function(self) self:xy(68,300):zoom(0.35) end;
			OnCommand=function(self) self:playcommand("Set") end;
			["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(self) self:playcommand("Set") end,
			CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
			PlayerJoinedMessageCommand=function(self) self:playcommand("Set") end,
			ChangedLanguageDisplayMessageCommand=function(self) self:playcommand("Set") end,
			SetCommand=function(self)
				local steps = GAMESTATE:GetCurrentSteps(pn)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					if steps ~= nil then
						local score = PROFILEMAN:GetProfile(pn):GetHighScoreList(song,steps):GetHighScores()
						local getscore = score[1]
						if getscore then
							showscore = getscore:GetGrade()
							if showscore ~= nil then
								self:Load(THEME:GetPathG("GradeDisplay Grade", showscore))
								self:visible(true)
							else
								self:visible(false)
							end
						else
							self:visible(false)
						end
					end
				end
			end;
		};
	};

	Def.ActorFrame{
		["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(s)
			if GAMESTATE:GetCurrentSong() then
				s:finishtweening():linear(0.2):diffusealpha(0):sleep(2):queuecommand("ShowAMV")
			end
		end,
		OffCommand=function(s) s:finishtweening() end,
		ShowAMVCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		LoadActor("NPSDiagram.lua",{pn,p2paneoffset()}),
	}
};

-- Graph generator for the Profile Manager
local GraphData = {
    Contents = {
		-- Might update values for Complex and Flow, since those radar values
		-- are easily exploitable.
        {"Complexity", {"Chaos","Voltage","Stream"} },
        { switchtosmall1610 and "Jumps/Hands" or "J/H", {"Jumps","Hands"} },
        {"Flow", {"Stream","Voltage","Air"} },
    },
	ValMax = 55,
	Width = SCREEN_WIDTH >= 1280 and 40 or 30,
	Spacing = SCREEN_WIDTH >= 1280 and 70 or 50,
	TxSpc = switchtosmall1610 and 160 or 100,
};


t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:align(0,0)
		:x( paneloffset+160 )
		:y(63+210+artistStripeHeight+250):visible(GAMESTATE:IsHumanPlayer(pn))
	end;
	OnCommand=function(self) self:diffusealpha(0):sleep(0.96):linear(0.2):diffusealpha(1) end;
	OffCommand=function(self) self:linear(0.1):diffusealpha(0) end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true):diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1);
		end;
	end;
};

for Index,GraphCont in ipairs(GraphData.Contents) do
    t[#t+1] = Def.ActorFrame{
		["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(s)
			if GAMESTATE:GetCurrentSong() then
				s:finishtweening():linear(0.2):diffusealpha(1):sleep(2):queuecommand("ShowAMV")
			end
		end,
		InitCommand=function(self)
			self:horizalign(center):vertalign(middle)
			:x( (SCREEN_WIDTH > 1152 and paneloffset+80 or paneloffset+85) + GraphData.Spacing*Index )
			:y(SCREEN_CENTER_Y+285):visible(GAMESTATE:IsHumanPlayer(pn))
			self:diffusealpha(0):sleep(0.96):linear(0.2):diffusealpha(1)
		end;
		OffCommand=function(self) self:finishtweening():linear(0.1):diffusealpha(0) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:visible(true):diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1);
			end;
		end;
		ShowAMVCommand=function(s) s:linear(0.2):diffusealpha(0) end,
		Def.ActorMultiVertex{
			OnCommand=function(self)
				-- Set Triangle state
				self:SetDrawState{Mode="DrawMode_Triangles"}
				:diffusealpha(0):sleep(0.2):linear(0.1):diffusealpha(1)
			end;
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
			CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
			SetCommand=function(self)
				local verts = {
					{{-GraphData.Width/2, 0, 0}, Color.White},
					{{0, 0, 0}, Color.Blue},
					{{GraphData.Width/2, 0, 0}, Color.White},
				};

				if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
					local steps = GAMESTATE:GetCurrentSteps(pn)
					local StData = steps:GetRadarValues(pn)
					local Conv,StrConv = 0,"RadarCategory_"
					local st = steps:GetStepsType();
					local diff = steps:GetDifficulty();
					local cd = GetCustomDifficulty(st, diff, nil);

					for val in ivalues(GraphCont[2]) do
						-- Obtain both values
						Conv = Conv + StData:GetValue( StrConv..val )
					end

					-- Once obtained, divide them by 2.
					-- But first check if it isn't the total value of the 2nd table.
					if GraphCont[2][1] == "Jumps" then
						Conv = scale( Conv, 0, 400, 0, 4 )
					else
						Conv = Conv / #GraphCont[2]
					end

					Conv = scale( Conv, 0, 1, 0, 40 )

					-- Prevent Overflow.
					if Conv > GraphData.ValMax then
						Conv = GraphData.ValMax
						verts[1] = {{-GraphData.Width/2, 0, 0}, ColorLightTone(CustomDifficultyToColor(cd))}
						verts[3] = {{GraphData.Width/2, 0, 0}, ColorLightTone(CustomDifficultyToColor(cd))}
					end

					-- Transform Peak point to the new value.
					verts[2] = {{0, -Conv, 0}, ColorMidTone(CustomDifficultyToColor(cd))}
				end

				-- Transform vertices to the new position.
				self:stoptweening():decelerate(0.2):SetVertices(verts)
			end;
			OffCommand=function(self)
				self:linear(0.1):diffusealpha(0)
			end;
		};

		Def.Quad{
			OnCommand=function(self)
				self:zoomto( GraphData.Width*1.5, 1.5 )
			end;
		};

		Def.BitmapText{
			Font="_Condensed Medium";
			Text=ToUpper(GraphCont[1]);
			OnCommand=function(self)
				self:zoom(0.4):y(12):maxwidth( GraphData.TxSpc )
			end;
		};
	};
end

-- Show when not joined
t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:vertalign(middle):x(IsWidescreen() and ( isUltraWide and p2paneoffset()+160 or paneloffset+scale( SCREEN_WIDTH, 1152, 1280, 132, 168)) or paneloffset+136)
			:y(SCREEN_CENTER_Y+130):visible(not GAMESTATE:IsHumanPlayer(pn))
		end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:decelerate(0.3):diffusealpha(0)
				end;
			end;
		LoadActor(THEME:GetPathG("ScreenSelectMusic","JoinMarker")).. {
			InitCommand=function(self)
				self:diffuse(ColorMidTone(PlayerColor(pn)))
			end;
			OnCommand=function(self)
				self:diffusealpha(0):zoomy(0.6):sleep(1):decelerate(0.4):zoomy(1):diffusealpha(1)
				self:diffuseshift():effectcolor1(PlayerColor(pn)):effectcolor2(PlayerCompColor(pn)):effectperiod(4)
			end;
			OffCommand=function(self)
				self:stoptweening():stopeffect():decelerate(0.3):diffusealpha(0)
			end;
		};
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self) self:horizalign(center):maxwidth(200):diffuse(ColorLightTone(PlayerColor(pn))) end;
			OnCommand=function(self)
				self:diffusealpha(0):sleep(1.5):decelerate(0.4):diffusealpha(1)
				self:diffuseshift():effectcolor1(ColorLightTone(PlayerColor(pn))):effectcolor2(ColorLightTone(PlayerCompColor(pn))):effectperiod(4)
			end;
			OffCommand=function(self)
				self:stoptweening():stopeffect():decelerate(0.3):diffusealpha(0)
			end;
			Text=ToUpper(Screen.String("Start To Join"));
		};
	};

end;

return t;
