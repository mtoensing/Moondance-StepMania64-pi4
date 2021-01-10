local t = Def.ActorFrame {}

------------------------
-- Begin TapNote Collection
local judgments,offsetdata,PauseTimeTable = {},{},{}

-- Begin by seting up the table with player values
for pla in ivalues(PlayerNumber) do
	judgments[pla] = {}
	offsetdata[pla] = {}
	-- Now fill by how many columns are available on the current style
	for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
		-- On each, 11 judgments will be inserted.
		judgments[pla][i] = { ProW1=0, ProW2=0, ProW3=0, ProW4=0, ProW5=0, W1=0, W2=0, W3=0, W4=0, W5=0, Miss=0 }
		-- Disabling Fantastic timing won't affect the table, as scores will go
		-- to W2 instead.
	end
	t[#t+1] = Def.Actor{
		PlayerHitPauseMessageCommand=function(self,params)
			if params.pn == pla then
				PauseTimeTable[#PauseTimeTable+1] = GAMESTATE:GetCurMusicSeconds()
			end
		end,
		OffCommand=function(self)
			local StgStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pla)
			local ClBurned = StgStats:GetCaloriesBurned()
			local PlProfile = PROFILEMAN:GetProfile(pla)
			local TargetOutput,Conversion

			local CalGoal=PlProfile:GetGoalCalories()
			local TimGoal=PlProfile:GetGoalSeconds()

			-- they have data, then convert values to reflect progress.
			if CalGoal>0 then
				Conversion = CalGoal - ClBurned
				setenv("TargetOutput"..pla, string.format( "%0.00f cal", Conversion) )
				if Conversion <= 0 then
					setenv("TargetOutput"..pla, '' )
					Conversion=0
					PlProfile:SetGoalType("GoalType_None")
					setenv("GoalAchieved"..pla, true)
				end
				PlProfile:SetGoalCalories(Conversion)
			end
			if TimGoal>0 then
				Conversion = TimGoal - StgStats:GetAliveSeconds()
				setenv("TargetOutput"..pla, SecondsToMMSS( Conversion ) )
				if Conversion > 3600 then
					setenv("TargetOutput"..pla, SecondsToHHMMSS( Conversion ) )
				end
				if Conversion <= 0 then
					setenv("TargetOutput"..pla, '' )
					Conversion=0
					PlProfile:SetGoalType("GoalType_None")
					setenv("GoalAchieved"..pla, true)
				end
				PlProfile:SetGoalSeconds(Conversion)
			end
		end
	}
end

t[#t+1] = Def.Actor{
	JudgmentMessageCommand=function(self, params)
		-- Do we have the player and their notes?
		if params.Player == params.Player and params.Notes then
			local p = params.Player
			-- Let´s check what column was just hit
			for i,col in pairs(params.Notes) do
				-- Alright, time to add it to the appropiate table.
				local tns = ToEnumShortString(params.TapNoteScore)
				if tns ~= "CheckpointHit" then
					judgments[p][i][tns] = judgments[p][i][tns] + 1
				end
			end
			if params.TapNoteOffset and params.TapNoteScore ~= "TapNoteScore_CheckpointHit" and params.TapNoteScore ~= "TapNoteScore_CheckpointMiss" then
				local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( p )
				local time = GAMESTATE:IsCourseMode() and vStats:GetAliveSeconds() or GAMESTATE:GetCurMusicSeconds()
				local noff = params.TapNoteScore == "TapNoteScore_Miss" and "Miss" or params.TapNoteOffset
				offsetdata[p][#offsetdata[p]+1] = { time, noff, params.TapNoteScore }
			end
		end
	end,
	OffCommand=function(self)
		-- Song has finished, and now we need to save the table somewhere
		-- so we can use it outside of gameplay.
		setenv( "perColJudgeData", judgments )
		setenv( "PTTable", PauseTimeTable )
		setenv( "OffsetTable", offsetdata )
	end
}

------------------------	
-- End TapNote Collection
return t