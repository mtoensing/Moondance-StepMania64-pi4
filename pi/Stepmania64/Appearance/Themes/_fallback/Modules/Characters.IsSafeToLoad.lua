-- Check if the current model from the player has any issues.
return function(pn)
    -- Don't apply the check if we have the character set to "off" (default)
    if GAMESTATE:GetCharacter(pn):GetDisplayName() ~= "default" then
        -- Otherwise, check the model path.
        if GAMESTATE:GetCharacter(pn):GetModelPath() == "" then
            lua.ReportScriptError(
                string.format( THEME:GetString("Common","ModelLoadError"), ToEnumShortString(pn), GAMESTATE:GetCharacter(pn):GetDisplayName() )
            )
            return false
        end
        if GAMESTATE:GetCharacter(pn):GetDanceAnimationPath() == "" or
            GAMESTATE:GetCharacter(pn):GetRestAnimationPath() == "" or 
            GAMESTATE:GetCharacter(pn):GetWarmUpAnimationPath() == ""
            then
            lua.ReportScriptError(
                string.format( THEME:GetString("Common","ModelAnimLoadError"), ToEnumShortString(pn), GAMESTATE:GetCharacter(pn):GetDisplayName() )
            )
            return false
        end
    end
    return true
end