local Amount = 0
local ToastyOffset = 0

function ChecKCombo(Input, StartAmount, EveryIteration)
	if Amount == 0 then Amount = StartAmount end
	if Input >= Amount then
		if EveryIteration then Amount = Amount+StartAmount
		else Amount = math.huge end
		return true
	end
	return false
end

return function(pn)
	if not FILEMAN:DoesFileExist(CheckIfUserOrMachineProfile(pn-1).."/OutFoxPrefs.ini") then
		return Def.ActorFrame {}
	end
	
	local CurToast = LoadModule("Config.Load.lua")("SmartToasties",CheckIfUserOrMachineProfile(pn-1).."/OutFoxPrefs.ini")

	if not CurToast then
		return Def.ActorFrame {}
	end

	local ComTypes = {
		["Default"] = {
			"HasSound",
			"SoundFile",
			"HasImage",
			"ImageFile",
			"ShowAt",
			"Iterate"
		},
		["Player1"] = {
			"InitCommand",
			"OnCommand"
		},
		["Player2"] = {
			"InitCommand",
			"OnCommand"
		}
	}

	local ShortCom = {}
	
	for k,i in pairs(ComTypes) do
		ShortCom[k] = {}
		for _,v in ipairs(i) do
			ShortCom[k][v] = LoadModule("Config.Load.lua")(v,"Appearance/Toasties/"..CurToast.."/default.ini",k)
		end
	end
	
	local t = Def.Actor {}
	
	if ShortCom["Default"]["HasImage"] then
		t = Def.Sprite {
			OnCommand=function(self) self:Load("Appearance/Toasties/"..CurToast.."/"..ShortCom["Default"]["ImageFile"]) end
		}
	end
	
	return Def.ActorFrame {
		InitCommand=function(self) if tostring(ShortCom["Player"..pn]["InitCommand"]) ~= "false" and tostring(ShortCom["Player"..pn]["InitCommand"]) ~= "" then In = self loadstring("In:"..ShortCom["Player"..pn]["InitCommand"])() In = nil end end,
		ComboChangedMessageCommand=function(self,params) 
			if params.PlayerStageStats:GetCurrentCombo() == 0 then Amount = 0 end
			if ChecKCombo(params.PlayerStageStats:GetCurrentCombo(),tonumber(ShortCom["Default"]["ShowAt"]),ShortCom["Default"]["Iterate"]) then
				if tostring(ShortCom["Player"..pn]["OnCommand"]) ~= "false" and tostring(ShortCom["Player"..pn]["OnCommand"]) ~= "" then In = self loadstring("In:"..ShortCom["Player"..pn]["OnCommand"])() In = nil end
				if ShortCom["Default"]["HasSound"] then
					SOUND:PlayOnce("Appearance/Toasties/"..CurToast.."/"..ShortCom["Default"]["SoundFile"])
				end
			end	
		end,
		t
	}
end