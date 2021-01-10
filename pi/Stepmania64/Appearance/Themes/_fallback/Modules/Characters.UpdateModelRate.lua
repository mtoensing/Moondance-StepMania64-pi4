return function()
    -- In case the song is on a rate, then we can multiply it.
    -- It also checks for the song's Haste, if you're using that.
    -- Safe check in case Obtaining HasteRate fails
    local MusicRate = 1
    if SCREENMAN:GetTopScreen() then
        if SCREENMAN:GetTopScreen():GetScreenType() == "ScreenType_Gameplay" and SCREENMAN:GetTopScreen():GetHasteRate() then
            MusicRate = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate()*SCREENMAN:GetTopScreen():GetHasteRate()
        end
        local BPM = (GAMESTATE:GetSongBPS()*60)
        
        -- We're using scale to compare higher values with lower values.
        local UpdateScale = scale( BPM, 60, 700, 0.6, 3 );
        
        -- Then take what we have and update depending on the music rate.
        local ToConvert = UpdateScale*MusicRate
        local SPos = GAMESTATE:GetSongPosition()
        
        if not SPos:GetFreeze() and not SPos:GetDelay() and not SCREENMAN:GetTopScreen():IsPaused() then
            return ToConvert
        end
        return 0
    end
    return 0
end