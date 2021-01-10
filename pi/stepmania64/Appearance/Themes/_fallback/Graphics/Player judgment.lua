local JCMDConv = {
	TapNoteScore_ProW1 = "ProW1Command",
	TapNoteScore_ProW2 = "ProW2Command",
	TapNoteScore_ProW3 = "ProW3Command",
	TapNoteScore_ProW4 = "ProW4Command",
	TapNoteScore_ProW5 = "ProW5Command",
	TapNoteScore_W1 = "W1Command",
	TapNoteScore_W2 = "W2Command",
	TapNoteScore_W3 = "W3Command",
	TapNoteScore_W4 = "W4Command",
	TapNoteScore_W5 = "W5Command",
	TapNoteScore_Miss = "MissCommand"
}

local sPlayer = Var "Player"

-- Note that this does not really represent a CMD in lua.
-- This is grabbing the metric from the current theme.
local function GetJCMD(Type,JCMD)
	if Type == 1 then Type = "Judgment" else Type = "Protiming" end
	return THEME:GetMetric( Type, Type..JCMDConv[JCMD] )
end

local function GetTexture()
	if THEME:GetMetric("Common","UseAdvancedJudgments") then 
		if GAMESTATE:IsDemonstration() then
			return LoadModule("Options.SmartJudgments.lua")()[LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),THEME:GetMetric("Common","DefaultJudgment"))] 
		end
		return LoadModule("Options.SmartJudgments.lua")()[LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),LoadModule("Config.Load.lua")("SmartJudgments",CheckIfUserOrMachineProfile(string.sub(sPlayer,-1)-1).."/OutFoxPrefs.ini") or THEME:GetMetric("Common","DefaultJudgment"))] 
	end
	return THEME:GetPathG("Judgment","Normal")
end
local bProtiming = LoadModule("Config.Load.lua")("ProTiming",CheckIfUserOrMachineProfile(string.sub(sPlayer,-1)-1).."/OutFoxPrefs.ini")
local bOffsetBar = LoadModule("Config.Load.lua")("OffsetBar",CheckIfUserOrMachineProfile(string.sub(sPlayer,-1)-1).."/OutFoxPrefs.ini")
local bHideJudgment = LoadModule("Config.Load.lua")("HideJudgment",CheckIfUserOrMachineProfile(string.sub(sPlayer,-1)-1).."/OutFoxPrefs.ini") or false

local Name,Length = LoadModule("Options.SmartTapNoteScore.lua")()
table.sort(Name)
Name[#Name+1] = "Miss"
Length = Length + 1

local DoubleSet = Length*2

local OffbarPos = bHideJudgment and 0 or -32

-- Generate Offset Bar
local OffBar = Def.ActorFrame{ InitCommand=function(s) s:visible( bOffsetBar ) end,
	Def.ActorFrame{
		Name="Background",
		OnCommand=function(s) s:visible(false) end,
		Def.Quad{ OnCommand=function(s) s:zoomto(150,1):fadeleft(1):faderight(1) end },
		Def.Quad{ OnCommand=function(s) s:zoomto(2,32):fadetop(1):fadebottom(1) end }
	}
}
OffBar[#OffBar+1] = Def.Quad{ InitCommand=function(s) s:zoomto(2,15):diffusealpha(0) end }

return Def.ActorFrame {
	Def.Sprite{
		Name="Judgment",
		Texture=GetTexture(),
		InitCommand=function(self) self:pause():visible(false) end,
		OnCommand=THEME:GetMetric("Judgment","JudgmentOnCommand"),
		ResetCommand=function(self) self:finishtweening():stopeffect():visible(false) end
	},
	LoadFont("Common Normal") .. {
		Name="Protiming",
		Text="",
		InitCommand=function(self) self:visible(false) end,
		OnCommand=THEME:GetMetric("Protiming","ProtimingOnCommand"),
		ResetCommand=function(self) self:finishtweening():stopeffect():visible(false) end
	},
	OffBar..{ Name="OffsetBar", OnCommand=function(s) s:y( OffbarPos ) end },
	JudgmentMessageCommand=function(self, params)
		local Judg = self:GetChild("Judgment")
		local Prot = self:GetChild("Protiming")
		local OFB = self:GetChild("OffsetBar")
		if params.Player ~= sPlayer then return end
		if params.HoldNoteScore then return end
		if string.find(params.TapNoteScore, "Mine") then return end

		local jPath = string.match(Judg:GetTexture():GetPath(), ".*/(.*)")
		local iFrame
		local iNumFrames = Judg:GetTexture():GetNumFrames()
		local IsDouble = string.find(jPath, "%[double%]")
		-- Check if the current texture is a double sided judgment texture.
		if iNumFrames == DoubleSet then
			IsDouble = true
		end

		for i = 1,#Name do
			if params.TapNoteScore == "TapNoteScore_"..Name[i] then iFrame = i-1 end
		end

		if params.TapNoteScore == "TapNoteScore_Miss" then
			iFrame = (IsDouble and (iNumFrames / 2) or iNumFrames)-1
		end

		if not iFrame then return end
		if IsDouble then
			iFrame = iFrame * 2
			if not params.Early then
				iFrame = iFrame + 1
			end
		end

		self:playcommand("Reset")

		Judg:visible( not bHideJudgment )
		Judg:setstate( iFrame )
		GetJCMD(1,params.TapNoteScore)(Judg)

		-- Manage MS timing
		Prot:visible( bProtiming )
		Prot:settext( math.floor(math.abs(params.TapNoteOffset * 1000)*(params.Early and -1 or 1) ) .. " ms" )

		-- Manage Offset Bar
		if bOffsetBar then
			OFB:GetChild("Background"):visible( bOffsetBar )
			OFB:GetChild(""):finishtweening()
			:diffuse( JudgmentLineToColor( "JudgmentLine_".. ToEnumShortString(params.TapNoteScore) ) )
			:decelerate(0.02)
			:x( math.floor(math.abs(params.TapNoteOffset * 600 ))*(params.Early and -1 or 1) )
		end

		GetJCMD(1,params.TapNoteScore)(Prot)
	end
}
