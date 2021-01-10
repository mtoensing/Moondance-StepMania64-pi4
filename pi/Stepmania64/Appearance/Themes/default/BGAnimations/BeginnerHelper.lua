local background = Def.ActorFrame {}
if PREFSMAN:GetPreference("EnableBeginnerHelperBackgrounds") then
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
	}
else
	background[#background+1] = Def.Quad {
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT) end,
		OnCommand=function(self) self:diffuse(color("#08125D")):diffusebottomedge(color("#2B3268")) end,
	}
end


-- Player actorframe
local t = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):fov(90):z( WideScale(300,401) ):addy(10):rotationx(45)
	end
}

-- all the settings for the BeginnerHelper.
local SettingsBoard = {
	-- Available animations for the character.
	BeginnerSteps = {
		{"Left", "step-left"},
		{"Down", "step-down"},
		{"Up", "step-up"},
		{"Right", "step-right"},
		{"LeftRight", "step-jumplr"},
	},
	Frm = 1/60,
	DancePadLoc = "/Characters/DancePad.txt",
	Helper_StepCircle = THEME:GetPathG("BeginnerHelper","StepCircle"),
	AreaMargin = IsUsingWideScreen() and 16 or 12,
	StepCircleLocations = {
		{-4,0, "Left"},
		{0,3, "Down"},
		{0,-3, "Up"},
		{4,0, "Right"},
	},
}

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

local prevval = ''
if LoadModule("Characters.AnyoneHasChar.lua")() then
	for player in ivalues(PlayerNumber) do
		if GAMESTATE:IsPlayerEnabled(player) and LoadModule("Characters.IsSafeToLoad.lua")(player) then
			local Char = GAMESTATE:GetCharacter(player)
			local CharacterPath = Char:GetCharacterDir()
			local Margin = player == PLAYER_1 and -SettingsBoard.AreaMargin or SettingsBoard.AreaMargin
			-- Load the DancePad
			if FILEMAN:DoesFileExist( SettingsBoard.DancePadLoc ) then
				t[#t+1] = LoadActor( SettingsBoard.DancePadLoc )..{
					OnCommand=function(self)
					-- The regular DancePad that is often used in StepMania is not centered at all.
					self:cullmode("CullMode_None"):x( Margin+6 )
					end,
				};

				-- Load StepCircle
				local SCircle = Def.ActorFrame{
					OnCommand=function(self)
						self:rotationx(-75)
						_G["SCircle"..player] = self;
					end;
					NoteWillCrossMessageCommand=function(self,param)
						local IsMine,Trk,btn = param.IsMine,param.NumTracks,param.ButtonName
						local MsgCross = param.NumMessagesFromCrossed
						if MsgCross == 1 and btn and not IsMine then
							_G["SCircle"..player]:GetChild(btn):playcommand("Appear")
						end
					end;
				};
				if FILEMAN:DoesFileExist( SettingsBoard.Helper_StepCircle ) then
					for val in ivalues(SettingsBoard.StepCircleLocations) do
						SCircle[#SCircle+1] = LoadActor( SettingsBoard.Helper_StepCircle )..{
							Name=val[3];
							OnCommand=function(self)
								self:xy( val[1]+Margin,val[2] ):zoom(0.1)
								:zoom(0)
							end;
							AppearCommand=function(self)
								local MUpdate = UpdateModelRate()*1.5
								self:finishtweening():zoom(0.1):linear( 0.3/(MUpdate/2) ):zoom(0)
							end;
						};
					end
				end

				t[#t+1] = SCircle
			end

			-- Load the Character
			t[#t+1] = Def.Model {
				Meshes=Char:GetModelPath(),
				Materials=Char:GetModelPath(),
				Bones=Char:GetRestAnimationPath(),
				OnCommand=function(self)
				self:cullmode("CullMode_None")
				:zoom( LoadModule("Characters.HasBabyCharacter.lua")(player) and 0.7 or 1 ):x( Margin )
				-- Use LoadBones to include the dance animation on the model's available animations.
				for fnm in ivalues(SettingsBoard.BeginnerSteps) do
					local Floc = "./Characters/BeginnerHelper_"..fnm[2]..".bones.txt"
					if FILEMAN:DoesFileExist( Floc ) then
						self:LoadBones( fnm[1], Floc )
					end
				end
				self:queuecommand("UpdateRate")
				end,
				-- Update Model animation speed depending on song's BPM.
				-- To match SM's way of animation speeds
				UpdateRateCommand=function(self)
				-- Check function to see how it works.
				self:sleep(SettingsBoard.Frm)
				if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():IsPaused() then
					self:rate(0)
				end
				if self:GetPosition() >= self:GetTotalFrames() then
					self:playanimation( "default", UpdateModelRate()*1.5 )
					:loop(true):rotationy(0)
				else
					self:rate( UpdateModelRate()*1.5 )
				end
				self:queuecommand("UpdateRate")
				end,
				NoteWillCrossMessageCommand=function(self,param)
					local MUpdate = UpdateModelRate()*1.5
					local NotesToPlay,StrRes,UpTime = {},'',MUpdate/0.6
					local IsMine,Trk,btn = param.IsMine,param.NumTracks,param.ButtonName
					local MsgCross = param.NumMessagesFromCrossed
					-- This note will cross in 200ms, so activate the command within the range.
					if MsgCross == 1 then
						-- Only register the previous button if there's only 1 note per track/row.
						if Trk == 1 then prevval = btn end
						-- We have more than one Track (NoteColumn) with a note?
						if Trk > 1 then
							NotesToPlay[#NotesToPlay+1] = btn
							-- Parsing time!
							for val in ivalues(NotesToPlay) do
								if prevval ~= val then
									StrRes = prevval .. val
								end
							end
						end
						-- Obtain the Name of the note that is about to cross.
						if btn and not IsMine then
							-- Stop the loop. We need to change the animation to the corresponding note.
							self:loop(false):finishtweening()
							local AnimToPlay = Trk == 1 and btn or StrRes
							self:playanimation( AnimToPlay, UpTime )
							if Trk > 1 and StrRes ~= "LeftRight" then
								self:playanimation( "LeftRight", UpTime )
							end

							-- Tween table.
							-- When there's more than 1 note, then apply a tween from the table.
							-- x,z,yrot
							local Tweens = {
								["DownUp"] = {0,0,90},
								["LeftDown"] = {0,0,45},
								["LeftUp"] = {-2,-2,-45},
								["UpRight"] = {2,-2,45},
								["DownRight"] = {2,1,-45},
							};
							if Tweens[StrRes] then
								self:decelerate( 0.6/UpTime )
								:rotationy( Tweens[StrRes][3] ):x( Margin+Tweens[StrRes][1] ):z( Tweens[StrRes][2] )
								:sleep( 0.2/UpTime )
								:decelerate( 0.6/UpTime )
								:rotationy( 0 ):x( Margin ):z( 0 )
							end
							if Trk == 4 then
								self:decelerate( 0.6/MUpdate ):rotationy(-45):sleep( 0.2/MUpdate )
								:decelerate( 0.6/MUpdate ):rotationy(0)
							end
							-- While that's going on, go back to the UpdateRate command to loop the
							-- check to return to Rest.
							self:queuecommand("UpdateRate")
						end
					end
				end;
			};
		end
	end
end;

background[#background+1] = t;

return background;
