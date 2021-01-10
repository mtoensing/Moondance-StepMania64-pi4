--[[
    Most of this file from Simply Love (SM5):
    https://github.com/quietly-turning/Simply-Love-SM5/blob/1ebad20ef4399879939b5911ec3d9e933001087c/BGAnimations/ScreenGameplay%20underlay/PerPlayer/MeasureCounter.lua
    
	-impl'd into 5.3 by Rin (ry00001), 2020-
	Completely remade by Jose_Varela
]]

local player = ...
local NoteData = {}
local enabled = LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(player,-1)-1).."/OutFoxPrefs.ini")
local HideRestCounts = not LoadModule("Config.Load.lua")("MeasureCounterBreaks",CheckIfUserOrMachineProfile(string.sub(player,-1)-1).."/OutFoxPrefs.ini")

local streams, prev_measure
local current_count, stream_index, current_stream_length

local InitializeMeasureCounter = function()

	NoteData = {}

	local notes_per_measure = tonumber(LoadModule("Config.Load.lua")("MeasureCounterDivisions",CheckIfUserOrMachineProfile(string.sub(player,-1)-1).."/OutFoxPrefs.ini"))
	local threshold = 2
	if GAMESTATE:GetCurrentSong() then
		if GAMESTATE:Env()["ChartData"..player] then
			local data = GAMESTATE:Env()["ChartData"..player]
			if data[3] then
				local streams = LoadModule("Chart.GetStreamMeasure.lua")(data[3], 2, data[4])
				if streams then
					NoteData = streams
				end
			end
		end
	end

	current_count = 0
	stream_index = 1
	current_stream_length = 0
	prev_measure = 0
end

local GetTextForMeasure = function(self, current_measure, Measures, stream_index)
	-- Validate indices
	if Measures[stream_index] == nil then return "" end

	local streamStart = Measures[stream_index].streamStart
	local streamEnd = Measures[stream_index].streamEnd
	if current_measure < streamStart then return "" end
	if current_measure > streamEnd then return "" end

	local current_stream_length = streamEnd - streamStart
	local current_count = math.floor(current_measure - streamStart) + 1

	local text = ""
	if Measures[stream_index].isBreak then
		if HideRestCounts == false then
			-- NOTE: We let the lowest value be 0. This means that e.g.,
			-- for an 8 measure break, we will display the numbers 7 -> 0
			local measures_left = current_stream_length - current_count

			if measures_left >= (current_stream_length-1) or measures_left <= 0 then
				text = ""
			else
				text = "(" .. measures_left .. ")"
			end
			-- diffuse break counter to be Still Grey, just like Pendulum intended
			self:diffuse(0.5,0.5,0.5,1)
		end
	else
		text = tostring(current_count .. "/" .. current_stream_length)
		self:diffuse(1,1,1,1)
	end
	return text, current_count > current_stream_length, self
end

local Update = function(self, delta)
	if not NoteData then return end

    local curr_measure = (math.floor(GAMESTATE:GetSongPosition():GetSongBeatVisible()))/4

	-- if a new measure has occurred
	if curr_measure > prev_measure then

		prev_measure = curr_measure
		local text, is_end = GetTextForMeasure(self, curr_measure, NoteData, stream_index)

		-- If we're still within the current section
		if not is_end then
			self:settext(text)
		-- In a new section, we should check if curr_measure overlaps with it
		else
			stream_index = stream_index + 1
            text, is_end = GetTextForMeasure(self, curr_measure, NoteData, stream_index)
			self:settext(text)
        end
	end
	return self
end

if enabled then
	return Def.BitmapText{
		Font='_Condensed Semibold',
		OnCommand=function(self)
			if not enabled then return end
			if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(player,-1)) then
				local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(player,-1)):GetX()
				self:halign(1):shadowlength(1):xy(pos+(96*2)-(8), _screen.cy)
				InitializeMeasureCounter()
				self:queuecommand("Update")
			end
		end,
		UpdateCommand = function(self)
			Update(self,0)
			self:sleep(0.02):queuecommand('Update')
		end,
		CurrentSongChangedMessageCommand = function(self)
			InitializeMeasureCounter()
		end
	}
end
return {}