local t = Def.ActorFrame{}
local p = ...
local fade_out_speed = 0.2
local fade_out_pause = 0.1
local off_wait = 0.75
local CurPrefTiming = LoadModule("Options.OverwriteTiming.lua")()
local SelJudg = {2,4,5}

local eval_radar = {
	Types = { 'Holds', 'Rolls', 'Hands', 'Mines', 'Lifts' },
}

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

local eval_part_offs = string.find(p, "P1") and -310 or 310
local score_parts_offs = string.find(p, "P1") and -100 or 100

-- Step counts.
t[#t+1] = Def.BitmapText {
    Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1):xy(_screen.cx +(eval_part_offs),_screen.cy-165+70):maxwidth(260):horizalign(center)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
    end;
    OffCommand=function(self)
        self:linear(0.2):diffusealpha(0)
    end;
    Text=THEME:GetString("ScreenEvaluation","Statistics");
};


local Name,Length = LoadModule("Options.SmartTapNoteScore.lua")()
local DLW = LoadModule("Config.Load.lua")("DisableLowerWindows","Save/OutFoxPrefs.ini") or false
table.sort(Name)
Name[#Name+1] = "Miss"
Name[#Name+1] = "MaxCombo"
Length = Length + 2
for i,v in ipairs( Name ) do
	local Con = Def.ActorFrame{
		OffCommand=function(self)
			self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
		end,
		Def.BitmapText {
			Font = "_Bold",
			Text=GetJLineValue(v, p),
			InitCommand=function(self)
				self:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
	        	self:xy(SCREEN_CENTER_X+eval_part_offs+70,SCREEN_CENTER_Y-80+((44-(Length*2))*i)):halign(0):zoom(1.475-(Length*0.075)):halign(1)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(1)
				if DLW then
					for i=0,1 do
						if (v == 'W'..(5-i) and tonumber(DLW) >= (i+1)) then self:diffusealpha( 0.4 ) end
					end
				end
			end
		}
	}
	if v == "MaxCombo" or not LoadModule("Config.Load.lua")("JudgmentEval",CheckIfUserOrMachineProfile(string.sub(p,-1)-1).."/OutFoxPrefs.ini") then
		Con[#Con+1] = Def.BitmapText {
			Font = "_Bold",
			Text=ToUpper(THEME:GetString( CurPrefTiming or "Original" , "Judgment"..v )),
			InitCommand=function(self)
				self:diffuse(BoostColor((JudgmentLineToColor("JudgmentLine_" .. v)),1.3))
				self:xy(SCREEN_CENTER_X+(eval_part_offs-150),SCREEN_CENTER_Y-80+((44-(Length*2))*i)):zoom(1.475-(Length*0.075)):halign(0)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(0.86)
				if DLW then
					for i=0,1 do
						if (v == 'W'..(5-i) and tonumber(DLW) >= (i+1)) then self:diffusealpha( 0.4 ) end
					end
				end
			end
		}
	else
		Con[#Con+1] = Def.Sprite {
			Texture=LoadModule("Options.SmartJudgments.lua")()[LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),LoadModule("Config.Load.lua")("SmartJudgments",CheckIfUserOrMachineProfile(string.sub(p,-1)-1).."/OutFoxPrefs.ini"))],
			InitCommand=function(self)
				local int = i-1
				if self:GetNumStates() ~= 6 and self:GetNumStates() ~= 11 then int = 2*int end
    	    	self:xy(SCREEN_CENTER_X+(eval_part_offs-80),SCREEN_CENTER_Y-80+((44-(Length*2))*i)):zoom(1.275-(Length*0.075)):animate(0):setstate(int)
		    end,
			OnCommand=function(self)
				local sizemargin = 160
				local height = self:GetHeight()
				local width = self:GetWidth()
				if height >= sizemargin and width >= sizemargin then
					if height >= width then
						self:zoom(sizemargin/height)
					else
						self:zoom(sizemargin/width)
					end
				elseif height >= sizemargin then
					self:zoom(sizemargin/height)
				elseif width >= sizemargin then
					self:zoom(sizemargin/width)
				else 
					self:zoom(1)
				end
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.6):diffusealpha(0.86)
			end
		}
	end
	t[#t+1] = Con
end	
-- Other stats (holds, mines, etc.)
for i, rc_type in ipairs(eval_radar.Types) do
	local performance = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetRadarActual():GetValue( "RadarCategory_"..rc_type )
	local possible = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetRadarPossible():GetValue( "RadarCategory_"..rc_type )
	local label = THEME:GetString("RadarCategory", rc_type)
	local spacing = 46*i
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self) 	self:x(_screen.cx + eval_part_offs+90):y((_screen.cy-103)+(spacing)) end;
		OnCommand=function(self)
			self:diffusealpha(0):sleep(0.1 * i):decelerate(0.5):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
		end;
			-- Item name
			Def.BitmapText {
				Font = "_Bold",
				Text = ToUpper(label),
				InitCommand=function(self)
					self:zoom(0.7):horizalign(left):diffuse(color("#FFFFFF")):y(20):maxwidth(80)
				end;
			};
			-- Value
			Def.BitmapText {
			Font = "_Bold",
			InitCommand=function(self)
				self:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
				self:zoom(0.8):diffusealpha(1.0):shadowlength(1):maxwidth(80):horizalign(left)
			end;
			BeginCommand=function(self)
				self:settext(performance .. "/" .. possible)
			end
			};
	};
end;

-- Graphs
t[#t+1] = Def.GraphDisplay{
	InitCommand=function(self) self:vertalign(bottom):x(_screen.cx + (eval_part_offs)):y(_screen.cy+196+70) end;
	BeginCommand=function(self)
		self:Load("GraphDisplay"..ToEnumShortString(p))
		local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(p)
		local stageStats = STATSMAN:GetCurStageStats()
		self:Set(stageStats, playerStageStats)
		local Line = self:GetChild("Line")
		Line:visible(false)
	end,
	OnCommand=function(self)
		self:zoomy(0):sleep(1.2):decelerate(0.4):zoomy(1)
	end;
	OffCommand=function(self)
		self:sleep(fade_out_pause):decelerate(fade_out_speed):zoomy(0)
	end;
	PageUpdatedMessageCommand=function(self)
		local PageInd = getenv("PageIndex")
		self:finishtweening():decelerate(0.2):zoomy(0)
		:zoomy( PageInd[p] == 1 and 1 or 0 )
	end;
};

return t;
