-- This will check if the current stage is able to change its lighting cycle.
-- Not all locations can do this, so doing this will save space.
return function()
	-- Expect model to have a separate file for material
	local ToFind = "/main_material.txt"
	local Light = LoadModule("Characters.LightToLoad.lua")()
	-- If it has the setting to toggle day/night then load the appropiate material.
	if tobool( (LoadModule("Config.Load.lua")( "AbleToChangeLight",LoadModule("Characters.CallCurrentStage.lua")().."/ModelConfig.ini",false )) ) then
		ToFind = "/"..Light.."_material.txt"
	else
		ToFind = ToFind
	end
	-- If either are false or fail, then resort to go back to the model file itself.
	if not FILEMAN:DoesFileExist(ToFind) and not LightCheck then
		ToFind = "/model.txt"
	end
	return LoadModule("Characters.GetPathLocation.lua")("",LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini")..ToFind);
end