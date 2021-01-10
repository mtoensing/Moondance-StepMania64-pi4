local Button = Var "Button";

local sPlayer = Var "Player"

local Reverse = GAMESTATE:GetPlayerState(sPlayer):GetPlayerOptions("ModsLevel_Preferred"):Reverse() == 1

return Def.ActorFrame {
	OnCommand=function(self)
		self:zoomy(Reverse and -1 or 1)
	end,
	Def.Sprite {
	Texture="_Gobal Receptor (res 1x12).png",
	OnCommand=function(self)
		self:zoomx(32)
	end
	},
	Def.ActorFrame{
		OnCommand=function(self) self:diffusealpha(0):zoomy(5):y(6) end,
		PressCommand=function(self) self:stoptweening():diffusealpha(.6) end,
		LiftCommand=function(self) self:linear(.15):diffusealpha(0) end,
		Def.Sprite {
		Texture="_Global Note Flash Side (res 2x60).png",
		OnCommand=function(self)
			self:valign(1):x(-14)
		end	
		},
		Def.Sprite {
		Texture="_Global Note Flash Side (res 2x60).png",
		OnCommand=function(self)
			self:valign(1):zoomx(-1):x(14)
		end	
		},
		Def.Sprite {
		Texture="_Global Note Flash Center (res 1x60).png",
		OnCommand=function(self)
			self:valign(1):zoomx(28)
		end	
		}
	}
}