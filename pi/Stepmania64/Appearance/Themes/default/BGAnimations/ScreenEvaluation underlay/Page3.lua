local t = Def.ActorFrame{}
local p = ...
local StgStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(p)
local ClBurned = StgStats:GetCaloriesBurned()
local PlProfile = PROFILEMAN:GetProfile(p) or nil
local PGUID =  PlProfile:GetGUID()
-- The number is the machine profile.
local IsProfileMachine = PlProfile:GetDisplayName() == ""
local CalToday,CalTotal = PlProfile:GetCaloriesBurnedToday(),PlProfile:GetTotalCaloriesBurned()

local Information = {
	{ "CaloriesBurnedSong", ClBurned },
	{ "CaloriesToday", CalToday },
	{ "CaloriesTotal", CalTotal },
};

-- A very useful table...
local NoteTable = getenv("perColJudgeData")

local eval_part_offs = string.find(p, "P1") and -310 or 310
local score_parts_offs = string.find(p, "P1") and -100 or 100

------------------------------------------
-- Items
------------------------------------------
for ind,val in ipairs( Information ) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:xy(_screen.cx +(eval_part_offs-150),_screen.cy-160+60 + 60*ind)
		end;
		Def.BitmapText {
			Font = "_Bold",
			InitCommand=function(self)
				self:zoom(0.6):maxwidth(380):horizalign(left):y(15)
			end;
			OffCommand=function(self)
				self:linear(0.2):diffusealpha(0)
			end;
			Text=ToUpper(Screen.String( val[1]));
		};
		Def.BitmapText {
			Font = "_Condensed Semibold",
			InitCommand=function(self)
				self:zoom(1):maxwidth(260):horizalign(left):y( -10 )
				:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
			end;
			OffCommand=function(self)
				self:linear(0.2):diffusealpha(0)
			end;
			Text=math.floor( val[2] );
		};
	};
end

------------------------------------------
-- Header Title
------------------------------------------
t[#t+1] = Def.BitmapText {
    Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1):xy(_screen.cx +(eval_part_offs),_screen.cy-165+70):maxwidth(260):horizalign(center)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
    end;
    OffCommand=function(self)
        self:linear(0.2):diffusealpha(0)
    end;
    Text=THEME:GetString("ScreenEvaluation","FitnessInfo");
};

------------------------------------------
-- Machine Profile Detector
------------------------------------------
if IsProfileMachine then
	t[#t+1] = Def.BitmapText {
		Font = "_Bold",
		InitCommand=function(self)
			self:zoom(0.5):xy(_screen.cx +(eval_part_offs+160),_screen.cy+65+90):wrapwidthpixels(600):horizalign(right)
			self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
			:diffusealpha(0.5)
		end,
		OffCommand=function(self)
			self:linear(0.2):diffusealpha(0)
		end,
		Text=Screen.String("NoProfileSet")
	};
end

local HasAnyGoal = PlProfile:GetGoalType() < 2

------------------------------------------
-- Goal Marker
------------------------------------------
local Yspace_FitnessGoal = _screen.cy+150
if not IsProfileMachine then
	if HasAnyGoal and not getenv("GoalAchieved"..p) == true then
		local CalGoal=PlProfile:GetGoalCalories()
		local TimGoal=PlProfile:GetGoalSeconds()
		local CurrentGoal=getenv("TargetOutput"..p)

		t[#t+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
				self:zoom(0.7):xy(_screen.cx +(eval_part_offs-140),Yspace_FitnessGoal)
				self:diffuse(Color.White):halign(0)
			end,
			OffCommand=function(self) self:linear(0.2):diffusealpha(0) end,
			Text=Screen.String("CurrentGoal")..":"
		};
		
		t[#t+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
				self:zoom(0.7):xy(_screen.cx +(eval_part_offs+140),Yspace_FitnessGoal):wrapwidthpixels(600)
				self:diffuse(Color.White):halign(1)
			end,
			OffCommand=function(self) self:linear(0.2):diffusealpha(0) end,
			Text=Screen.String("GoalToGo")
		};

		t[#t+1] = Def.BitmapText {
			Font = "_Bold",
			InitCommand=function(self)
				self:zoom(1.2):xy(_screen.cx +(eval_part_offs+90),Yspace_FitnessGoal+2):wrapwidthpixels(600)
				:diffuse(ColorLightTone(PlayerColor(p))):diffusetopedge(ColorLightTone(PlayerCompColor(p)))
				:halign(1)
			end;
			OffCommand=function(self) self:linear(0.2):diffusealpha(0) end;
			Text=CurrentGoal;
		};
	end
	if not HasAnyGoal and not getenv("GoalAchieved"..p) then
		t[#t+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
				self:zoom(0.7):xy(_screen.cx +(eval_part_offs),Yspace_FitnessGoal):wrapwidthpixels(600)
				self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
				:diffusealpha(0.5)
			end,
			OffCommand=function(self) self:linear(0.2):diffusealpha(0) end,
			Text=Screen.String("NoGoal")
		};
	end
	if getenv("GoalAchieved"..p) == true then
		t[#t+1] = Def.BitmapText {
			Font = "_Medium",
			InitCommand=function(self)
				self:zoom(0.7):xy(_screen.cx +(eval_part_offs),Yspace_FitnessGoal):wrapwidthpixels(600)
				self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
				:diffusealpha(1)
			end,
			OffCommand=function(self) self:linear(0.2):diffusealpha(0) end,
			Text=Screen.String("GoalAchieved")
		};
		for i=1,40 do
			t[#t+1] = Def.ActorFrame{
				OnCommand=function(self) self:fov(90):xy(_screen.cx +(eval_part_offs),Yspace_FitnessGoal)
					:bounce():effectperiod(2):effectoffset(i*1.23):effectmagnitude(0,-40,0)
				end,
				OffCommand=function(self) self:linear(0.2):diffusealpha(0) end,
				Def.Quad{
					OnCommand=function(self)
						self:zoom(3):xy( math.random(-160,160),20 ):z( math.random(-40,10) )
						:rainbow():effectoffset(i*1.23)
						:diffusealpha(0.3)
					end;
				};
			};
		end
	end
end

return t;