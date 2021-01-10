local t = Def.ActorFrame{}
local isUltraWide=SCREEN_WIDTH > 1280
local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") )
-- Sort order
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		local player = GAMESTATE:GetMasterPlayerNumber()
		GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
		if GAMESTATE:IsCourseMode() then
			GAMESTATE:UpdateDiscordScreenInfo("Selecting Course","",1)
		else
			local StageIndex = GAMESTATE:GetCurrentStageIndex()
			GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Stage ".. StageIndex+1 .. ")	","",1)
		end
		self:xy( isUltraWide and  SCREEN_CENTER_X+300 or SCREEN_RIGHT-340, SCREEN_TOP+30 ):diffusealpha(0):sleep(0.5):smooth(0.3):diffusealpha(1) 
	end,
	OffCommand=function(self) self:smooth(0.175):diffusealpha(0) end,
    Def.Sprite {
		Texture=THEME:GetPathG("ScreenSelectMusic","sort icon"),
		InitCommand=function(self) self:xy(-40,0) end,
		OnCommand=function(self)
			setenv("NewOptions","Main")
			setenv("CurrentlyInSong",false)
			self:diffuse( ColorTable["headerTextColor"] ):diffusebottomedge( ColorTable["headerTextGradient"] )
		end
	},
	Def.BitmapText {
		Font="_Bold",
		InitCommand=function(self) 
			self:xy(0,0):zoom(1):maxwidth(200):horizalign(left):maxwidth(240) 
				:diffuse( ColorTable["headerTextColor"] ):diffusebottomedge( ColorTable["headerTextGradient"] )
		end,
		OnCommand=function(self) self:queuecommand("Set") end,
		SortOrderChangedMessageCommand=function(self) self:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end,
		SetCommand=function(self)
		   local sortorder = GAMESTATE:GetSortOrder()
		   if sortorder then
				self:finishtweening():settext( ToUpper(SortOrderToLocalizedString(sortorder)) )
				self:queuecommand("Refresh")
			else
				self:settext("")
				self:queuecommand("Refresh")
		   end
		end
	}
}

-- Stage display
if not GAMESTATE:IsCourseMode() then
t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathG("ScreenWithMenuElements", "StageDisplay")) .. {
		InitCommand=function(self) self:xy( isUltraWide and SCREEN_CENTER_X+120 or SCREEN_RIGHT-520,SCREEN_TOP+32) end,
		OnCommand=function(self)
			if PREFSMAN:GetPreference("MenuTimer") == true then
				self:addx(-220)
			end
			self:diffusealpha(0):sleep(0.5):smooth(0.3):diffusealpha(1) 
		end,
		OffCommand=function(self) self:smooth(0.175):diffusealpha(0) end
	}
}
end

for p in ivalues(PlayerNumber) do
	GAMESTATE:Env()["ChartData"..p] = {}
	setenv("GoalAchieved"..p , false)
end

return t