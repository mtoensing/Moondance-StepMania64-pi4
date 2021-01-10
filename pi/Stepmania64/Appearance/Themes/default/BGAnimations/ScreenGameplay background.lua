--[[
	Let's begin by setting the enviroment that this will be placed on.
	We Center it, make a fov so depth can happen, flip the Y axis because Characters
	in StepMania are flipped, and set the Z position depending on Aspect Ratio because
	the z field changes on the current Aspect Ratio, so correct that.
]]
local background = Def.ActorFrame { Name="YOU_WISH_YOU_WERE_PLAYING_BEATMANIA_RIGHT_NOW",
	LoadModule("Options.SmartTiming.lua"),
	UpdateDiscordInfoCommand=function(s)
		local player = GAMESTATE:GetMasterPlayerNumber()
		if GAMESTATE:GetCurrentSong() then
			local title = PREFSMAN:GetPreference("ShowNativeLanguage") and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitFullTitle()
			local songname = title .. " - " .. GAMESTATE:GetCurrentSong():GetGroupName()
			local state = GAMESTATE:IsDemonstration() and "Watching Song" or "Playing Song"
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
			local stats = STATSMAN:GetCurStageStats()
			if not stats then
				return
			end
			local courselength = function()
				if GAMESTATE:IsCourseMode() then
					if GAMESTATE:GetPlayMode() ~= "PlayMode_Endless" then
						return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().. " (Song ".. stats:GetPlayerStageStats( player ):GetSongsPassed()+1 .. " of ".. GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() ..")" or ""
					end
					return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().. " (Song ".. stats:GetPlayerStageStats( player ):GetSongsPassed()+1 .. ")" or ""
				end
			end
			GAMESTATE:UpdateDiscordSongPlaying(GAMESTATE:IsCourseMode() and courselength() or state,songname,GAMESTATE:GetCurrentSong():GetLastSecond())
		end
	end,
	CurrentSongChangedMessageCommand=function(s) s:playcommand("UpdateDiscordInfo") end,
	OnCommand=function(self)
		self:playcommand("UpdateDiscordInfo")
		for pn = 1,2 do
			if GAMESTATE:IsPlayerEnabled("PlayerNumber_P"..pn) then
				if SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn) and SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn):GetChild("NoteField") then
					SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn):GetChild("NoteField"):rotationz(LoadModule("Config.Load.lua")("RotateFieldZ",CheckIfUserOrMachineProfile(pn-1).."/OutFoxPrefs.ini") or 0)
					local Reverse = GAMESTATE:GetPlayerState(pn-1):GetPlayerOptions('ModsLevel_Preferred'):UsingReverse() and -1 or 1
					local recepoffset = (Reverse == -1) and THEME:GetMetric("Player","ReceptorArrowsYReverse") or THEME:GetMetric("Player","ReceptorArrowsYStandard")
					local Zoom = (LoadModule("Config.Load.lua")("MiniSelector",CheckIfUserOrMachineProfile(pn-1).."/OutFoxPrefs.ini") or 100)
					recepoffset = recepoffset * (1-(Zoom/100))
					for _,col in ipairs(SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn):GetChild("NoteField"):get_column_actors()) do
						col:rotationx(LoadModule("Config.Load.lua")("RotateFieldX",CheckIfUserOrMachineProfile(pn-1).."/OutFoxPrefs.ini") or 0)
						:addy((Zoom == 0) and 0 or recepoffset/(Zoom/100))
					end
					SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn):zoom(Zoom/(200/3))
				end
			end
		end
	end
};
local StageConfg = LoadModule("Characters.CallCurrentStage.lua")() ~= "None" and LoadModule("Characters.CallCurrentStage.lua")().."/ModelConfig.ini"
-- If the Master Player or both players have Beginner selected, go to the Beginner helper.
if LoadModule("Characters.NeedsBeginnerHelper.lua")() then
	background[#background+1] = LoadActor("BeginnerHelper.lua")
	return background
end


local function SetTimingData()
	local screen = SCREENMAN:GetTopScreen()
    local screentype = screen:GetScreenType()
    if screen and screentype == "ScreenType_Gameplay" or screentype == "ScreenType_Attract" then
        setenv("song", 	GAMESTATE:GetCurrentSong() )
        setenv("start", getenv("song"):GetFirstBeat() )
        setenv("now",	GAMESTATE:GetSongBeat() )
    end
end

local function UpdateModelRate()
	-- In case the song is on a rate, then we can multiply it.
    -- It also checks for the song's Haste, if you're using that.
    -- Safe check in case Obtaining HasteRate fails
    local MusicRate = 1
    if SCREENMAN:GetTopScreen() then
        if SCREENMAN:GetTopScreen():GetScreenType() == "ScreenType_Gameplay" and SCREENMAN:GetTopScreen():GetHasteRate() then
            MusicRate = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate()*SCREENMAN:GetTopScreen():GetHasteRate()
        end
        local BPM = (GAMESTATE:GetSongBPS()*60)
        
        -- We're using scale to compare higher values with lower values.
        local UpdateScale = scale( BPM, 60, 700, 0.6, 3 );
        
        -- Then take what we have and update depending on the music rate.
        local ToConvert = UpdateScale*MusicRate
        local SPos = GAMESTATE:GetSongPosition()
        
        if not SPos:GetFreeze() and not SPos:GetDelay() and not SCREENMAN:GetTopScreen():IsPaused() then
            return ToConvert
        end
        return 0
    end
    return 0
end

local function CameraRandom()
	if NumCam and StageHasCamera then
        if tobool( Config.Load( "IsCameraTweenSequential",LoadModule("Characters.CallCurrentStage.lua")().."/ModelConfig.ini",false ) ) then
            if CurrentStageCamera > NumCam then
                CurrentStageCamera = 1
            end
            return CurrentStageCamera
        end
        local newnum = math.random( NumCam )
        return ( NumCam > 1 and ( newnum ~= CurrentStageCamera and newnum or math.random( NumCam ) ) ) or NumCam
    end
	return math.random(5)
end

if LoadModule("Characters.AnyoneHasChar.lua")() then
	-- In case location is disabled, but characters are still shown, display
	-- the song's background
	if LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini") == "None" then
		background[#background+1] = Def.ActorProxy{
			OnCommand=function(self) self:sleep(0.01):queuecommand("LoadBG") end;
			LoadBGCommand=function(self)
				if SCREENMAN:GetTopScreen() then
					local childtest = SCREENMAN:GetTopScreen():GetChild("SongBackground"):GetChild("")
					-- Before doing anything, check if the Songbackground exists at all.
					-- Otherwise, we will hit a wall.
					if childtest then
						--[[
							Now set it. The visible order is important, because if we enable it before
							SetTarget, it will attempt to load the destroyed gameplay that was just unloaded.
							That, can also cause the game to hit a wall.
						]]
						self:SetTarget( childtest )
						self:visible(true)
					end
				else
					-- Repeat the process until the ActorProxy obtains confirmation about the BG.
					self:queuecommand("LoadBG")
				end
			end;
			UnloadScreenGameplayMessageCommand=function(self)
				-- Stop the previous loop and unload the ActorProxy.
				self:finishtweening():visible( false )
				-- Go back to the BG check.
				self:queuecommand("LoadBG")
			end;
		};
	end

	local StageHasCamera = FILEMAN:DoesFileExist(LoadModule("Characters.CallCurrentStage.lua")().."/Cameras.lua")
	local CustomCameras = StageHasCamera and LoadActor( LoadModule("Characters.CallCurrentStage.lua")().."/Cameras.lua" ) or {
		-- No camera? Then load the backup camera.
		["InitialTween"] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
		end,
		[1] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
			Camera:rotationx(30):spin():effectmagnitude(0,10,0)
		end,
		[2] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
			Camera:rotationy(45):rotationx(20):rotationz(-30)
		end,
		[3] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
			Camera:rotationy(140):rotationz(10):rotationx(-10)
		end,
		[4] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
			Camera:rotationy(210):rotationx(25)
		end,
		[5] = function(self)
			LoadModule("Characters.ResetCamera.lua")()
			Camera:rotationx(70):z(WideScale(190,290))
		end,
	};

	local t = Def.ActorFrame{
		InitCommand=function(self)
			Camera = self
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):fov(90):rotationy(180):z( WideScale(300,400) ):addy(10)
		end,
		CameraHasChangedMessageCommand=function(self,params)
			CustomCameras[ params.CurrentCamera ]()
		end;
	};

	--Settings & Shortcuts
	local BeatsBeforeNextSegment = 16

	-- Set the time to wait
	local Frm = 1/60

	local NumCam = #CustomCameras
	local CurrentStageCamera = 0

	-- timing manager
	t[#t+1] = Def.Quad{
		OnCommand=function(self) self:visible(false):queuecommand("InitializeTimer") end;
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("InitializeTimer") end;
		InitializeTimerCommand=function(self)
			self:stoptweening():queuecommand("WaitForStart")
			MESSAGEMAN:Broadcast("CameraHasChanged",{ CurrentCamera="InitialTween" })
		end;
		WaitForStartCommand=function(self)
		-- set globals, we need these later.
		SetTimingData()

		-- Clear this one out in case the player restarts the screen.
		-- And to also properly reset the counter if it does.
		setenv("NextSegment",nil)

		self:sleep(Frm)
		if SCREENMAN:GetTopScreen() then
			if getenv("now")<getenv("start") then
				self:queuecommand("WaitForStart")
			else
				MESSAGEMAN:Broadcast("CameraHasChanged",{ CurrentCamera=1 })
				self:sleep(Frm)
				self:queuecommand("TrackTime")
			end
		end
		end,
		TrackTimeCommand=function(self)
		if not getenv("NextSegment") then
			setenv("NextSegment",getenv("now") + BeatsBeforeNextSegment)
		end

		SetTimingData()

		self:sleep(Frm)
		MESSAGEMAN:Broadcast("UpdateModelRates")
		if getenv("now") >= getenv("NextSegment") then
			MESSAGEMAN:Broadcast("CameraHasChanged",{ CurrentCamera=CameraRandom() })
			CurrentStageCamera = CurrentStageCamera + 1
			setenv("NextSegment",getenv("now") + BeatsBeforeNextSegment)
		end
		self:queuecommand("TrackTime")
		end,
	};

	-- Stage Enviroment
	local StageEnv = Def.ActorFrame{ Condition=LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini") ~= "None" };

	--Load the Stage
	StageEnv[#StageEnv+1] = Def.Model {
		Condition=LoadModule("Characters.LocationIsSafeToLoad.lua")();
		Meshes=LoadModule("Characters.GetPathLocation.lua")("",LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini").."/model.txt");
		Materials=LoadModule("Characters.Load_Appropiate_Material.lua")();
		Bones=LoadModule("Characters.GetPathLocation.lua")("",LoadModule("Config.Load.lua")("CurrentStageLocation","Save/OutFoxPrefs.ini").."/model.txt");
		OnCommand=function(self)
			self:cullmode("CullMode_None"):zoom( LoadModule("Config.Load.lua")( "StageZoom",StageConfg ) or 1 )
			:xy( LoadModule("Config.Load.lua")( "StageXOffset",StageConfg,0 ) or 0, LoadModule("Config.Load.lua")( "StageYOffset",StageConfg,0 ) or 0 )
			:queuecommand("UpdateRate")
		end,
		UpdateModelRatesMessageCommand=function(self)
			-- Check function to see how it works.
			self:rate( UpdateModelRate() )
		end,
	};

	t[#t+1] = StageEnv

	--[[
		The actual character.
		Checks if the character is functional, is loaded by the player, and if the Dedi Character Show is enabled.
	]]
	local DAm,PlayerAnimations = 5,{ ["PlayerNumber_P1"] = {}, ["PlayerNumber_P2"] = {}, }

	local function LaunchCharacter(player,isreflection)
		local t,modelset = Def.ActorFrame{},{
			xpos = GAMESTATE:BothPlayersEnabled() and ( (player == PLAYER_1 and 8) or -8 ) or 0,
			RegZoom = LoadModule("Characters.HasBabyCharacter.lua")(player) and 0.7 or 1,
			ModRota = isreflection and {180,180} or {0,0},
			Color = isreflection and color("0.2,0.2,0.2,1") or Color.White,
		};
		-- We have this one value outside because we want to grab an already existing value from the same table.
		modelset.ZoomNum = isreflection and -modelset.RegZoom or modelset.RegZoom;

		if GAMESTATE:IsPlayerEnabled(player) and LoadModule("Characters.IsSafeToLoad.lua")(player) then
			local Char = GAMESTATE:GetCharacter(player)
			-- Load animations into the stack
			for i=1,DAm do PlayerAnimations[player][ #PlayerAnimations[player]+1 ] = Char:GetDanceAnimationPath() end
			PlayerAnimations[player][ DAm+1 ] = Char:GetWarmUpAnimationPath()
			-- Load the Character
			t[#t+1] = LoadActor( Char:GetModelPath() )..{
					OnCommand=function(self)
					self:cullmode("CullMode_None"):x( modelset.xpos )
					:zoom( modelset.ZoomNum ):rotationy( modelset.ModRota[2] ):diffuse( modelset.Color )
					-- Use LoadBones to include the dance animation on the model's available animations.
					for i=1,DAm do self:LoadBones( "dance"..i, PlayerAnimations[player][i] ) end
					-- Load the Warmup animation and play it.
					self:LoadBones( "WarmUp", PlayerAnimations[player][ DAm+1 ] )
					:playanimation( "WarmUp", UpdateModelRate() )
					:queuecommand("UpdateRate")
					end,
					UpdateModelRatesMessageCommand=function(self)
					-- Update Model animation speed depending on song's BPM.
					-- To match SM's way of animation speeds
					-- Check function to see how it works.
					self:rate( UpdateModelRate() )
					if getenv("now")>getenv("start") then
						self:loop(false)
						if self:GetPosition() >= self:GetTotalFrames() then
							local NewDance = math.random(DAm)
							-- Now change the animation to dance once the start threshold hits.
							MESSAGEMAN:Broadcast( player.."DanceAnimationChanged",{dance=NewDance})
						end
					end
					end,
					[player.."DanceAnimationChangedMessageCommand"]=function(self,params)
						self:playanimation( "dance"..params.dance, UpdateModelRate() )
					end;
			};
		end
		return t;
	end

	local AddActors = LoadModule("Characters.CallCurrentStage.lua")().."/AdditionalActors.lua"
	if FILEMAN:DoesFileExist( LoadModule("Characters.CallCurrentStage.lua")().."/AdditionalActors.lua" ) then
		local HasPassedTest = true
		--[[
			Allowing a separate lua script to handle all kinds of things can lead to massive security problems.
			Let's go through every single line on the AdditionalActors lua file for the stage,
			and find any single instance of FILEMAN, PREFSMAN or the kind of command that modifyes game data,
			such as profiles, current modes, external files, etc.
			If we find a single case of it, prevent loading of the script. This won't disable the stage, just the
			AdditionalActors.lua file.
		]]
		local RFile = RageFileUtil.CreateRageFile()
		RFile:Open(AddActors, 1)
		local configcontent = RFile:Read()
		local Banned = {
			"FILEMAN",
			"PREFSMAN",
			"GAMEMAN",
			"GAMESTATE:SetCurrent",
			"ApplyGameCommand",
			"PROFILE:Set",
			"ScreenExit",
			"InsertCredit",
			"THEME:",
			"Rage",
		};

		for line in string.gmatch(configcontent.."\n", "(.-)\n") do
			for v in ivalues( Banned ) do
				if string.find( line, v ) then
					lua.ReportScriptError( "The command (".. string.gsub(line, "	","") ..") is not allowed on the script." )
					HasPassedTest = false
					break
				end
			end
		end

		if HasPassedTest then t[#t+1] = LoadActor( AddActors ) end
	end

	for player in ivalues(PlayerNumber) do
		-- Launch regular character.
		t[#t+1] = LaunchCharacter(player)
		-- Launch character's reflection (If the current stage allows it).
		if tobool( (LoadModule("Config.Load.lua")("AllowModelReflections",StageConfg)) ) then
			t[#t+1] = LaunchCharacter(player, true)
		end
	end;

	-- Cover for players.
	local CoverBG = Def.ActorFrame{};
	CoverBG[#CoverBG+1] = Def.Quad{
		OnCommand=function(self)
			local function GetPOArray(pn) return GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray(1) end
			local function GetPOArrayString(pn) return GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString(1) end
			local BGBright,MasterP = 1-PREFSMAN:GetPreference("BGBrightness"),GAMESTATE:GetMasterPlayerNumber()

			self:FullScreen():diffuse( Alpha( Color.Black, BGBright )  )
			for p in ivalues( PlayerNumber ) do
				if not GAMESTATE:BothPlayersEnabled() and string.find(GetPOArrayString(MasterP), "Cover") then
					self:diffuse( Alpha( Color.Black, BGBright+0.3 )  )
				end
				if GAMESTATE:BothPlayersEnabled() then
					for val in ivalues( GetPOArray(p) ) do
						if string.find(val, "Cover") then
							self:PlayerFade(p, Alpha( Color.Black, 1 ) )
						end
					end
				end
			end
		end;
	};

	background[#background+1] = t;
	background[#background+1] = CoverBG;
end

return background;