return function()
    local BothHaveBeg,PlrHasBeg = false,false;
    local HasBeg = {
        ["PlayerNumber_P1"] = nil,
        ["PlayerNumber_P2"] = nil,
    }
    for player in ivalues(PlayerNumber) do
        -- Check if the player is on beginner mode.
        -- Also check if we're not on Course Mode. There's not really a Helper for Nonstop.
        if not GAMESTATE:IsCourseMode() then
            if GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetCurrentSteps(player):GetDifficulty() == "Difficulty_Beginner" then
                HasBeg[player] = true
            end
        end
    end
    if HasBeg[PLAYER_1] == true and HasBeg[PLAYER_2] == true then
        BothHaveBeg = true
    end
    if GAMESTATE:GetNumPlayersEnabled() == 1 then
        PlrHasBeg = GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ):GetDifficulty() == "Difficulty_Beginner"
    end
    -- Now check if it's required to be enabled.
    return PREFSMAN:GetPreference("ShowBeginnerHelper") and (GAMESTATE:GetNumPlayersEnabled() == 2 and BothHaveBeg or PlrHasBeg)
end