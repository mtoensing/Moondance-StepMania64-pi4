return function()
    return "/Appearance/DanceStages/"..(LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini") or "Default")
end