local Default = THEME:GetCurThemeName();

return function()

    local Info = {
        "DDR/ITG.\n\nSingle (4 Panel)\nSolo (6 Panel)\nThree (3 Panel)\nDouble (8 Panel)",
        "Pump.\n\nSingle (5 Panel)\nHalfDouble (6 Panel)\nDouble (10 Panel)",
        "Keyboard7.\n\nSingle (7 Button)",
        "Ez2Dancer.\n\nSingle (3 Panel 2 Hand)\nReal(3 Panel 4 Hand)\nDouble(6 Panel 4 Hand)",
        "PPParadise.\n\nSingle (5 Sensor)",
        "Dance Station 3DDX.\n\nSingle (4 Panel 4 Hand)",
        "BeatMania.\n\nSingle5 (5 Button 1 Scratch)\nSingle7 (7 Button 1 Scratch)\nDouble5 (10 Button 2 Scratch)\nDouble7 (14 Button 2 Scratch)",
        "Dance Maniax.\n\nSingle (4 Sensor)\nDouble (8 Sensor)",
        "TechnoMotion.\n\nSingle4 (4 Panel)\nSingle5 (5 Panel)\nSingle8 (8 Panel)\nDouble4 (8 Panel)\nDouble5 (10 Panel)\nDouble8 (16 Panel)",
        "Pop'n Music.\n\nFive (5 Button)\nSeven (7 Button)\nNine (9 Button)",
        "GDDM.\n\nSingle (9 Parts)",
        "Guitar.\n\n5 Guitar (5 Fret)\n5 Bass (5 Fret 1 Snare)\n3 Guitar (3 Fret)\n3 Bass (3 Fret 1 Snare)",
        --"lights",
        "KickBox.\n\nHuman (4 Panel)\nQuadarm (4 Panel\nInsect (6 Panel)\nArachnid (8 Panel)"
    }


    local Choices = {
        "dance",
        "pump",
        "kb7",
        "ez2",
        "para",
        "ds3ddx",
        "beat",
        "maniax",
        "techno",
        "popn",
        "gddm",
        "guitar",
        --"lights", -- should change this to another screen option.
        "kickbox"
    }
	
	local Themes = {
		"default", --dance
        Default, --pump
        Default, --kb7
        Default, --ez2
        Default, --para
        Default, --ds3ddx
        Default, --beat
        Default, --maniax
        Default, --techno
        Default, --popn
        Default, --gddm
        Default, --guitar
        --lights -- should change this to another screen option.
        Default --kickbox
	}

    local choice = 1
    for i,v in ipairs(Choices) do
        if v == GAMESTATE:GetCurrentGame():GetName() then choice = i end
    end

    local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )

    local function MoveOption(self,offset)

        choice = choice + offset
        
        if choice < 1 then choice = 1 return end
        if choice > #Choices then choice = #Choices return end

        for i = 1,#Choices do
            self:GetChild("Container"):GetChild("Selection"..i):y(-40+(40*(i-(choice-1))))

            if i == choice then
                self:GetChild("Container"):GetChild("Selection"..i):GetChild("Text"):stoptweening():linear(.08):diffuse( ColorTable["menuTextGainFocus"] ):diffusealpha(1)
                self:GetChild("Container"):GetChild("Selection"..i):GetChild("Bars"):stoptweening():linear(.16):diffusealpha(1):zoomx(1)
            else
                self:GetChild("Container"):GetChild("Selection"..i):GetChild("Text"):stoptweening():linear(.08):diffuse( ColorTable["menuTextLoseFocus"] ):diffusealpha(0.3)           
                self:GetChild("Container"):GetChild("Selection"..i):GetChild("Bars"):stoptweening():linear(.16):diffusealpha(0):zoomx(0)
            end
            --self:GetChild("Previews"):GetChild("Preview_"..Choices[i]):visible(0)
        end

        self:GetChild("Info"):settext(Info[choice])
        --self:GetChild("Previews"):GetChild("Preview_"..Choices[choice]):visible(1)

        self:GetChild("Change"):play()
    end

    local Container = Def.ActorFrame{Name="Container"}
    local Previews = Def.ActorFrame{Name="Previews"}

    for i,v in ipairs(Choices) do
        Container[#Container+1] = Def.ActorFrame{
            Name="Selection"..i,
            OnCommand=function(self)
                self:xy(-220,-40+(40*(i-(choice-1))))
            end,
            Def.Quad {
                OnCommand=function(self) self:zoomto(260,36):diffuse(color("#001232")):diffusealpha(0.75) end
            },
            Def.BitmapText{
                Name="Text",
                Text=v,
                Font="Common Normal",
                OnCommand=function(self)
                    self:maxwidth(320):skewx(-0.15)
                    if choice == i then
                        self:diffuse( ColorTable["menuTextGainFocus"] ):diffusealpha(1)
                    else
                        self:diffuse( ColorTable["menuTextLoseFocus"] ):diffusealpha(0.3)
                    end
                end
            },
            Def.ActorFrame {
                Name="Bars",
                OnCommand=function(self)
                    self:diffusealpha(0):zoomx(0)
                    if i == choice then
                        self:diffusealpha(1):zoomx(1)
                    end
                end,
                Def.Quad {
                    OnCommand=function(self) 
                        self:zoomto(260,4):vertalign(top):y(-36/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) 
                    end
                },	
                Def.Quad {
                    OnCommand=function(self) 
                        self:zoomto(260,4):vertalign(bottom):y(36/2):diffuse( ColorTable["menuBlockHighlightA"] ):diffuseleftedge( ColorTable["menuBlockHighlightB"] ) 
                    end
                }
            }
        }
        --[[
        Previews[#Previews+1] = Def.Sprite{
            Name="Preview_"..v,
            Texture=THEME:GetPathG("ScreenSelectGameMode","Types/"..v),
            OnCommand=function(self)
                self:zoom(.3):texcoordvelocity(.1,0):xy(160,120):visible(0):SetTextureFiltering(false)
                if i == choice then
                    self:visible(1)
                end
            end
        }
        --]]
    end

    return Def.ActorFrame{
        OnCommand=function(self)
            self:Center()
            SCREENMAN:GetTopScreen():AddInputCallback(LoadModule("Lua.InputSystem.lua")(self))
        end,

        MenuUpCommand=function(self) MoveOption(self,-1) end,

        MenuDownCommand=function(self) MoveOption(self,1) end,

        MenuLeftCommand=function(self) MoveOption(self,-1) end,

        MenuRightCommand=function(self) MoveOption(self,1) end,

        BackCommand=function(self) 
            if GAMESTATE:GetCurrentGame():GetName() ~= "SelectGameMode" then
                SOUND:PlayOnce(THEME:GetPathS("Common","Cancel"))
                SCREENMAN:GetTopScreen():SetNextScreenName(SCREENMAN:GetTopScreen():GetPrevScreenName()):StartTransitioningScreen("SM_GoToNextScreen")
            end
        end,

        StartCommand=function(self)
            SOUND:PlayOnce(THEME:GetPathS("Common","start"))
            GAMEMAN:SetGame(Choices[choice],Themes[choice])
        end,

        Def.Sound{
            Name="Change",
            File=THEME:GetPathS("ScreenOptions","change")
        },

        Def.Quad{
            OnCommand=function(self)
                self:zoomto(1024,512):x(-512):MaskSource()
            end
        },
        Def.Quad{
            OnCommand=function(self)
                self:zoomto(1024,512):x(512+320):MaskSource()
            end
        },
        Previews..{
            OnCommand=function(self)
                self:MaskDest()
            end
        },
        Def.BitmapText{
            Name="Info",
            Text=Info[choice],
            Font="Common Normal",
            OnCommand=function(self)
                self:y(-200):halign(0):valign(0)
            end
        },
        Container
    }
end