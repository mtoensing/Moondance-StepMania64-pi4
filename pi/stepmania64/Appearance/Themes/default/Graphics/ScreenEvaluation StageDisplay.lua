local curScreen = Var "LoadingScreen";
local curStageIndex = GAMESTATE:GetCurrentStageIndex();
return Def.ActorFrame {
Def.ActorFrame {
			Def.BitmapText {
				Font="_Medium";
				InitCommand=function(self) self:y(-1):zoom(1):shadowlength(1) end;
				BeginCommand=function(self)
					local top = SCREENMAN:GetTopScreen()
					if top then
						if not string.find(top:GetName(),"ScreenEvaluation") then
							curStageIndex = curStageIndex + 1
						end
					end
				self:playcommand("Set")
			end;
			CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end;
			SetCommand=function(self)
				local curStage = GAMESTATE:GetCurrentStage();
				local text = ""
				if GAMESTATE:GetCurrentCourse() then
					text = curStageIndex+1 .. " / " .. GAMESTATE:GetCurrentCourse():GetEstimatedNumStages()
				elseif GAMESTATE:IsEventMode() then
					text = string.format( THEME:GetString("ScreenWithMenuElements","EventStageCounter") , curStageIndex)
				else
					local thed_stage= thified_curstage_index(curScreen:find("Evaluation"))
					if THEME:GetMetric(curScreen,"StageDisplayUseShortString") then
						text = thed_stage
						self:zoom(0.75);
					else
						text = string.format(  THEME:GetString("ScreenWithMenuElements","StageCounter") , thed_stage )
						self:zoom(1);
					end;
				end;
				self:settext( ToUpper(text) )
				-- StepMania is being stupid so we have to do this here;
				self:diffuse(color("#FFFFFF")):diffusetopedge(ColorLightTone(StageToColor(curStage)));
				self:diffusealpha(0):smooth(0.3):diffusealpha(1);
			end;
		};
	};
};