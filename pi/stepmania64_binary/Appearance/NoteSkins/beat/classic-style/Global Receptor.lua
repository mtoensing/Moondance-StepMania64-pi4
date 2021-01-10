local Button = Var "Button";

local sPlayer = Var "Player"

local Reverse = GAMESTATE:GetPlayerState(sPlayer):GetPlayerOptions("ModsLevel_Preferred"):Reverse() == 1

return Def.ActorFrame {
	OnCommand=function(self)
		self:zoomy(Reverse and -1 or 1)
	end,
	Def.Sprite {
		Texture="_Global Note Flash Center (res 1x60).png",
		OnCommand=function(self)
			self:valign(1):y(6):zoomy(.5):zoomx(Button == "scratch" and 68 or 34):diffuseramp():effectcolor1(1,1,1,.02):effectcolor2(1,1,1,1):effectclock("beat")
		end	
	},
	Def.Sprite {
	Texture="_Gobal Receptor (res 1x12).png",
	OnCommand=function(self)
		self:zoomx(Button == "scratch" and 68 or 34)
	end
	},
	Def.ActorFrame{
		OnCommand=function(self) self:diffusealpha(0):zoomy(5):y(6) end,
		PressCommand=function(self) self:stoptweening():diffusealpha(.6) end,
		LiftCommand=function(self) self:linear(.15):diffusealpha(0) end,
		Def.Sprite {
		Texture="_Global Note Flash Side (res 2x60).png",
		OnCommand=function(self)
			self:valign(1):x(Button == "scratch" and -33 or -16)
		end	
		},
		Def.Sprite {
		Texture="_Global Note Flash Side (res 2x60).png",
		OnCommand=function(self)
			self:valign(1):zoomx(-1):x(Button == "scratch" and 33 or 16)
		end	
		},
		Def.Sprite {
		Texture="_Global Note Flash Center (res 1x60).png",
		OnCommand=function(self)
			self:valign(1):zoomx(Button == "scratch" and 64 or 30)
		end	
		}
	}
}