-- Check if the player has any character loaded right now.
return function(pn)
    local s = LoadModule("Characters.LoadStageNames.lua")(pn)
    return GAMESTATE:IsPlayerEnabled(pn) and GAMESTATE:GetCharacter(pn):GetDisplayName() ~= "default" and s
end