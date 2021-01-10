return function()
    local LoadStageNames = LoadModule("Characters.LoadStageNames.lua")()
    local function BeginCheck()
        -- Make sure this check does not happen on None, since that Location has nothing.
        if LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini") ~= "None" then
            if not FILEMAN:DoesFileExist(LoadModule("Characters.CallCurrentStage.lua")().."/model.txt") then
                lua.ReportScriptError(
                    string.format( THEME:GetString("Common","LocationLoadError"), LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini"))
                )
                return false
            end
        end
        return true
    end
    
    -- Verify that the location selected exists
    for val in ivalues( LoadStageNames ) do
        if LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini") == val then BeginCheck() end
    end
end