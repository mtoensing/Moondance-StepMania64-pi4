local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
local currentSubTheme = LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini")
local currentBGTheme = LoadModule("Config.Load.lua")("SoundwavesMenuBG","Save/OutFoxPrefs.ini")
local AnimatedMenu = LoadModule("Config.Load.lua")("FancyUIBG","Save/OutFoxPrefs.ini")

local LoadMenuBG = Def.ActorFrame{}
local Spark = Def.ActorFrame{}

if currentBGTheme == "Ocular" then
	LoadMenuBG[#LoadMenuBG+1] = Def.ActorFrame {
		OnCommand=function(self)
			self:diffusealpha(0.11)
		end,
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "inner ring"),
			InitCommand=function(self)
				self:diffuse( ColorTable["swmeGrid"] ):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):blend('add')
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
				self:diffuse( ColorTable["swmeGrid"] ):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):blend('add')
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
			self:diffuse( ColorTable["swmeGrid"] ):diffusealpha(0.03):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
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
			OnCommand=function(self) self:diffuse( ColorTable["swmePattern"] ):blend("add")  end,
		},
		Def.Sprite {
			Texture = THEME:GetPathG("_bg", "tri corner");
			InitCommand=function(self) self:zoomx(-1):zoomy(-1):vertalign(bottom):horizalign(left):xy(SCREEN_RIGHT,SCREEN_TOP) end,
			OnCommand=function(self) self:diffuse( ColorTable["swmePattern"] ):blend("add") end,
		},
	}
end

if currentBGTheme == "HexagonPattern" then
	if AnimatedMenu then 
		LoadMenuBG[#LoadMenuBG+1] = Def.ActorFrame {
			Def.Sprite {
				Texture = THEME:GetPathG("_bg", "small grid"),
				InitCommand=function(self)
					self:diffuse( ColorTable["swmeGrid"] ):diffusealpha(0.05):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+200)
					:customtexturerect(0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256)
					:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
				end,
				OnCommand=function(self)
					self:texcoordvelocity(-0.15,-0.15):rotationx(20)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("_bg", "big grid"),
				InitCommand=function(self)
					self:diffuse( ColorTable["swmePattern"] ):zoomto(SCREEN_WIDTH+150,SCREEN_HEIGHT+200)
					:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512)
					:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
				end,
				OnCommand=function(self)
					self:texcoordvelocity(0,0.12):rotationx(20):fadebottom(1)
				end
			}
		}
		else
		-- Static BG
		LoadMenuBG[#LoadMenuBG+1] = Def.Sprite {
			Texture = THEME:GetPathG("_bg", "hex2 grid"),
			InitCommand=function(self)
				self:diffusealpha(0.03):blend('add'):zoomto(SCREEN_WIDTH+100,SCREEN_HEIGHT+190)
				:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512)
				:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			end
		}
	end
end

if currentBGTheme == "CheckerBoard" then
	if AnimatedMenu then
	LoadMenuBG[#LoadMenuBG+1] = Def.Sprite {
		Texture = THEME:GetPathG("_retro", "checkerboard"),
		InitCommand=function(self)
			self:diffuse( ColorTable["swmePattern" ] ):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+190*1.4):diffusealpha(0.10)
			:customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			self:texcoordvelocity(0,0.15)
			self:rotationx(-20):fadeleft(0.4):faderight(0.4)
		end
	}
	else
		LoadMenuBG[#LoadMenuBG+1] = Def.Sprite {
			Texture = THEME:GetPathG("_retro", "checkerboard"),
			InitCommand=function(self)
				self:diffuse( ColorTable["swmePattern"] ):zoomto(SCREEN_WIDTH*1.4,SCREEN_HEIGHT+190*1.4):diffusealpha(0.10)customtexturerect(0,0,SCREEN_WIDTH*4/512,SCREEN_HEIGHT*4/512):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			end,
			OnCommand=function(self)
				self:rotationx(-20):fadeleft(0.4):faderight(0.4)
			end
		}
	end
end

-- Sparks for Retro theme
if currentSubTheme == "4" and AnimatedMenu then 
		Spark[#Spark+1] = Def.Sprite {
			Name="Flake",
			Texture="_particle normal.png",
			InitCommand=function(self) self:xy(0,-50) end,
			OnCommand=function(self) self:diffuse(ColorLightTone(color("#ffd400"))):diffusealpha(0.5) end,
		}
		for i = 1,30 do
		Spark[#Spark+1] = Def.ActorProxy {
			InitCommand=function(self)
				self:SetTarget(self:GetParent()
					:GetChild("Flake")):zoom(0.6)
			end,
			OnCommand=function(self) 
				local randy = math.random(-200,SCREEN_HEIGHT)
				local randx = math.random(0,SCREEN_WIDTH)
				self:xy(randx,randy)
					:linear((SCREEN_HEIGHT-randy)/200)
					:y(SCREEN_HEIGHT)
					:queuecommand("Loop")
			end,
			LoopCommand=function(self) 
				local randx = math.random(0,SCREEN_WIDTH)
				self:xy(randx,0)
					:linear(4)
					:y(SCREEN_HEIGHT)
					:queuecommand("Loop")
			end,
			StopTweenMessageCommand=function(self)
				self:stoptweening()
			end
		}		
		end
end

return Def.ActorFrame {
	InitCommand=function(self) self:fov(80) end,
	Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) 
			if currentBGTheme == "BlackBackground" then
				self:diffuse(color("#000000"))
			else
				self:diffuse( ColorTable["swmeBGA"] )
				if currentBGtheme ~= "ColorBackground" then
					self:diffusebottomedge( ColorTable["swmeBGB"] )
				end
			end
		end
	},
	LoadMenuBG,
	-- Retro mode
	Spark
}