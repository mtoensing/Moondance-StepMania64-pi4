local t = Def.ActorFrame{}
local p = ...

local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local playedStages = STATSMAN:GetStagesPlayed();
local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage")
-- Only show the last 9 played stages.
for i=1,9 do
    if STATSMAN:GetPlayedStageStats(i) then
        local playedStageStats = STATSMAN:GetPlayedStageStats(i)
        -- Base
        t[#t+1] = Def.ActorFrame {
            InitCommand=function(self)
                self:y(SCREEN_CENTER_Y-296+(70*(i-1))):diffusealpha( 1 - (i*0.06) )
            end;
                -- Text banner
                Def.ActorFrame {
                OnCommand=function(self)
                    self:diffusealpha(0):sleep(0.1*(i-1)):decelerate(0.3):diffusealpha(1)
                end;
                OffCommand=function(self)
                    self:sleep(0.04*(i-1)):decelerate(0.2):diffusealpha(0)
                end;
                    Def.Quad {
                    InitCommand=function(self)
                        self:zoomto(336,70):vertalign(top):diffuse(color("#000000")):diffusealpha(0.75)
                    end;
                    },
                    Def.Sprite {
                    InitCommand=function(self) self:vertalign(top):diffusealpha(0.25):fadeleft(1) end,
                    OnCommand=function(self) 
                    local curSong = playedStageStats:GetPlayedSongs()[1];	
                        if curSong and curSong:GetBannerPath() then
                            self:Load( curSong:GetBannerPath() )
                            :scaletoclipped(336,70)
                        end
                    end;
                    },
                    Def.BitmapText {
                        Font="SongTitle font",
                        InitCommand=function(self) self:halign(0):x(-152):vertalign(top):y(0+20-12):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.9):maxwidth(160/0.9) end;
                        OnCommand=function(self) 
                        local curSong = playedStageStats:GetPlayedSongs()[1];	
                            self:settext(nativeTitle and curSong:GetDisplayMainTitle() or curSong:GetTranslitMainTitle(), curSong:GetTranslitMainTitle() )
                            if curSong:GetDisplaySubTitle() ~= "" then
                                self:addy(-7)
                            end
                        end;
                    },				
                    
                    Def.BitmapText {
                        Font="SongSubTitle font",
                        InitCommand=function(self) self:halign(0):x(-152):vertalign(top):y(12+20-12):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.7):maxwidth(160/0.7) end;
                        OnCommand=function(self) 
                            local curSong = playedStageStats:GetPlayedSongs()[1];	
                            self:settext(nativeTitle and curSong:GetDisplaySubTitle() or curSong:GetTranslitSubTitle())
                        end;
                    },			
                    
                    Def.BitmapText {
                        Font="SongTitle font",
                        InitCommand=function(self) self:halign(0):x(-152):vertalign(top):y(32):diffuse(color("#FFFFFF")):shadowlength(1):zoom(0.5):maxwidth(160/0.75) end;
                        OnCommand=function(self) local curSong = playedStageStats:GetPlayedSongs()[1];	
                            self:settext(nativeTitle and curSong:GetDisplayArtist() or curSong:GetTranslitArtist())
                            if curSong:GetDisplaySubTitle() ~= "" then
                                self:addy(11)
                            end;
                        end;
                    },
                };
            };
        -- Score
        local pStageStats = playedStageStats:GetPlayerStageStats( p ); 
        t[#t+1] = Def.BitmapText {
            Font="_Plex Numbers 40px",
            InitCommand=function(self)
            self:zoom(0.75):maxwidth(140):x(140+5):y(SCREEN_CENTER_Y-296+23+(70*(i-1))):shadowlength(2)
            end;
            BeginCommand=function(self)
                self:diffuse(ColorLightTone(PlayerCompColor(p))):diffusebottomedge(ColorLightTone(PlayerColor(p))):horizalign(right)
            end,
            OnCommand=function(self)
                if PREFSMAN:GetPreference("PercentageScoring") then
                    self:settext(FormatPercentScore(pStageStats:GetPercentDancePoints()))
                else
                    self:settext(pStageStats:GetScore())
                end;
            local diff = pStageStats:GetPlayedSteps()[1]:GetDifficulty();
            local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
            local cd = GetCustomDifficulty(st, diff, courseType);
            self:diffusealpha(0):sleep(0.1*(i-1)):decelerate(0.3):diffusealpha( 1 - (i*0.06) )
            end,
            OffCommand=function(self)
                self:sleep(0.04*(i-1)):decelerate(0.2):diffusealpha(0)
            end
        }
        
        t[#t+1] = Def.BitmapText {
            Font="_Bold",
            InitCommand=function(self)
            self:zoom(0.6):maxwidth(140):x(94+5):y(SCREEN_CENTER_Y-296+54+(70*(i-1))):shadowlength(2)
            end;
            BeginCommand=function(self)
                self:diffuse(ColorLightTone(PlayerCompColor(p))):diffusebottomedge(PlayerColor(p)):horizalign(right)
            end,
            OnCommand=function(self)
            local diff = pStageStats:GetPlayedSteps()[1]:GetDifficulty();
            local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
            local cd = GetCustomDifficulty(st, diff, courseType);
            self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)) .. "  " .. pStageStats:GetPlayedSteps()[1]:GetMeter());
            self:diffuse(CustomDifficultyToColor(cd));
            self:diffusealpha(0):sleep(0.1*(i-1)):decelerate(0.3):diffusealpha( 1 - (i*0.06) )
            end,
            OffCommand=function(self)
                self:sleep(0.04*(i-1)):decelerate(0.2):diffusealpha(0)
            end
        }

        t[#t+1] = Def.Sprite{
            Texture=THEME:GetPathG("GradeDisplay", "Grade " .. pStageStats:GetGrade()),
			OnCommand=function(self)
                self:x(130+5):y(SCREEN_CENTER_Y-296+54+(70*(i-1))):SetTextureFiltering(true)
                :zoom(0.25):diffusealpha(0):sleep(0.1*(i-1)):decelerate(0.3):diffusealpha(1)
			end;
			OffCommand=function(self)
			    self:decelerate(0.3):diffusealpha(0)
			end;
		}
    end
end

return t