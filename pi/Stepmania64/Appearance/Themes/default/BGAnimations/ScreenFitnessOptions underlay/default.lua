local t=Def.ActorFrame{};

local function Side(pn)
	if pn == PLAYER_2 then return 1 end
	return -1
end

local pn_to_color_name= {[PLAYER_1]= "PLAYER_1", [PLAYER_2]= "PLAYER_2"}

local itemypos = { -130,0,140 };
local names={ Screen.String("GoalType"), Screen.String("CompletionCondition"), "" }
------------------
-- Data Locals
------------------
local function range(start, stop, step)
	if start == nil then return end

	if not stop then
		stop = start
		start = 1
	end

	step = step or (start < stop and 1 or -1)

	-- if step has been explicitly provided as a positve number
	-- but the start and stop values tell us to decrement
	-- multiply step by -1 to allow decrementing to occur
	if step > 0 and start > stop then
		step = -1 * step
	end

	local t = {}
	while start < stop+step do
		t[#t+1] = start
		start = start + step
	end
	return t
end

local GoalTypes = { "GoalType_Calories","GoalType_Time","GoalType_None" };
local PlayerDataValues = {
	["GoalType_Calories"] = {
		range=range(50,2000,10),
		["PlayerNumber_P1"] = 1,
		["PlayerNumber_P2"] = 1,
	},
	["GoalType_Time"] = {
		range=range(60,7200,30),
		["PlayerNumber_P1"] = 1,
		["PlayerNumber_P2"] = 1,
	},
}
local MenuInd = {
	["VertInd"] = {
		["PlayerNumber_P1"] = 1,
		["PlayerNumber_P2"] = 1,
	},
	["TypeInd"] = {
		["PlayerNumber_P1"] = 1,
		["PlayerNumber_P2"] = 1,
	}
};

local function UpdateGoalStringType(pn)
	if GAMESTATE:IsHumanPlayer(pn) and MenuInd["TypeInd"][pn] <3 then
		-- Get what Goal Type the player has.
		local indx = tostring( GoalTypes[ MenuInd["TypeInd"][pn] ] )
		-- Obtain the current value from the player choice
		local PLDat = PlayerDataValues[indx][pn]
		-- Get the data from the Range table
		local DatRes = PlayerDataValues[indx].range[PLDat]
		local textformat = {
			string.format("%s cal",DatRes),
			SecondsToHHMMSS( DatRes )
		};
		return {textformat[ MenuInd["TypeInd"][pn] ], tonumber(DatRes)}
	end
	return ""
end

for p in ivalues(PlayerNumber) do
	------------------
	-- Color Locals
	------------------	
	local PdarkCol = GameColor.PlayerDarkColors[pn_to_color_name[p]]
	local PBDColor = BoostColor(ColorDarkTone(PlayerColor(p)),0.4)
	local PGradNor = ColorLightTone(PlayerColor(p))
	local PGradCom = ColorLightTone(PlayerCompColor(p))

	t[#t+1] = Def.Quad {
		InitCommand=function(self) self:vertalign(top):xy(SCREEN_CENTER_X+ 200*Side(p) ,SCREEN_TOP):zoomto(400,0)
			:diffuse( PdarkCol )
			if GAMESTATE:IsHumanPlayer(p) then
				self:diffuse( PBDColor )
			end
			self:diffusealpha(0.5) end;
		OnCommand=function(self) self:linear(0.14):zoomto(400,SCREEN_HEIGHT) end;
		OffCommand=function(self) self:sleep(0.2):decelerate(0.2):addy(SCREEN_HEIGHT) end;
	};

	-- Avatar and name
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self) 
			self:diffusealpha(0):xy(SCREEN_CENTER_X+ 200*Side(p) ,SCREEN_TOP+80)
			:sleep(0.5):decelerate(0.2):diffusealpha(1):player(p)
		end;
		Def.Quad {
			InitCommand=function(self) 
				self:zoomto(336,61):vertalign(top) 
				self:diffuse(PlayerColor(p)):diffuserightedge(PlayerCompColor(p))
			end;
			OnCommand=function(self) self:zoomto(336,0):sleep(0.5):decelerate(0.7):zoomto(336,61) end;
		 };
		Def.Sprite {
			InitCommand=function(self) self:horizalign(left):vertalign(top):xy(-164,5) end;
			Texture=LoadModule("Options.GetProfileData.lua")(p)["Image"];
			OnCommand=function(self)
				self:zoomto(52,52)
			end;
		};
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self)
				self:horizalign(left):xy(-100,30):maxwidth(220):skewx(-0.15):queuecommand("Set")
			end;
			OnCommand=function(self) self:diffuse(ColorDarkTone(PlayerDarkColor(p))) end;	
			SetCommand=function(self)
				self:settext(LoadModule("Options.GetProfileData.lua")(p)["Name"])
			end;
		};
	};

	
	local Items = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X+ 200*Side(p) ,SCREEN_CENTER_Y):player(p)
		end;
		OnCommand=function(self)
			self:diffusealpha(0):sleep(0.14):linear(0.14):diffusealpha(1)
		end;
	};
	
	for ind,val in ipairs(itemypos) do
		Items[#Items+1] = Def.Quad{
			OnCommand=function(self)
				self:diffuse( PBDColor ):zoomto(300,50):y( val )
			end;
			PageUpdatedMessageCommand=function(self)
				local vertind = MenuInd["VertInd"][p]
				self:stoptweening():decelerate(0.1)
				:diffuse( PBDColor )
				if vertind == ind and
					(MenuInd["TypeInd"][p] < 3 or (MenuInd["TypeInd"][p] == 1 or MenuInd["TypeInd"][p] == 3))
				then
					self:diffusebottomedge( BoostColor(PGradNor, 0.7) )
				end
			end;
		};
		Items[#Items+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( val-45 ):halign(0):x(-140) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
				self:settext( names[ind] )
			end;
		};
	end

	t[#t+1] = Items;

	Items[#Items+1] = Def.ActorFrame{
		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( itemypos[1]-45 ):halign(0):x(-140) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
				self:settext( names[1] )
			end;
		};
		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( itemypos[1] ) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
			end;
			PageUpdatedMessageCommand=function(self)
				local indx=MenuInd["TypeInd"][p]
				local Trnt=ToEnumShortString( GoalTypes[indx] )
				self:settext( THEME:GetString("ScreenFitnessOptions", Trnt ) )
			end;
		};
		
		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( itemypos[2]-45 ):halign(0):x(-140) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
				self:settext( names[2] )
			end;
		};
		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( itemypos[2] ) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
			end;
			PageUpdatedMessageCommand=function(self)
				self:stoptweening():decelerate(0.1):zoomy(1)
				if MenuInd["TypeInd"][p] == 3 then
					self:zoomy(0)
				end
				if UpdateGoalStringType(p)[1] then
					self:settext( UpdateGoalStringType(p)[1] )
				end
			end;
		};

		Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self) self:zoom(1):y( itemypos[3] ) end;
			OnCommand=function(self)
				self:diffuse( PGradNor ):diffusetopedge( PGradCom )
				self:settext( "Start!" )
			end;
		};
	}
end;

--------------------------------------------------------------------------------
-- Input Controller
--------------------------------------------------------------------------------
local IndLim = 3
local function SetNewGoalType(pn)
	local Pr = PROFILEMAN:GetProfile(pn)
	Pr:SetGoalType( GoalTypes[MenuInd["TypeInd"][pn]] )
	return
end

local function CheckValueOffsets(pn)
	-- Vertical Value
	if MenuInd["VertInd"][pn] > IndLim then MenuInd["VertInd"][pn] = IndLim return end
	if MenuInd["VertInd"][pn] < 1 then MenuInd["VertInd"][pn] = 1 return end

	-- Type
	if MenuInd["TypeInd"][pn] > #GoalTypes then MenuInd["TypeInd"][pn] = #GoalTypes return end
	if MenuInd["TypeInd"][pn] < 1 then MenuInd["TypeInd"][pn] = 1 return end

	--Values
	local GTCal = PlayerDataValues["GoalType_Calories"][pn]
	local GTCalmaxRange = #PlayerDataValues["GoalType_Calories"].range
	local GTTim = PlayerDataValues["GoalType_Time"][pn]
	local GTTimmaxRange = #PlayerDataValues["GoalType_Time"].range

	if GTCal > GTCalmaxRange then PlayerDataValues["GoalType_Calories"][pn] = GTCalmaxRange return end
	if GTCal < 1 then PlayerDataValues["GoalType_Calories"][pn] = 1 return end

	if GTTim > GTTimmaxRange then PlayerDataValues["GoalType_Time"][pn] = GTTimmaxRange return end
	if GTTim < 1 then PlayerDataValues["GoalType_Time"][pn] = 1 return end
	
	SetNewGoalType(pn)
	setenv("APNow", pn)
	SOUND:PlayOnce( THEME:GetPathS("","click") )
	MESSAGEMAN:Broadcast("PageUpdated")
	return
end

local BTInput = {
	-- This will control the menus
	["MenuDown"] = function(PlEv)
		if MenuInd["TypeInd"][PlEv] < 3 then
			MenuInd["VertInd"][PlEv] = MenuInd["VertInd"][PlEv] + 1
			CheckValueOffsets(PlEv)
		else
			MenuInd["VertInd"][PlEv] = 3
			CheckValueOffsets(PlEv)
		end
	end,
	["MenuUp"] = function(PlEv)
		if MenuInd["TypeInd"][PlEv] < 3 then
			MenuInd["VertInd"][PlEv] = MenuInd["VertInd"][PlEv] - 1
			CheckValueOffsets(PlEv)
		else
			MenuInd["VertInd"][PlEv] = 1
			CheckValueOffsets(PlEv)
		end
	end,
	["MenuRight"] = function(PlEv)
		-- Manage option 1
		if MenuInd["VertInd"][PlEv] == 1 then
			MenuInd["TypeInd"][PlEv] = MenuInd["TypeInd"][PlEv] + 1
			CheckValueOffsets(PlEv)
		end
		if MenuInd["VertInd"][PlEv] == 2 then
			if MenuInd["TypeInd"][PlEv] == 1 then
				PlayerDataValues["GoalType_Calories"][PlEv] = PlayerDataValues["GoalType_Calories"][PlEv] + 1
			end
			if MenuInd["TypeInd"][PlEv] == 2 then
				PlayerDataValues["GoalType_Time"][PlEv] = PlayerDataValues["GoalType_Time"][PlEv] + 1
			end
			CheckValueOffsets(PlEv)
		end
	end,
	["MenuLeft"] = function(PlEv)
		-- Manage option 1
		if MenuInd["VertInd"][PlEv] == 1 then
			MenuInd["TypeInd"][PlEv] = MenuInd["TypeInd"][PlEv] - 1
			CheckValueOffsets(PlEv)
		end
		if MenuInd["VertInd"][PlEv] == 2 then
			if MenuInd["TypeInd"][PlEv] == 1 then
				PlayerDataValues["GoalType_Calories"][PlEv] = PlayerDataValues["GoalType_Calories"][PlEv] - 1
			end
			if MenuInd["TypeInd"][PlEv] == 2 then
				PlayerDataValues["GoalType_Time"][PlEv] = PlayerDataValues["GoalType_Time"][PlEv] - 1
			end
			CheckValueOffsets(PlEv)
		end
	end,
	["Start"] = function()
		for PlEv in ivalues(PlayerNumber) do
			if GAMESTATE:IsHumanPlayer(PlEv) and MenuInd["VertInd"][PlEv] == 3 then
				if MenuInd["TypeInd"][PlEv] == 1 then
					PROFILEMAN:GetProfile(PlEv):SetGoalCalories( UpdateGoalStringType(PlEv)[2] )
				end
				if MenuInd["TypeInd"][PlEv] == 2 then
					PROFILEMAN:GetProfile(PlEv):SetGoalSeconds( UpdateGoalStringType(PlEv)[2] )
				end
				SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectPlayMode"):PostScreenMessage("SM_GoToNextScreen",0)
			end
		end
	end,
	["Back"] = function()
		SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenTitleMenu"):Cancel()
	end;
};

local function InputHandler(event)
	-- Safe check to input nothing if any value happens to be not a player.
	-- ( AI, or engine input )
	if not event.PlayerNumber then return end
	local ET = ToEnumShortString(event.type)
	-- Input that occurs at the moment the button is pressed.
	if ET == "FirstPress" or ET == "Repeat" then
		if GAMESTATE:IsHumanPlayer(event.PlayerNumber) and BTInput[event.GameButton] then
			BTInput[event.GameButton](event.PlayerNumber)
			MESSAGEMAN:Broadcast( event.GameButton.. ToEnumShortString(event.PlayerNumber) .."Pressed" )
		end
	end
end

local Controller = Def.ActorFrame{
	OnCommand=function(self)
	MESSAGEMAN:Broadcast("PageUpdated")
	SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
};

t[#t+1] = Controller

return t;