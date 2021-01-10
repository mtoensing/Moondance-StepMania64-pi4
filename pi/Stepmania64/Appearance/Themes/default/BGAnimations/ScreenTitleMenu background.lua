local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
local currentSubTheme = LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini")
local currentBGTheme = LoadModule("Config.Load.lua")("SoundwavesMenuBG","Save/OutFoxPrefs.ini")

local AnimatedMenu = LoadModule("Config.Load.lua")("FancyUIBG","Save/OutFoxPrefs.ini")

local LoadMenuBG = Def.ActorFrame{}

if currentBGTheme == "Ocular" then
	LoadMenuBG[#LoadMenuBG+1] = Def.ActorFrame {
		OnCommand=function(self)
			self:diffusealpha(0.11)
		end,
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "inner ring"),
			InitCommand=function(self)
				self:diffuse( ColorTable["titleBGPattern"] ):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):blend('add')
			end,
			OnCommand=function(self)
				if AnimatedMenu then
					self:spin():effectmagnitude(0,0,-2)
				end
			end
		},
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "outer ring"),
			InitCommand=function(self)
				self:diffuse( ColorTable["titleBGPattern"] ):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):blend('add')
			end,
			OnCommand=function(self)
				if AnimatedMenu then
					self:spin():effectmagnitude(0,0,3)
				end
			end
		},
	}
end

if currentBGTheme == "Triangles" then
	LoadMenuBG[#LoadMenuBG+1] = Def.ActorFrame {
		Def.Sprite {
		Texture = THEME:GetPathG("_bg", "tri grid"),
		InitCommand=function(self)
			self:diffuse( ColorTable["titleBGPattern"] ):diffusealpha(0.03):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
			:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512)
			:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			if AnimatedMenu then
				self:texcoordvelocity(0.025,0)
			end
		end
		},
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "tri corner");
			InitCommand=function(self) self:vertalign(bottom):horizalign(left):xy(SCREEN_LEFT,SCREEN_BOTTOM) end,
			OnCommand=function(self) self:diffuse( ColorTable["titleBGPattern"] ):blend("add"):diffusealpha(0.14)  end,
		},
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "tri corner");
			InitCommand=function(self) self:zoomx(-1):zoomy(-1):vertalign(bottom):horizalign(left):xy(SCREEN_RIGHT,SCREEN_TOP) end,
			OnCommand=function(self) self:diffuse( ColorTable["titleBGPattern"] ):blend("add"):diffusealpha(0.14) end,
		},
	}
end

if currentBGTheme == "HexagonPattern" then
	LoadMenuBG[#LoadMenuBG+1] = Def.ActorFrame {
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "big grid"),
			InitCommand=function(self)
				self:diffuse( ColorTable["titleBGPattern"] ):diffusealpha(0.05):blend('add'):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT*1.4):customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			end,
			OnCommand=function(self)
				self:rotationx(-20):fadeleft(0.4):faderight(0.4)
				if AnimatedMenu then
					self:texcoordvelocity(0,0.15)
				end
			end
		},
			
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "big grid");
			InitCommand=function(self)
				self:diffuse( ColorTable["titleBGPattern"] ):diffusealpha(0.05):blend('add'):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT*1.4):customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			end,
			OnCommand=function(self)
				self:rotationx(-20):fadeleft(0.4):faderight(0.4)
				if AnimatedMenu then
					self:texcoordvelocity(0,0.15)
				end
			end
		}
	}
end

if currentBGTheme == "CheckerBoard" and currentSubTheme ~= "4" then
	LoadMenuBG[#LoadMenuBG+1] = Def.Sprite {
		Texture = THEME:GetPathG("_retro", "checkerboard"),
		InitCommand=function(self)
			self:diffuse( ColorTable["titleBGPattern" ] ):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+190*1.4):diffusealpha(0.06)
			:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			if AnimatedMenu then
				self:texcoordvelocity(0,0.15)
			end
			self:rotationx(-20):fadeleft(0.4):faderight(0.4)
		end
	}
end


if AnimatedMenu and currentSubTheme == "4" then 
	LoadMenuBG[#LoadMenuBG+1] = Def.Sprite {
		Texture = THEME:GetPathG("_retro", "checkerboard"),
		InitCommand=function(self)
			self:diffuse(color("#FFD400")):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+190*1.8):visible(false)
			:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end;
		OnCommand=function(self)
			if currentSubTheme == "4" then
				self:visible(true)
			end
			self:texcoordvelocity(0,0.30):rotationx(-60):fadetop(0.5)
		end
	}
end

return Def.ActorFrame {
	InitCommand=function(self) self:fov(80) end,
	OnCommand=function(self)
		GAMESTATE:UpdateDiscordGameMode(GAMESTATE:GetCurrentGame():GetName())
		GAMESTATE:UpdateDiscordScreenInfo("Title Menus","",1)
	end,
	Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) self:diffuse( ColorTable["titleBGA"] ):diffusebottomedge( ColorTable["titleBGB"] ) end
	},
	LoadMenuBG
}
