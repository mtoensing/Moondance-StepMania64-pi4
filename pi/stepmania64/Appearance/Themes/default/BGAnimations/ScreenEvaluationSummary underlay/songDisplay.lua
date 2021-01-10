local t = Def.ActorFrame {};
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local playedStages = STATSMAN:GetStagesPlayed();
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage") and 1 or 0

for i=1,playedStages do
local playedStageStats = STATSMAN:GetPlayedStageStats(i);
-- Base
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y-290+(60*(i-1)))
	end;
		-- Text banner
		Def.ActorFrame {
		OnCommand=function(self)
			self:diffusealpha(0):sleep(0.2*(i-1)):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:sleep(0.2*(i-1)):decelerate(0.2):diffusealpha(0)
		end;
			Def.Quad {
			InitCommand=function(self)
				self:zoomto(700,70):vertalign(top):y(0):diffuse(color("#000000")):diffusealpha(0.75)
				end;
			},
			Def.BitmapText {
				Font="_Bold",
				InitCommand=function(self) self:vertalign(top):y(0+20):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.75):maxwidth(330) end;
				OnCommand=function(self) 
				local curSong = playedStageStats:GetPlayedSongs()[1];	
					local text = nativeTitle and curSong:GetDisplayMainTitle() or curSong:GetTranslitMainTitle()
					self:settext(text, curSong:GetTranslitMainTitle())
					if curSong:GetDisplaySubTitle() ~= "" then
						self:addy(-5)
					end
				end;
			},				
			
			Def.BitmapText {
				Font="_Bold",
				InitCommand=function(self) self:vertalign(top):y(12+20):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.6):maxwidth(330) end;
				OnCommand=function(self) 
					local curSong = playedStageStats:GetPlayedSongs()[1];	
					local text = nativeTitle and curSong:GetDisplaySubTitle() or curSong:GetTranslitSubTitle()
					self:settext(text, curSong:GetTranslitSubTitle())
				end;
			},			
			
			Def.BitmapText {
				Font="_Medium",
				InitCommand=function(self) self:vertalign(top):y(20+20):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.5):maxwidth(330) end;
				OnCommand=function(self) local curSong = playedStageStats:GetPlayedSongs()[1];	
					local text = nativeTitle and curSong:GetDisplayArtist() or curSong:GetTranslitArtist()
					self:settext(text, curSong:GetTranslitArtist())
					if curSong:GetDisplaySubTitle() ~= "" then
						self:addy(8)
					end;
				end;
			},
		};
	};
-- Score
for ip, pn in ipairs(GAMESTATE:GetHumanPlayers()) do
	local pStageStats = playedStageStats:GetPlayerStageStats( pn ); 
	local x_pos = string.find(pn, "P1") and SCREEN_CENTER_X-240 or SCREEN_CENTER_X+240;
	t[#t+1] = Def.BitmapText {
		Font="_plex sans condensed score 32px",
		InitCommand=function(self)
		self:zoom(1):maxwidth(140):x(x_pos):y(SCREEN_CENTER_Y-290+30+(60*(i-1)))
		end;
		BeginCommand=function(self)
			self:diffuse(ColorLightTone(PlayerCompColor(pn))):diffusebottomedge(PlayerColor(pn)):horizalign(center)
		end,
		OnCommand=function(self)
			if PREFSMAN:GetPreference("PercentageScoring") then
				self:settext(FormatPercentScore(pStageStats:GetPercentDancePoints()))
			else
				self:settext(pStageStats:GetScore())
			end;
		self:diffusealpha(0):sleep(0.2*(i-1)):decelerate(0.3):diffusealpha(1)
		end;
		OffCommand=function(self)
			self:sleep(0.2*(i-1)):decelerate(0.2):diffusealpha(0)
		end;
	};
end;

end;

return t;
