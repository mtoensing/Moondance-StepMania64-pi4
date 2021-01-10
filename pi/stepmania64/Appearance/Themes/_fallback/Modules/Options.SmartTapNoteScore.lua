return function()
    local Timings = {}
    local CurrentTiming = LoadModule("Options.OverwriteTiming.lua")()

    for _,v in ipairs(TimingWindow) do
        Name,Tims = v()
        if Name == CurrentTiming then
            for k,v2 in pairs(Tims) do
                if string.find(k, "W") then Timings[#Timings+1] = ToEnumShortString(k) end
            end
        end
    end
    return Timings,#Timings
end