local args = ...
local pn = args[1]
local p2paneoffset = args[2]
local useExperiment = LoadModule("Config.Load.lua")("experimentNPSDiagram","Save/OutFoxPrefs.ini")

local colorrange = function(val,range,color1,color2)
    return lerp_color( (val/range), color1, color2  )
end

local peak,npst,NMeasure,mcount = 0,{},{},0

local GetStreamBreakdown = function(Player)
    if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(Player) then
        local streams = LoadModule("Chart.GetStreamMeasure.lua")(NMeasure, 2, mcount)
        if not streams then return "" end
        
        local streamLengths = {}
        
        for i, stream in ipairs(streams) do
            local streamCount = tostring(stream.streamEnd - stream.streamStart)
            if not stream.isBreak then
                streamLengths[#streamLengths + 1] = streamCount
            end
        end
        
        return table.concat(streamLengths, "/")
    end
    return ""
end

local verts = {}
local amv = Def.ActorFrame{
        ["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(s) 
            if GAMESTATE:GetCurrentSong() then
                s:finishtweening():sleep(2.2):queuecommand("ShowAMV")
            end
        end,
		Def.ActorMultiVertex{
			OnCommand=function(s)
				s:SetDrawState{Mode="DrawMode_QuadStrip"}
				s:xy( p2paneoffset/2 , useExperiment and 58 or 294 )
			end,
			ShowAMVCommand=function(s)
				verts = {}
                if GAMESTATE:GetCurrentSong() and GAMESTATE:IsHumanPlayer(pn) and GAMESTATE:GetCurrentSteps(pn) then
                    -- Grab every instance of the NPS data.
                    local step = GAMESTATE:GetCurrentSteps(pn)
                    peak,npst,NMeasure,mcount = LoadModule("Chart.GetNPS.lua")( step )
				    if npst then
					    for k,v in pairs( npst ) do
							-- Each NPS area is per MEASURE. not beat. So multiply the area by 4 beats.
							local t = step:GetTimingData():GetElapsedTimeFromBeat((k-1)*4)
							-- With this conversion on t, we now apply it to the x coordinate.
							local x = scale( t, math.min(step:GetTimingData():GetElapsedTimeFromBeat(0), 0), GAMESTATE:GetCurrentSong():GetLastSecond(),
								-(p2paneoffset/2)+5, (p2paneoffset/2)-5
							)
							-- Now scale that position on v to the y coordinate.
                            local y = math.round( scale( v, 0, peak, 60, -50 ) )
                            local colrange = colorrange( v, peak, ColorDarkTone(PlayerColor(pn)), Color.Purple )
							-- And send them to the table to be rendered.
							if #verts > 2 and (verts[#verts][1][2] == y and verts[#verts-2][1][2] == y) then
								verts[#verts][1][1] = x
								verts[#verts-1][1][1] = x
                            else
                                if x < (p2paneoffset/2) then
                                    verts[#verts+1] = {{x, 60, 0}, PlayerColor(pn) }
                                    verts[#verts+1] = {{x, y, 0}, colrange}
                                end
                            end
					    end
				    end
                end
                s:SetNumVertices( #verts ):SetVertices( verts )
                verts = {} -- To free some memory, let's empty the table.
			end,
        },
        
        Def.Quad{
            OnCommand=function(self)
                self:zoomto( 1, 116 ):valign(0):y( useExperiment and 0 or 241 ):fadetop(1):blend("BlendMode_Add")
            end,
            CurrentSongChangedMessageCommand=function(self) self:stoptweening() end,
            ShowAMVCommand=function(self)
                self:visible( GAMESTATE:GetCurrentSong() ~= nil )
                if GAMESTATE:IsHumanPlayer(pn) and GAMESTATE:GetCurrentSong() then
                    self:playcommand("BeginUpdate")
                end
            end,
            BeginUpdateCommand=function(self)
                local time = GAMESTATE:GetSongPosition():GetMusicSecondsVisible()
                local scl = scale( time, 0, GAMESTATE:GetCurrentSong():GetLastSecond(), 0, p2paneoffset)
                self:x( scl ):sleep(1/20):queuecommand("BeginUpdate")
            end
        },

        Def.ActorFrame{
            InitCommand=function(s)
                s.breakdown = ""
            end,
            ShowAMVCommand=function(s)
                if GAMESTATE:IsHumanPlayer(pn) then
                    s.breakdown = GetStreamBreakdown(pn)
                end
            end,

            Def.Quad{
                OnCommand=function(s) s:align(0,0.5):zoomto( p2paneoffset, 30 ):y( useExperiment and 100 or 340 ):diffuse( color("#22222299") ) end,
                ShowAMVCommand=function(s) s:visible( s:GetParent().breakdown ~= "" ) end,
            },
            Def.BitmapText{
                Font="_Condensed Medium",
                OnCommand=function(s)
                    s:xy( 10,useExperiment and 100 or 340 ):diffusealpha(0.75):maxwidth(p2paneoffset+80):zoom(0.8)
                    s:halign(0)
                end,
                ShowAMVCommand=function(s)
                    s:finishtweening():settext( s:GetParent().breakdown )
                    :x(10):diffusealpha(0.6):maxwidth( p2paneoffset+80 )
                    if useExperiment and (string.len( s:GetParent().breakdown ) > 36) then
                        s:maxwidth(0):queuecommand("TweenScroll")
                    end
                end,
                TweenScrollCommand=function(s)
                    local width = s:GetZoomedWidth()
                    local length = string.len(s:GetText())
                    s:x(10):linear(0.2):diffusealpha(0.6)
                    s:sleep(1):linear( scale(length, 36, 200, 3, 24) ):x( -width+(p2paneoffset-10) ):sleep(0.5):linear(0.2):diffusealpha(0)
                    :sleep(0):queuecommand("TweenScroll")
                end,
                OffCommand=function(s)
                    s:stoptweening()
                end,
            },

            Def.BitmapText{
                Font="_Condensed Semibold",
                OnCommand=function(s) s:xy( 10, useExperiment and 12 or 252 ):halign(0):zoom(0.75):diffusealpha(0.9) end,
                ShowAMVCommand=function(s)
                    local curpeak = GAMESTATE:GetCurrentSong() and peak or 0
                    s:settext( string.format( THEME:GetString("ScreenGameplay","MaxNPS"), curpeak ) )
                end,
            }
        }

}

if useExperiment then
    local t = Def.ActorFrame{}
    t[#t+1] = Def.ActorFrameTexture{
        InitCommand=function(s)
            s:SetWidth( p2paneoffset ):SetHeight( 120 ):EnableAlphaBuffer(false):SetTextureName("NPS"..pn):Create()
        end,
        amv
    }

    t[#t+1] = Def.Sprite{
        Texture="NPS"..pn,
        OnCommand=function(s)
            s:xy( p2paneoffset/2-1, 300 )
        end,
    }
    return t
end

return amv