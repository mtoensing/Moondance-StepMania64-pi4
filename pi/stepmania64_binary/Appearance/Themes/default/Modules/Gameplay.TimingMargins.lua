-- Best/Worst Window
return function()
    local JudgNames = LoadModule("Options.SmartTapNoteScore.lua")()
    table.sort(JudgNames)
    -- We need to check what is the worst window available.
    local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini")
    local LowestWindow = nil
    local HighestWindow = nil
    local n,Timings
    -- First, check the timings from our current timing window.
    for k,v in pairs( TimingWindow ) do
        n,Timings = TimingWindow[k]()
        if CurPrefTiming == n then break end
    end

    rec_print_table(Timings)

    -- Now, calculate the lowest.
    for k,v in pairs( JudgNames ) do
        if Timings[ "TapNoteScore_"..v ] > 0 then
            local ConvertedTime = GetWindowSeconds(Timings[ "TapNoteScore_"..v ], 1, 0)
            if not HighestWindow then HighestWindow = ConvertedTime end
            LowestWindow = ConvertedTime
        end
    end
    return LowestWindow, HighestWindow
end