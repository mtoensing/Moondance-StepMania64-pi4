local Sizestr = 0
local CartOffset = 1

local Carts = Def.ActorFrame{}
local Letters = Def.ActorFrame{}
local Christmas = Def.ActorFrame{
	OnCommand=function(self) self:xy(-SCREEN_CENTER_X,-SCREEN_CENTER_Y-180) end
}
local function Xmas()
	if MonthOfYear()+1 == 12 then return true end
	return false
end

if Xmas() then
	Christmas[#Christmas+1] = Def.Sprite {
		Name="Flake",
		Texture="snow 4x1.png",
		InitCommand=function(self) self:xy(0,-50) end,
		OnCommand=function(self) self:sleep(8):linear(1):diffusealpha(0) end
	}
	Christmas[#Christmas+1] = Def.Sound {
		File="Bells.ogg",
		OnCommand=function(self) self:play() end
	}
	for i = 1,500 do
		Christmas[#Christmas+1] = Def.ActorProxy {
			InitCommand=function(self)
				self:SetTarget(self:GetParent()
					:GetChild("Flake"))
					:wag()
					:effectoffset(math.random())
					:rotationz(180)
					:zoom(.5)
			end,
			OnCommand=function(self) 
				local randy = math.random(-200,SCREEN_HEIGHT)
				local randx = math.random(0,SCREEN_WIDTH)
				self:xy(randx,randy)
					:linear((SCREEN_HEIGHT-randy)/100)
					:y(SCREEN_HEIGHT)
					:queuecommand("Loop")
			end,
			LoopCommand=function(self) 
				local randx = math.random(0,SCREEN_WIDTH)
				self:xy(randx,0)
					:linear(10)
					:y(SCREEN_HEIGHT)
					:queuecommand("Loop")
			end,
			StopTweenMessageCommand=function(self)
				self:stoptweening()
			end
		}		
	end
end


for i = 1,4 do
    Carts[#Carts+1] = Def.ActorFrame {
        OnCommand=function(self) self:x(480):linear(10):x(-480) end,
        Def.Sprite {
            Texture="Cart 2x1.png",
            InitCommand=function(self) self:SetTextureFiltering(false):x(-180+58+(48*i)):SetAllStateDelays(0.25):setstate(CartOffset) if CartOffset == 0 then CartOffset = 1 else CartOffset = 0 end end   
         }
    }
end

for i = 1,8 do
    Letters[#Letters+1] = Def.ActorFrame {
        OnCommand=function(self) self:x(480):linear(5):x(0) end,
        Def.Sprite {
            Texture=i..".png",
            InitCommand=function(self) 
                self:x(-100+Sizestr):halign(0):valign(1):y(5):SetTextureFiltering(false):glow(1,1,1,1):zoom(0.8)
                Sizestr = Sizestr + (self:GetWidth()*0.8) + 5
            end
        }
    }
end

return Def.ActorFrame {
    InitCommand=function(self)
        self:zoom(3)
    end,
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(color("#d47984")):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2)
        end
    },
    Def.Sprite {
        Texture="BG.png",
        InitCommand=function(self) self:SetTextureFiltering(false):y(-104):zoom(1.6) end
    },
    Def.Sprite {
        Texture=Xmas() and "Tree" or "Tower.png",
        InitCommand=function(self) self:SetTextureFiltering(false):y(-56):zoom(0.6) end
    },
    Def.ActorFrame {
        OnCommand=function(self) self:x(480):linear(10):x(-480) end,
        Def.Sprite {
            Texture="Train 16x1.png",
            InitCommand=function(self) self:SetTextureFiltering(false):SetAllStateDelays(0.125):setstate(1):x(-180) end
        },
        Def.Sprite {
            Texture="Coal 2x1.png",
            InitCommand=function(self) self:SetTextureFiltering(false):x(-180+58):SetAllStateDelays(0.25) end
        },
        Def.Sound {
            File="Rail.ogg",
            OnCommand=function(self) self:play() end
        },
        Def.Sound {
            File="Train.ogg",
            OnCommand=function(self) self:play() end
        },
        Def.Sound {
            File="Horn.ogg",
            OnCommand=function(self) self:sleep(5):queuecommand("Play") end,
            PlayCommand=function(self) self:play() end
        }
    },
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(0,0,0,0):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2):sleep(8):linear(1):diffusealpha(1)
        end
    },
    Def.Sprite {
        Texture="Acorn.png",
        InitCommand=function(self) self:SetTextureFiltering(false):y(-34):diffusealpha(0.5):valign(1) end,
        OnCommand=function(self) self:sleep(8):linear(1):diffusealpha(1):zoom(3) end
    },
	Carts,
	Letters,
	Christmas,
	Def.Quad {
		InitCommand=function(self)
				self:FullScreen():diffuse(0,0,0,1):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2):linear(1):diffusealpha(0):sleep(9.2):linear(1):diffusealpha(1):queuecommand("Transfer")
		end,
		TransferCommand=function(self) 
			MESSAGEMAN:Broadcast("StopTween")
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end
	}
}
