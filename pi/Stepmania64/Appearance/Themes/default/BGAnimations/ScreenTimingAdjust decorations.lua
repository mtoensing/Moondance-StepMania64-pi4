local t = LoadFallbackB()
local f = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini")
-- local Name,Length = GetTimingDifficulty()
local JudgNames = {"ProW1","ProW2","ProW3","ProW4","ProW5","W1","W2","W3","W4","W5"}
local Name,Timings

for i = 1,#TimingWindow do
    Name,Timings = TimingWindow[i]()
    if f == Name then break end
end

t[#t+1] = Def.BitmapText{
    Font="_Semibold",
    Text=Screen.String("Current").. " " .. Name,
    OnCommand=function(s)
        s:zoom(1):xy(SCREEN_CENTER_X-300,SCREEN_CENTER_Y-190):halign(0):draworder(100):shadowlength(1)
        :diffusealpha(0):sleep(0.2):linear(0.05):diffusealpha(1)
    end,
    OffCommand=function(s) s:linear(0.05):diffusealpha(0) end,
}

for i=1,10 do
    t[#t+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy( SCREEN_CENTER_X-250, SCREEN_CENTER_Y-180+(34*i) ):draworder(100)
            :diffuse( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) )
            if not Timings[ "TapNoteScore_"..JudgNames[i] ] then
                s:diffuse( ColorDarkTone( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) ) )
            end
            s:diffusealpha(0):sleep(0.2+(0.04*i)):linear(0.1):diffusealpha(1)
        end,
        OffCommand=function(s) s:sleep(0.01*i):linear(0.1):diffusealpha(0) end,
        Def.BitmapText{
            Font="_SemiBold",
            Text=Timings[ "TapNoteScore_"..JudgNames[i] ] or "0.0",
            OnCommand=function(s) s:shadowlength(1):x(40):halign(0):skewx(-0.1):zoom(1) end,
        },
        Def.BitmapText{
            Font="_Semibold",
            Text=THEME:GetString( "JudgmentDisplay" , "Judgment"..JudgNames[i] ),
            OnCommand=function(s) s:shadowlength(1):zoom(1):x(10):halign(1) end,
        }
    }

    t[#t+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy( SCREEN_CENTER_X+230, SCREEN_CENTER_Y-180+(34*i) ):draworder(100)
            :diffuse( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) )
            :diffusealpha(0):sleep(0.2+(0.04*i)):linear(0.1):diffusealpha(1)
            if not Timings[ "TapNoteScore_"..JudgNames[i] ] then
                s:diffuse( ColorDarkTone( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) ) )
            end
        end,
        OffCommand=function(s) s:sleep(0.01*i):linear(0.1):diffusealpha(0) end,
        SmartTimingsChangeMessageCommand=function(s,param)
            if param.choice then
                local name,sm = TimingWindow[param.choice]()
                if sm[ "TapNoteScore_"..JudgNames[i] ] then
                    s:GetChild("Tm"..i):settext( sm[ "TapNoteScore_"..JudgNames[i] ] )
                    s:diffuse( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) )
                else
                    s:GetChild("Tm"..i):settext( "0.0" )
                    s:diffuse( ColorDarkTone( JudgmentLineToColor("JudgmentLine_" .. JudgNames[i]) ) )
                end
            end
        end,
        Def.BitmapText{
            Name="Tm"..i,
            Font="_SemiBold",
            Text=Timings[ "TapNoteScore_"..JudgNames[i] ] or "0.0",
            OnCommand=function(s) s:shadowlength(1):x(-40):halign(1):skewx(-0.1):zoom(1) end,
        },
        Def.BitmapText{
            Font="_Semibold",
            Text=THEME:GetString( "JudgmentDisplay" , "Judgment"..JudgNames[i] ),
            OnCommand=function(s) s:shadowlength(1):zoom(1):x(0):halign(0) end,
        }
    }
end

t[#t+1] = Def.BitmapText{
    Font="_Semibold",
    Text=Screen.String("Selected") .. " " .. Name,
    OnCommand=function(s)
        s:shadowlength(1):zoom(1):xy(SCREEN_CENTER_X+150,SCREEN_CENTER_Y-190):halign(0):draworder(100)
        :diffusealpha(0):sleep(0.2):linear(0.05):diffusealpha(1)
    end,
    OffCommand=function(s) s:linear(0.05):diffusealpha(0) end,
    SmartTimingsChangeMessageCommand=function(s,param)
        if param.choice then
            local name,sm = TimingWindow[param.choice]()
            s:settext( THEME:GetString("ScreenTimingAdjust","Selected") .. " " .. name )
        end
    end,
}
return t;