
local t = Def.ActorFrame {};
local baseQuadWidth=IsWidescreen() and 614 or 200
local artistStripeHeight=48
local playerStripeHeight=56
local function p2paneoffset() if IsWidescreen() == true then return 862/2 else return 270.5 end; end;
local coursediffoffset = 600

local function PercentScore(pn)
	local t = Def.BitmapText {
		Font="_Medium";
		InitCommand=function(self) self:horizalign(left):zoom(1) end;
		BeginCommand=function(self) self:playcommand("Set") end;
		SetCommand=function(self)
			local SongOrCourse, StepsOrTrail;
			if GAMESTATE:IsCourseMode() then
				SongOrCourse = GAMESTATE:GetCurrentCourse();
				StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
			else
				SongOrCourse = GAMESTATE:GetCurrentSong();
				StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
			end;

			local profile, scorelist;
			local text = "";
			if SongOrCourse and StepsOrTrail then
				local st = StepsOrTrail:GetStepsType();
				local diff = StepsOrTrail:GetDifficulty();
				local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
				local cd = GetCustomDifficulty(st, diff, courseType);

				if PROFILEMAN:IsPersistentProfile(pn) then
					-- player profile
					profile = PROFILEMAN:GetProfile(pn);
				else
					-- machine profile
					profile = PROFILEMAN:GetMachineProfile();
				end;

				scorelist = profile:GetHighScoreList(SongOrCourse,StepsOrTrail);
				assert(scorelist)
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					text = string.format("%.2f%%", topscore:GetPercentDP()*100.0);
					-- 100% hack
					if text == "100.00%" then
						text = "100%";
					end;
				else
					text = string.format("%.2f%%", 0);
				end;
			else
				text = "";
			end;
			self:settext(text);
		end;
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
		CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end;
	};

	if pn == PLAYER_1 then
		t.CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	else
		t.CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
		t.CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end;
	end

	return t;
end

for pn in ivalues(PlayerNumber) do
-- Backdrop
t[#t+1] = Def.ActorFrame {
	OffCommand=function(self) self:sleep(0.24):decelerate(0.4):diffusealpha(0) end;
	-- Player color
	Def.Quad {
		InitCommand=function(self)
			local paneloffset = string.find(pn, "P1") and 0 or p2paneoffset();
			self:horizalign(left):vertalign(top)
			self:x(paneloffset):y(coursediffoffset-playerStripeHeight)
			self:zoomto(p2paneoffset(),178):diffuse(color("0,0,0,0")) 
		end;
		OnCommand=function(self)
			if GAMESTATE:IsHumanPlayer(pn) == true then
				self:smooth(0.2):diffuse(color("0,0,0,0.5"));
			else
				self:diffusealpha(0):smooth(0.2):diffuse(PlayerDarkColor(pn)):diffusealpha(0.2)
			end;
		end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:smooth(0.2):diffuse(color("0,0,0,0.5"));
			end;
		end;
	};	
	-- Difficilty color
	Def.ActorFrame {
			InitCommand=function(self)
			local paneloffset = string.find(pn, "P1") and 0 or p2paneoffset();
				self:x(paneloffset)
			end;
			OnCommand=function(self)
				if GAMESTATE:IsHumanPlayer(pn) == true then
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:visible(true):diffusealpha(0):sleep(1.3):decelerate(0.4):diffusealpha(1);
				end;
			end;
		Def.Quad {
			InitCommand=function(self)
				self:horizalign(left):vertalign(top):x(0):y(coursediffoffset):zoomto(p2paneoffset(),76):diffuse(color("0,0,0,0"))
			end;
			["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end; 
			ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			SetCommand=function(self)
				local song = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
				local stepsData = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)(GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)
				if song then 
					if stepsData ~= nil then
						local st = stepsData:GetStepsType();
						local diff = stepsData:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and song:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:finishtweening():linear(0.2)
						self:diffuse(ColorMidTone(CustomDifficultyToColor(cd))):diffuseleftedge(BoostColor(ColorMidTone(CustomDifficultyToColor(cd)),1.2)):diffusealpha(0.5);
					else
					end
				else
				end
			end	
		};
		-- Difficulty name
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self)
				self:zoom(1.25):y(coursediffoffset+30):x(20):maxwidth(180):horizalign(left)
			end;
		  OnCommand=function(self)
			self:diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;			  
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self,param)
					if param.Player == pn then
						self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(1) 
					end;
				end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				local song = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
				local stepsData = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)(GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)
				if song then 
					if stepsData ~= nil then
						local st = stepsData:GetStepsType();
						local diff = stepsData:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and song:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(ToUpper(THEME:GetString("CustomDifficulty",ToEnumShortString(diff))))
						self:diffuse(color("#FFFFFF"))
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};			
		Def.BitmapText {
		  Font="_Plex Numbers 60px";
		  InitCommand=function(self)
			self:zoom(0.75):y(coursediffoffset+42):x(IsWidescreen() and 316 or 180):maxwidth(180):horizalign(right)
		  end;
		  OnCommand=function(self)
			self:diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;			  
		  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end; 
		  PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(1)
			end;
		  end;
		  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
		  SetCommand=function(self)
			local song = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
			local stepsData = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)(GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)
			if song then 
				if stepsData ~= nil then
					local st = stepsData:GetStepsType();
					local diff = stepsData:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and song:GetCourseType() or nil;
					local cd = GetCustomDifficulty(st, diff, courseType);
					self:settext(stepsData:GetMeter())
					self:diffuse(color("#FFFFFF"));
				else
					self:settext("")
				end
			else
				self:settext("")
			end
		  end
		};			
		-- Style
		Def.BitmapText {
		  Font="_Medium";
		  InitCommand=function(self)
			self:zoom(1):y(coursediffoffset+50):x(20):maxwidth(180):horizalign(left) 
		  end;
		  OnCommand=function(self)
			self:diffusealpha(0):smooth(0.2):diffusealpha(1)
		  end;			  
			  ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end; 
			  PlayerJoinedMessageCommand=function(self,param)
				if param.Player == pn then
					self:queuecommand("Set"):diffusealpha(0):smooth(0.3):diffusealpha(1)
				end;
			  end;
			  ChangedLanguageDisplayMessageCommand=function(self) self:queuecommand("Set") end;
			  SetCommand=function(self)
				local song = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse()) or GAMESTATE:GetCurrentSong()
				local stepsData = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)(GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn)) or GAMESTATE:GetCurrentSteps(pn)
				if song then 
					if stepsData ~= nil then
						local st = stepsData:GetStepsType();
						local diff = stepsData:GetDifficulty();
						local courseType = GAMESTATE:IsCourseMode() and song:GetCourseType() or nil;
						local cd = GetCustomDifficulty(st, diff, courseType);
						self:settext(THEME:GetString("StepsType",ToEnumShortString(st)));
						self:diffuse(color("#FFFFFF"));
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			  end
		};	
		Def.ActorFrame {
		OnCommand=function(self) self:diffusealpha(0):linear(0.2):diffusealpha(1) end;
			Def.BitmapText {
				Font="_Condensed Medium";
				InitCommand=function(self) self:horizalign(left):x(IsWidescreen() and 330 or 188):y(coursediffoffset+24):zoom(0.75):diffuse(color("0.9,0.9,0.9")):shadowlength(1)  end;
				Text=ToUpper(THEME:GetString("PaneDisplay","MachineHigh") .. ":");
			};	
			StandardDecorationFromTable("PercentScore"..ToEnumShortString(pn), PercentScore(pn)) .. {
				InitCommand=function(self) self:x(IsWidescreen() and 330 or 188):y(coursediffoffset+50):maxwidth(90) end;
			};
		};
	};
};

------- Heading
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		local paneloffset = string.find(pn, "P1") and 0 or p2paneoffset();
		self:horizalign(left):vertalign(top):x(paneloffset):y(450+46+artistStripeHeight):visible(GAMESTATE:IsHumanPlayer(pn))
		end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true):diffusealpha(0):addy(200):decelerate(0.4):diffusealpha(1):sleep(0.2):smooth(0.75):addy(-200);
		end;
	end;
	OffCommand=function(self)
		self:sleep(0.24):decelerate(0.4):diffusealpha(0)
	end;
	Def.Quad {
		InitCommand=function(self)
			self:horizalign(left):vertalign(top):zoomto(p2paneoffset(),playerStripeHeight)
		end;
		OnCommand=function(self)
			self:diffuse(PlayerColor(pn)):diffuserightedge(PlayerCompColor(pn))
		end;
	};
	Def.Quad {
		InitCommand=function(self) self:horizalign(left):vertalign(top):zoomto(48,48):xy(6,4) end;
		OnCommand=function(self)
			self:diffuse(ColorDarkTone(PlayerColor(pn)))
		end;
	};
	Def.BitmapText {
		Font="_Bold";
		InitCommand=function(self)
			self:horizalign(left):vertalign(top):addx(60):addy(22):zoom(1):maxwidth(IsWidescreen() and 220 or 150):skewx(-0.15):queuecommand("Set")
		end;
		OnCommand=function(self) self:diffuse(ColorDarkTone(PlayerDarkColor(pn))) end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:queuecommand("Set")
			end;
		end;		
		SetCommand=function(self)
			self:settext(LoadModule("Options.GetProfileData.lua")(pn)["Name"])
		end;
	};
	-- Profile picture?
	Def.Sprite {
		InitCommand=function(self) self:horizalign(left):vertalign(top):xy(6,4) end;
		Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"];
		OnCommand=function(self)	
			self:zoomto(48,48)
		end;
	};
};

-- Show when not joined
t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			local paneloffset = string.find(pn, "P1") and 0 or p2paneoffset();
			self:horizalign(center):vertalign(middle):y(SCREEN_CENTER_Y+250):visible(not GAMESTATE:IsHumanPlayer(pn))	
			if IsWidescreen() == true then
				self:x(paneloffset+220)
			else 
				self:x(paneloffset+136)
			end;
		end;
		PlayerJoinedMessageCommand=function(self,param)
			if param.Player == pn then
				self:decelerate(0.3):diffusealpha(0)
				end;
			end;	
		LoadActor(THEME:GetPathG("ScreenSelectMusic","JoinMarker")).. {
			InitCommand=function(self) 
				self:diffuse(ColorMidTone(PlayerColor(pn)))
			end;
			OnCommand=function(self)
				self:diffusealpha(0):zoomy(0.6):sleep(1):decelerate(0.4):zoomy(1):diffusealpha(1)
				self:diffuseshift():effectcolor1(ColorMidTone(PlayerColor(pn))):effectcolor2(ColorMidTone(PlayerCompColor(pn))):effectperiod(4)
			end;
			OffCommand=function(self)
				self:stoptweening():decelerate(0.3):diffusealpha(0)
			end;
		};
		Def.BitmapText {
			Font="_Bold";
			InitCommand=function(self) self:horizalign(center) end;
			OnCommand=function(self)
				self:diffusealpha(0):sleep(1.5):decelerate(0.4):diffusealpha(1)
			end;
			OffCommand=function(self)
				self:stoptweening():stopeffect():decelerate(0.3):diffusealpha(0)
			end;
			Text=ToUpper(THEME:GetString("ScreenSelectMusic","Start To Join"));
		};	
	};
		
end;

return t;
