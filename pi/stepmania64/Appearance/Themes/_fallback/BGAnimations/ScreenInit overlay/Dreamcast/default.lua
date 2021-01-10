collectgarbage();

local TimeFiles = {}

if Hour() > 20 or Hour() < 8 then
    --Night
    TimeFiles[1] = "Cricket.ogg"
    TimeFiles[2] = color("0,0,0,1")
    TimeFiles[3] = color("1,1,1,1")
else
    --Day 
    TimeFiles[1] = "Bird.ogg"
    TimeFiles[2] = color("1,1,1,1")
    TimeFiles[3] = color("0,0,0,1")
end

local Letters = Def.ActorFrame{}
local Sizestr = 0

for i = 1,8 do
    Letters[#Letters+1] = Def.Sprite{
        Texture=i..".png",
        InitCommand=function(self) 
            self:x(-100+Sizestr):halign(0):valign(1):y(30):zoom(1/12):glow(TimeFiles[3])
            Sizestr = Sizestr + (self:GetWidth()/12) + 5
        end,
        OnCommand=function(self)
            self:sleep(2+(0.4*i)):linear(0.25):zoomy(1.5/12):y(-5):linear(0.125):zoomy(1/12):y(0)
        end
    }
end

return Def.ActorFrame {
    InitCommand=function(self)
        self:zoom(3)
    end,
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(TimeFiles[2]):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2)
        end
    },
    Def.ActorFrame{
        InitCommand=function(self) self:y(-290) end,
        OnCommand=function(self) 
            self:accelerate(2.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.2):y(-50)
                :accelerate(.2):y(-10)
                :decelerate(.6):y(-160)
                :accelerate(.6):y(-90)
        end,
        Def.Sprite{
            Texture="Acorn.png",   
            InitCommand=function(self) self:zoom(1/42):x(-410) end,
            OnCommand=function(self) 
                self:decelerate(2.2):x(-90) -- T
                    :accelerate(.2):x(-80)
                    :decelerate(.2):x(-70) -- E
                    :accelerate(.2):x(-60)
                    :decelerate(.2):x(-45) -- A
                    :accelerate(.2):x(-27.5)
                    :decelerate(.2):x(-10) -- M
                    :accelerate(.2):x(5)
                    :decelerate(.2):x(20) -- R
                    :accelerate(.2):x(27.5)
                    :decelerate(.2):x(35) -- I
                    :accelerate(.2):x(45)
                    :decelerate(.2):x(55) -- Z
                    :accelerate(.2):x(70)
                    :decelerate(.2):x(80) -- U
                    :accelerate(.6):x(40)
                    :decelerate(.6):x(0)
                    :sleep(1/math.huge):linear(1):zoom(1/6):rotationz(360*2)
            end
        },
        Def.Sound{
            File="Grass.ogg",
            OnCommand=function(self)
                self:sleep(2.2):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
                    :sleep(.4):queuecommand("Play")
            end,
            PlayCommand=function(self) self:play() end        
        },
        Def.Sound{
            File=TimeFiles[1],
            OnCommand=function(self)
                self:sleep(6.2):queuecommand("Play")
            end,
            PlayCommand=function(self) self:play() end        
        }
    },
	
	Letters,
	
	Def.Quad {
		InitCommand=function(self)
			self:FullScreen():diffuse(TimeFiles[2]):x(-SCREEN_CENTER_X/2):fadetop(.005)
		end
	},
	
	Def.Quad {
		InitCommand=function(self)
				self:FullScreen():diffuse(0,0,0,1):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2):linear(1):diffusealpha(0):sleep(8.2):linear(1):diffusealpha(1):sleep(1):queuecommand("Transfer")
		end,
		TransferCommand=function(self) 
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end
	}
}
