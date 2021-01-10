-- Adapted from Simply Love; rm SL-specific calls, skinned for Lambda.
-- https://github.com/dguzek/Simply-Love-SM5/blob/master/BGAnimations/ScreenGameplay%20underlay/Shared/BPMDisplay.lua

local numPlayers = GAMESTATE:GetNumPlayersEnabled()
local numSides = GAMESTATE:GetNumSidesJoined()
local bDoubles = (numPlayers == 1 and numSides == 2)
local bUsingCenter1P = PREFSMAN:GetPreference('Center1Player')
local MusicRate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()


local function UpdateSingleBPM(self)

	-- BPM stuff first
	local bpmDisplay = self:GetChild("BPMDisplay")
	local pn = GAMESTATE:GetMasterPlayerNumber()
	local pState = GAMESTATE:GetPlayerState(pn)
	local songPosition = pState:GetSongPosition()

	-- then, MusicRate stuff
	local MusicRateDisplay = self:GetParent():GetChild("RatemodDisplay")
	local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
	local MusicRate = so:MusicRate()

	-- BPM Display
	local bpm = songPosition:GetCurBPS() * 60 * MusicRate
	bpmDisplay:settext( round(bpm) )

	-- MusicRate Display
	MusicRate = string.format("%.2f", MusicRate )
	MusicRateDisplay:settext( MusicRate ~= "1.00" and MusicRate.."x rate" or "" )
end

local t = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_screen.cx, SCREEN_BOTTOM-50):valign(1)
	end,
	OnCommand=function(self)
		self:diffusealpha(0):sleep(0.25):decelerate(0.9):diffusealpha(1);
		end;
	OffCommand=function(self)
		self:decelerate(0.9):diffusealpha(0);
		end;

	Def.BitmapText {
		Font="_Medium";
		Name="RatemodDisplay",
		Text=MusicRate ~= 1 and MusicRate.."x rate" or "",
		InitCommand=function(self) self:zoom(0.6):y(30) end;
		OnCommand=function(self)
			self:diffuse(color("#FFFFFF"));
		end;
	}
}


-- in CourseMode, both players should always be playing the same charts, right?
if numPlayers == 1 or GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self) self:SetUpdateFunction(UpdateSingleBPM) end;
		Def.BitmapText {
			Font="_plex sans condensed score 32px";
			Name="BPMDisplay",
			InitCommand=function(self) self:zoom(1) end;
			OnCommand=function(self)
				self:diffuse(color("#FFFFFF")):diffusetopedge(color("#DCE7FB")):strokecolor(color("#101E4B")):shadowlength(1)
			end;
		}
	}
else
	-- check if both players are playing the same steps
	local stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
	local stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)

	local stP1 = stepsP1:GetStepsType()
	local stP2 = stepsP2:GetStepsType()

	local diffP1 = stepsP1:GetDifficulty()
	local diffP2 = stepsP2:GetDifficulty()

	-- get timing data...
	local timingP1 = stepsP1:GetTimingData()
	local timingP2 = stepsP2:GetTimingData()

	if timingP1 == timingP2 then
		-- both players are steps with the same TimingData; only need one.
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self) self:SetUpdateFunction(UpdateSingleBPM) end;
	
			Def.BitmapText {
				Font="_plex sans condensed score 32px";
				Name="BPMDisplay",
				OnCommand=function(self)
					self:diffuse(color("#FFFFFF")):diffusetopedge(color("#DCE7FB")):strokecolor(color("#101E4B")):shadowlength(1)
				end;
			}
		}
		return t
	end

	-- otherwise, we have some more work to do.

	local function Update2PBPM(self)
		local dispP1 = self:GetChild("DisplayP1")
		local dispP2 = self:GetChild("DisplayP2")

		local MusicRateDisplay = self:GetParent():GetChild("RatemodDisplay")
		local so = GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
		local MusicRate = so:MusicRate()

		-- needs current bpm for p1 and p2
		for pn in ivalues(PlayerNumber) do
			local bpmDisplay = (pn == PLAYER_1) and dispP1 or dispP2
			local pState = GAMESTATE:GetPlayerState(pn)
			local songPosition = pState:GetSongPosition()
			local bpm = songPosition:GetCurBPS() * 60 * MusicRate
			bpmDisplay:settext( round(bpm) )
		end

		MusicRate = string.format("%.2f", MusicRate )
		MusicRateDisplay:settext( MusicRate ~= "1.00" and MusicRate.."x rate" or "" )
	end

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self) self:SetUpdateFunction(Update2PBPM) end;		
		-- manual bpm displays
		Def.BitmapText {
			Font="_plex sans condensed score 32px",
			Name="DisplayP1",
			InitCommand=function(self) self:x(-60):zoom(1):shadowlength(1) end;
			OnCommand=function(self)
				self:diffuse(PlayerColor(PLAYER_1)):diffusebottomedge(PlayerCompColor(PLAYER_1)):strokecolor(ColorDarkTone((PlayerColor(PLAYER_1))))
			end;			
		},
		Def.BitmapText {
			Font="_plex sans condensed score 32px",
			Name="DisplayP2",
			InitCommand=function(self) self:x(60):zoom(1):shadowlength(1) end;
			OnCommand=function(self)
				self:diffuse(PlayerColor(PLAYER_2)):diffusebottomedge(PlayerCompColor(PLAYER_2)):strokecolor(ColorDarkTone((PlayerColor(PLAYER_2))))
			end;
		}
	}
end

return t
