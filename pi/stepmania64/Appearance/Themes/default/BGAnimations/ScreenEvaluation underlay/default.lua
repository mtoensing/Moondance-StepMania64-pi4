local t = Def.ActorFrame {};

local grade_area_offset = 16
local fade_out_speed = 0.2
local fade_out_pause = 0.1
local off_wait = 0.4
local EvalPages = 4
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage")

local PageInd = {
	["PlayerNumber_P1"] = 1,
	["PlayerNumber_P2"] = 1,
};
local ScrollLock = {
	["PlayerNumber_P1"] = false,
	["PlayerNumber_P2"] = false,
}
local stzoom = {
	["PlayerNumber_P1"] = 1,
	["PlayerNumber_P2"] = 1,
}
local stxscroll = {
	["PlayerNumber_P1"] = 2,
	["PlayerNumber_P2"] = 2,
}
local STmaxScroll = {
	["PlayerNumber_P1"] = 1,
	["PlayerNumber_P2"] = 1,
}

local ttb = getenv("PTTable")
local songend = GAMESTATE:GetCurrentSong():GetLastSecond()

--------------------------------------------------------------------------------
-- Input Handler
--------------------------------------------------------------------------------
local validzoommargins = {
	[1] = {1,1},
	[2] = {0,2},
	[3] = {-1,3},
	[4] = {-4,6},
	[5] = {-7,9},
	[6] = {-12,14},
	[7] = {-17,20},
	[8] = {-24,26},
	[9] = {-31,34},
	[10] = {-40,42},
}
local function CheckValueOffsets(pn,dedicatedmove)
	ScrollLock[pn] = stzoom[pn] > 1
	if PageInd[pn] > EvalPages then PageInd[pn] = EvalPages return end
	if PageInd[pn] < 1 then PageInd[pn] = 1 return end
	if stzoom[pn] < 1 then stzoom[pn] = 1 end
	if stzoom[pn] > 10 then stzoom[pn] = 10 end
	if stxscroll[pn] > validzoommargins[stzoom[pn]][2] then stxscroll[pn] = validzoommargins[stzoom[pn]][2] end
	if stxscroll[pn] < validzoommargins[stzoom[pn]][1] then stxscroll[pn] = validzoommargins[stzoom[pn]][1] end
	STmaxScroll[pn] = stzoom[pn]
	setenv("PageIndex", PageInd)
	setenv("APNow", pn)
	MESSAGEMAN:Broadcast("PageUpdated")
	if not dedicatedmove then
		MESSAGEMAN:Broadcast("ScatterZoom", {Player=pn, Zoom=stzoom[pn], Xpos=stxscroll[pn], MaxSegment=STmaxScroll[pn]} )
	end
	return
end

local function ChangeValOffset(item,player,val,dedicatedmove)
	item[player] = item[player] + val
	CheckValueOffsets(player,dedicatedmove)
	if dedicatedmove then
		MESSAGEMAN:Broadcast("ScatterMove", {Player=player, Zoom=stzoom[player], Xpos=stxscroll[player], MaxSegment=STmaxScroll[player]} )
	end
end

local function RangeValueToTable(val)
		local xposmargin = 320
		if val < 0 then return 0 end
		local finalresult = (val/songend)*xposmargin
		return tonumber( finalresult )
	end;

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
	if line == "Held" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetHoldNoteScores("HoldNoteScore_Held")
	elseif line == "MaxCombo" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):MaxCombo()
	else
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetTapNoteScores("TapNoteScore_" .. line)
	end
	return "???"
end

-- You know what, we'll deal with getting the overall scores with a function too.
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

-- #################################################
-- That's enough functions; let's get this done.

-- Shared portion.
local mid_pane = Def.ActorFrame {
	OnCommand=function(self) self:diffusealpha(0):sleep(0.3):decelerate(0.4):diffusealpha(1) end;
	OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end;
	-- Song/course banner.
	Def.ActorFrame {
	InitCommand=function(self) self:xy(_screen.cx,_screen.cy-26) end;
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(284,SCREEN_HEIGHT):diffuse(Color.Black):diffusealpha(0.4)
			end;
		},		
		Def.Quad {
			InitCommand=function(self)
				self:zoomto(280,320):y(24):diffuse(Color.Black):diffusealpha(0.75)
			end;
		},
		Def.Sprite {
			InitCommand=function(self)
				local target = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
				if GAMESTATE:IsCourseMode() then
					if target and target:HasBanner() then			
						self:LoadFromCached("banner",target:GetBannerPath()):scaletoclipped(256,80)
					else
						self:Load(THEME:GetPathG("Common fallback", "jacket")):scaletoclipped(256,256)
					end
				else
					if target and target:HasJacket() then
						self:LoadFromCached("jacket",target:GetJacketPath()):scaletoclipped(256,256)
					elseif target and target:HasBackground() then			
						self:LoadFromCached("background",target:GetBackgroundPath()):scaletoclipped(256,256)
					elseif target and target:HasBanner() then			
						self:LoadFromCached("banner",target:GetBannerPath()):scaletoclipped(256,80)
					else
						self:Load(THEME:GetPathG("Common fallback", "jacket")):scaletoclipped(256,256)
						
					end
				end
			end
		},
		Def.BitmapText {
			Font="SongTitle font",
			InitCommand=function(self)
				self:y(148-5):diffuse(color("#FFFFFF")):zoom(0.8):maxwidth(250/0.8)
			end;
			OnCommand=function(self)
				if not GAMESTATE:IsCourseMode() then
					local song = GAMESTATE:GetCurrentSong();
					if song then
						if song:GetDisplaySubTitle() ~= "" then
							self:addy(-9)
						end
						self:settext(nativeTitle and song:GetDisplayMainTitle() or song:GetTranslitMainTitle(), song:GetTranslitMainTitle() )
					end
				else
					self:settext( GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() )
				end
				self:diffusealpha(0):sleep(1.0):decelerate(0.4):diffusealpha(1)
			end;
			OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
		},
		Def.BitmapText {
			Font="SongSubTitle font",
			InitCommand=function(self)
				self:y(148+8-5):diffuse(color("#FFFFFF")):zoom(0.6):maxwidth(250/0.6)
			end;
			Text=GAMESTATE:IsCourseMode() and ""  or nativeTitle and GAMESTATE:GetCurrentSong():GetDisplaySubTitle() or GAMESTATE:GetCurrentSong():GetTranslitSubTitle();
			OnCommand=function(self)
				self:diffusealpha(0):sleep(1.0):decelerate(0.4):diffusealpha(1)
			end;
			OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
		},
		Def.BitmapText {
			Font="SongTitle font",
			Text=GAMESTATE:IsCourseMode() and ToEnumShortString( GAMESTATE:GetCurrentCourse():GetCourseType() ) or nativeTitle and GAMESTATE:GetCurrentSong():GetDisplayArtist() or GAMESTATE:GetCurrentSong():GetTranslitArtist();
			InitCommand=function(self)
				self:y(148+20-5):diffuse(color("#FFFFFF")):zoom(0.75):maxwidth(250/0.75)
			end;
			OnCommand=function(self)
				if not GAMESTATE:IsCourseMode() then
					local song = GAMESTATE:GetCurrentSong();
					if song then
						if song:GetDisplaySubTitle() ~= "" then
							self:addy(6)
						end;
					end
				end;
				self:diffusealpha(0):sleep(1.0):decelerate(0.4):diffusealpha(1)
			end;
			OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
		}				
	}
}

t[#t+1] = mid_pane

-- #################################################
-- Time to deal with all of the player stats. ALL OF THEM.

local eval_parts = Def.ActorFrame {}

for ip, p in ipairs(GAMESTATE:GetHumanPlayers()) do
	-- Some things to help positioning
	local eval_part_offs = string.find(p, "P1") and -310 or 310
	local score_parts_offs = string.find(p, "P1") and -100 or 100
	local panel_width = 336;
	local p_grade = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetGrade()
	--BG 
	eval_parts[#eval_parts+1] = Def.ActorFrame {
		-- Base
		Def.Quad {
			InitCommand=function(self)
				self:x(_screen.cx + eval_part_offs):y(_screen.cy):zoomto(panel_width,SCREEN_HEIGHT)
				self:diffuse(BoostColor(ColorDarkTone(PlayerColor(p)),0.4)):diffusealpha(0.6)
			end;
			OffCommand=function(self)
				self:sleep(off_wait+0.1):linear(0.2):addy(SCREEN_HEIGHT)
			end;
		};
		-- Navigation stripe
		Def.Quad {
			InitCommand=function(self)
				self:vertalign(top):x(_screen.cx + eval_part_offs):y(_screen.cy-114):zoomto(panel_width,40)
				self:diffuse(Color.Black):diffusealpha(0.6)
			end;
			OffCommand=function(self)
				self:linear(0.2):diffusealpha(0)
			end;
		};

		-- Score Stripe
		Def.Quad {
			InitCommand=function(self)
				self:vertalign(bottom):x(_screen.cx + eval_part_offs):y(_screen.cy-114):zoomto(panel_width,52)
				self:diffuse(ColorDarkTone(PlayerColor(p))):diffuserightedge(ColorDarkTone(PlayerCompColor(p))):diffusealpha(0.6)
			end;
			OnCommand=function(self)
				self:zoomto(panel_width,1):decelerate(0.5):zoomto(panel_width,52)
			end;
			OffCommand=function(self)
				self:linear(0.2):diffusealpha(0)
			end;
		};
				
		Def.BitmapText {
		Font = "_Condensed Medium",
		InitCommand=function(self)
			self:zoom(0.6):xy(_screen.cx +(eval_part_offs)-160,_screen.cy+134-260):maxwidth(220):horizalign(left)
			self:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
		end;
		OnCommand=function(self)
			local record = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetPersonalHighScoreIndex()
			local hasPersonalRecord = record ~= -1
			self:visible(hasPersonalRecord);
			local text = string.format(THEME:GetString("ScreenEvaluation", "PersonalRecord"), record+1)
			self:settext(text):diffusealpha(0):sleep(0.9):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			 self:decelerate(0.3):diffusealpha(0)
		end;
		},

		-- FC?
		Def.ActorFrame {
		InitCommand=function(self) self:vertalign(top):x(_screen.cx + eval_part_offs):y(SCREEN_TOP) end;
		OffCommand=function(self) self:decelerate(0.2):diffusealpha(0) end;
		OnCommand=function(self)
			local ColorGradients = {
				color("#A0DBF1"),
				color("#F1E4A2"),
				color("#ABE39B")
			},

			self:diffusealpha(0)
			for i,d in ipairs(ColorGradients) do
				local grade = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):FullComboOfScore('TapNoteScore_W'..i)
				if grade then self:diffuse( d ) end
			end;
		end;
			Def.Quad {
				InitCommand=function(self) self:vertalign(top):horizalign(left):xy(panel_width/(-2),0):zoomto(40,193):diffuse(Color.White):faderight(1) end;
				OnCommand=function(self) self:diffusealpha(0):sleep(0.5):accelerate(0.5):diffusealpha(0.4) end;
			};			
			Def.Quad {
				InitCommand=function(self) self:vertalign(top):horizalign(right):xy(panel_width/2,0):zoomto(40,193):diffuse(Color.White):fadeleft(1) end;
				OnCommand=function(self) self:diffusealpha(0):sleep(0.5):accelerate(0.5):diffusealpha(0.4) end;
			};
		};
	};

	for i=1,2 do
		local function side(val,n)
			if n == 2 then return val*-1 end
			return val
		end;

		local stdx = _screen.cx +(eval_part_offs+side(150,i))

		eval_parts[#eval_parts+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
					self:zoom(1):xy(stdx,_screen.cy-165+70)
					:rotationz( side(90,i)+90 )
					:diffuse( PlayerColor(p) )
			end;
			OffCommand=function(self)
					self:linear(0.2):diffusealpha(0)
			end;
			Text="&MENULEFT;",
			MouseLeftClickMessageCommand=function(s)
				local x = INPUTFILTER:GetMouseX()
				local y = INPUTFILTER:GetMouseY()		
				if (y > s:GetY()-(s:GetHeight()/2) and y < s:GetY()+(s:GetHeight()/2)) and (x > s:GetX()-(s:GetWidth()/2) and x < s:GetX()+(s:GetWidth()/2)) then
					ChangeValOffset( PageInd, p, i == 2 and -1 or 1 )
					s:playcommand("HighlightButton")
				end
			end,
			HighlightButtonCommand=function(s)
				s:zoom(1.1):diffuse(Color.White):linear(0.2):zoom(1):diffuse(PlayerColor(p))
			end,
		};
	end

	-- Summary bar, located on the opposite side of the play area.
	if not GAMESTATE:IsCourseMode() then
		eval_parts[#eval_parts+1] = loadfile( THEME:GetPathB("ScreenEvaluation","underlay/GameplaySummary.lua") )(p)..{
			Condition=GAMESTATE:GetNumPlayersEnabled() < 2,
			OnCommand=function(s)
				s:x( _screen.cx + (eval_part_offs*-1) )
			end,
		}
	end
	
	-- Page 1, Steps Information
	for i=1,EvalPages do
		eval_parts[#eval_parts+1] = LoadActor("Page"..i..".lua", p)..{
		OnCommand=function(self)
			local match = (PageInd[p] == i)
			self:diffusealpha( match and 1 or 0 )
		end;
		PageUpdatedMessageCommand=function(self,player)
			local match = (PageInd[p] == i)
			self:stoptweening():decelerate(fade_out_speed):diffusealpha( match and 1 or 0 )
		end;
		};
	end
	
	-- Letter grade and associated parts.
		
	eval_parts[#eval_parts+1] = Def.ActorFrame{
		InitCommand=function(self) self:xy(_screen.cx + eval_part_offs,_screen.cy-225) end;
		LoadActor(THEME:GetPathG("GradeDisplay", "Grade " .. p_grade)) .. {
			OnCommand=function(self)
			        self:diffusealpha(0):zoom(1.0):sleep(0.63):decelerate(0.4):zoom(0.8):diffusealpha(1)
					if STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetStageAward() then
					  self:sleep(0.1):decelerate(0.4):addy(-7);
					else
					 self:addy(0);
					end;
			end;
			OffCommand=function(self)
			    self:decelerate(0.3):diffusealpha(0)
			end;
		},

		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
				self:diffuse(BoostColor(ColorMidTone(PlayerColor(p)),2.7)):zoom(1):xy(0,40):maxwidth(250)
			end;
			OnCommand=function(self)
				if STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetStageAward() then
					self:settext(THEME:GetString( "StageAward", ToEnumShortString(STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetStageAward()) ))
					self:diffusealpha(0):sleep(1.2):decelerate(0.4):diffusealpha(1)
				end;
			end;
			OffCommand=function(self)
			    self:decelerate(0.3):diffusealpha(0)
			end;		
		},
	}
	-- Difficulty
	if GAMESTATE:IsCourseMode() ~= true then
			eval_parts[#eval_parts+1] = Def.ActorFrame{
			InitCommand=function(self)
				self:vertalign(top):x(_screen.cx + eval_part_offs):y(SCREEN_CENTER_Y-276):visible(not GAMESTATE:IsCourseMode())
			end;
			OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
			["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) MESSAGEMAN:Broadcast("Set") end;

			  Def.Quad {
			  	InitCommand=function(self) self:zoomto(336,24):vertalign(bottom) end;
				OnCommand=function(self) self:playcommand("Set"):zoomto(336,1):decelerate(0.5):zoomto(336,24) end;
				["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
				SetCommand=function(self)
				local steps_data = GAMESTATE:GetCurrentSteps(p)
				local song = GAMESTATE:GetCurrentSong();
				  if song and steps_data ~= nil then
					local st = steps_data:GetStepsType();
					local diff = steps_data:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
					local cd = GetCustomDifficulty(st, diff, courseType);
					self:diffuse(ColorDarkTone(CustomDifficultyToColor(cd)));
				  end
				end
			  };
			  Def.Sprite {
				InitCommand=function(self) self:halign(0):x(-155):y(-11) end;
				OnCommand=function(self) self:queuecommand("Set"):diffusealpha(0):sleep(0.5):decelerate(0.4):diffusealpha(0.75) end; 
				SetCommand=function(self)
					local stepsData = GAMESTATE:GetCurrentSteps(p)
					local song = GAMESTATE:GetCurrentSong();
					if song and stepsData ~= nil then
						local st = stepsData:GetStepsType();
						local diff = stepsData:GetDifficulty();
						local path = THEME:GetPathG("","_StepsType/" .. ToEnumShortString(st) .. ".png") 
						local missing = self:Load( THEME:GetPathG("","_StepsType/missing") )
						self:Load( FILEMAN:DoesFileExist(path) and path or missing  ):zoom(1.0)
					end
				end
			 };
		Def.BitmapText {
				Font="_Bold";
				InitCommand=function(self) self:zoom(0.75):horizalign(left):x(-110):y(-10):diffuse(Color.White):maxwidth(200) end;
					OnCommand=function(self) self:playcommand("Set"):diffusealpha(0):sleep(0.5):decelerate(0.4):diffusealpha(1) end;
					["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
					SetCommand=function(self)
					local steps_data = GAMESTATE:GetCurrentSteps(p)
					local song = GAMESTATE:GetCurrentSong();
					if song and steps_data ~= nil then
						local diff = steps_data:GetDifficulty();
						self:settext( ToUpper(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)) .. "  " .. steps_data:GetMeter()) )
					  	end
					end
				};		
			  
				Def.BitmapText {
					Font="_Medium";
					InitCommand=function(self) self:zoom(0.75):horizalign(right):x(158):y(-10):diffuse(Color.White):maxwidth(200):diffusealpha(1) end;
					OnCommand=function(self) self:playcommand("Set") end;
					["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
					SetCommand=function(self)
					local steps_data = GAMESTATE:GetCurrentSteps(p)
					local song = GAMESTATE:GetCurrentSong();
						if song and steps_data ~= nil then
						  local stepauthor = steps_data:GetAuthorCredit()
							if stepauthor ~= "" then
								self:settext(stepauthor):diffusealpha(0):sleep(0.7):decelerate(0.4):diffusealpha(1)
							else
								self:settext(THEME:GetString("ScreenSelectMusic","NoAuthor")):diffusealpha(0):sleep(0.7):decelerate(0.4):diffusealpha(0.4)
							end
						end
					end
				};
			};
		else
		eval_parts[#eval_parts+1] = Def.ActorFrame{
			InitCommand=function(self)
				self:vertalign(top):x(_screen.cx + eval_part_offs):y(SCREEN_CENTER_Y-276)
			end;
			OffCommand=function(self) self:decelerate(0.4):diffusealpha(0) end;
			["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) MESSAGEMAN:Broadcast("Set") end;
			  Def.Quad {
			  	InitCommand=function(self) self:zoomto(336,24):vertalign(bottom) end;
				OnCommand=function(self) self:playcommand("Set"):zoomto(336,1):decelerate(0.5):zoomto(336,24) end;
				["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
				SetCommand=function(self)
				local course = GAMESTATE:GetCurrentCourse();
				local steps_data = GAMESTATE:GetCurrentTrail(p);
				  if course and steps_data ~= nil then
					  local st = steps_data:GetStepsType();
					  local diff = steps_data:GetDifficulty();
					  local courseType = course:GetCourseType();
					  local cd = GetCustomDifficulty(st, diff, courseType);
					  self:diffuse(ColorDarkTone(CustomDifficultyToColor(cd)));
				  end
				end
			  };
				Def.BitmapText {
					Font="_Medium";
					InitCommand=function(self) self:zoom(0.75):horizalign(left):x(-160):y(-11):diffuse(Color.White):maxwidth(200) end;
					OnCommand=function(self) self:playcommand("Set"):diffusealpha(0):sleep(0.5):decelerate(0.4):diffusealpha(1) end;
					["CurrentSteps"..ToEnumShortString(p).."ChangedMessageCommand"]=function(self) self:playcommand("Set") end;
					SetCommand=function(self)
					local course = GAMESTATE:GetCurrentCourse();
					local steps_data = GAMESTATE:GetCurrentTrail(p);
					if course and steps_data ~= nil then
						  local st = steps_data:GetStepsType();
						  local diff = steps_data:GetDifficulty();
						  local courseType = course:GetCourseType();
						  local cd = GetCustomDifficulty(st, diff, courseType);
						  self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)));
					  end
					end
				};	
			};
		end;
	-- Primary score.
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "_Plex Numbers 40px",
		InitCommand=function(self)
			self:horizalign(right):x(_screen.cx + (eval_part_offs+160)):y((_screen.cy+116-256)):zoom(1):shadowlength(1):maxwidth(140)
			self:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
		end;
		OnCommand=function(self)
			self:settext(GetPlScore(p, "primary")):diffusealpha(0):sleep(0.8):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:decelerate(0.3):diffusealpha(0)
		end;
	}
	-- Secondary score.
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "_Plex Numbers 40px",
		InitCommand=function(self)
			self:horizalign(left):x(_screen.cx + (eval_part_offs)-160):y(_screen.cy+108-258):zoom(0.75):shadowlength(1):maxwidth(180)
			self:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
		end;
		OnCommand=function(self)
			local record = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetPersonalHighScoreIndex()
			local hasPersonalRecord = record ~= -1
			if hasPersonalRecord == false then
				self:addy(10)
			end;
			self:settext(GetPlScore(p, "secondary")):diffusealpha(0):sleep(0.85):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:sleep(0.1):decelerate(0.3):diffusealpha(0)
		end;
	};

	for ind,val in ipairs(ttb) do
		eval_parts[#eval_parts+1] = Def.Quad{
			InitCommand=function(self)
				self:y(_screen.cy+196+70):vertalign(bottom)
				self:x( _screen.cx + (eval_part_offs-164) + RangeValueToTable(val) ):zoomto(2,80):diffuse( Color.Purple )
				:fadetop(0.2)
			end;
			OnCommand=function(self)
				self:zoomy(0):sleep(1.2):decelerate(0.4):zoomy(80)
			end;
			OffCommand=function(self)
				self:sleep(fade_out_pause):decelerate(fade_out_speed):zoomy(0)
			end;
			PageUpdatedMessageCommand=function(self)
				local PageInd = getenv("PageIndex")
				print( p.." - "..PageInd[p] )
				self:finishtweening():decelerate(0.2):zoomy(0)
				:zoomy( PageInd[p] < 3 and 80 or 0 )
			end;
			ScatterZoomMessageCommand=function(s,param)
				if param.Player == p then
					s:zoomy( (getenv("PageIndex")[p] < 3 and param.Zoom == 1) and 80 or 0 )
				end
			end
		};
	end;

	eval_parts[#eval_parts+1] = Def.ComboGraph{
		InitCommand=function(self) self:vertalign(bottom):x(_screen.cx + (eval_part_offs)):y(_screen.cy+196+88) end;
		BeginCommand=function(self)
			self:Load("ComboGraph"..ToEnumShortString(p))
			local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(p)
			local stageStats = STATSMAN:GetCurStageStats()
			self:Set(stageStats, playerStageStats)
		end,
		OnCommand=function(self)
			self:diffusealpha(0):sleep(1.2):decelerate(0.4):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
		end;
	};

	-- Options
	eval_parts[#eval_parts+1] = Def.BitmapText {
		Font = "_Medium",
		InitCommand=function(self)
			self:vertalign(bottom):x(_screen.cx + (eval_part_offs)):y(_screen.cy+196+106):wrapwidthpixels(630)
			self:diffuse(Color.White):zoom(0.7):shadowlength(2)
		end;
		OnCommand=function(self)
			self:settext(GAMESTATE:GetPlayerState(p):GetPlayerOptionsString(0))
			self:diffusealpha(0):sleep(0.8):decelerate(0.6):diffusealpha(1)
			end;
		OffCommand=function(self)
			self:sleep(0.1):decelerate(0.3):diffusealpha(0)
		end;
		};
end

t[#t+1] = eval_parts;

if #ttb > 0 then
	t[#t+1]= Def.ActorFrame {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-200) end;
		OnCommand=function(self)
			self:diffusealpha(0):sleep(0.8):decelerate(0.6):diffusealpha(1)
		end;
		OffCommand=function(self) self:sleep(0.1):decelerate(0.3):diffusealpha(0) end;
		Def.Quad {
			InitCommand=function(self) 
				self:zoomto(150,36):diffuse(color("#a50909"))
			end;
		};
		Def.BitmapText{
			Font= "_Condensed Medium",
			Text= THEME:GetString("PauseMenu", "pause_count") .. ": " .. #ttb,
			InitCommand=function(self) 
				self:shadowlength(1):maxwidth(160)
				self:diffuse(Color.White):zoom(0.8)
			end;
		}
	}
end

t[#t+1] = StandardDecorationFromFileOptional("LifeDifficulty","LifeDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("TimingDifficulty","TimingDifficulty");

t[#t+1] = Def.Sound{
	File=THEME:GetPathS("","click");
	IsAction=true;
	SupportPan=true;
	PageUpdatedMessageCommand=function(self)
		if getenv("APNow") and stzoom[getenv("APNow")] == 1 then
			self:playforplayer( getenv("APNow") )
		end
	end;
};

if LoadModule("Config.Load.lua")("AllowAudioInEvaluation","Save/OutFoxPrefs.ini") then
	t[#t+1] = Def.Sound{
		IsAction = true;
		File=GAMESTATE:GetCurrentSong():GetMusicPath();
		OnCommand=function(self)
			local audio = self:get()
			audio:volume(0.05)
			self:play()
		end;
		OffCommand=function(self)
			self:stop()
		end;
	};
end;

local BTInput = {
	-- This will control the menus
	["MenuRight"] = function(PlEv) ChangeValOffset( not ScrollLock[PlEv] and PageInd or stxscroll, PlEv, 1, true ) end,
	["MenuLeft"] = function(PlEv) ChangeValOffset( not ScrollLock[PlEv] and PageInd or stxscroll, PlEv, -1, true ) end,
	["MenuUp"] = function(PlEv) if PageInd[PlEv] == 2 then ChangeValOffset( stzoom, PlEv, 1 ) end end,
	["MenuDown"] = function(PlEv) if PageInd[PlEv] == 2 then ChangeValOffset( stzoom, PlEv, -1 ) end end
};

local function InputHandler(event)
	-- Safe check to input nothing if any value happens to be not a player.
	-- ( AI, or engine input )
	if not event.PlayerNumber then return end
	local ET = ToEnumShortString(event.type)
	-- Input that occurs at the moment the button is pressed.
	if ET == "FirstPress" or ET == "Repeat" then
			if GAMESTATE:IsHumanPlayer(event.PlayerNumber) and BTInput[event.GameButton] then
					BTInput[event.GameButton](event.PlayerNumber)
					MESSAGEMAN:Broadcast( event.GameButton.. ToEnumShortString(event.PlayerNumber) .."Pressed" )
			end
	end
end
-------------------------------------
-- Discord GameSDK
-------------------------------------

t[#t+1] = Def.ActorFrame{
	OnCommand = function(self)
		local player = GAMESTATE:GetMasterPlayerNumber()
		local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
		local StepOrTrails = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)
		if GAMESTATE:GetCurrentSong() then
			local details = GAMESTATE:IsCourseMode() and SongOrCourse:GetTranslitFullTitle() or (PREFSMAN:GetPreference("ShowNativeLanguage") and SongOrCourse:GetDisplayMainTitle() or SongOrCourse:GetTranslitFullTitle() .. " - " .. GAMESTATE:GetCurrentSong():GetGroupName())
			details = string.len(details) < 128 and details or string.sub(details, 1, 124) .. "..."
			local Difficulty = ToEnumShortString( StepOrTrails:GetDifficulty() ) .. " " .. StepOrTrails:GetMeter()
			local Percentage = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()
			local states = Difficulty .. " (".. string.format( "%.2f%%", Percentage*100) .. ")"
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
			GAMESTATE:UpdateDiscordScreenInfo(details,states,1)
		end
	end
}

--------------------------------------------------------------------------------
-- Input Controller
--------------------------------------------------------------------------------
local Controller = Def.ActorFrame{
	OnCommand=function(self)
	SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
};
t[#t+1] = Controller;

--------------------------------------------------------------------------------
-- Display SM version number
--------------------------------------------------------------------------------
t[#t+1] = Def.BitmapText {
	Font="_Medium",
	AltText="Unknown version",
	InitCommand=function(self) self:zoom(0.75):maxwidth(200/0.75):diffuse(color("#FFFFFF")):x(SCREEN_CENTER_X):y(SCREEN_BOTTOM-120) end,
	OnCommand=function(self) 
		self:settext(ProductVersion() .. " (" .. VersionDate() .. ")") 
		:diffusealpha(0):sleep(1.2):decelerate(0.3):diffusealpha(0.4)
	end,
	OffCommand=function(self) self:decelerate(0.3):diffusealpha(0) end
};
	
return t;