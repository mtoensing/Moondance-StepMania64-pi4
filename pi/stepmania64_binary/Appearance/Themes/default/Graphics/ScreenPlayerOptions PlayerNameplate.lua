local PlayerNumber = ...
assert( PlayerNumber )

local bpm_text_zoom = 1

local song_bpms= {}
local bpm_text= "??? - ???"
local function format_bpm(bpm)
	return ("%.0f"):format(bpm)
end

-- Courses don't have GetDisplayBpms.
if GAMESTATE:GetCurrentSong() then
	song_bpms= GAMESTATE:GetCurrentSong():GetDisplayBpms()
	song_bpms[1]= math.round(song_bpms[1])
	song_bpms[2]= math.round(song_bpms[2])
	if song_bpms[1] == song_bpms[2] then
		bpm_text= format_bpm(song_bpms[1])
	else
		bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
	end
end

return Def.ActorFrame {
	Def.Sprite{
		Texture=LoadModule("Options.GetProfileData.lua")(PlayerNumber,false).Image,
		OnCommand=function(s)
			s:setsize( 50,50 ):x( PlayerNumber == PLAYER_1 and -182 or 96 )
		end,
	},
	Def.ActorFrame{
		OnCommand=function(s) s:x( PlayerNumber == PLAYER_2 and -40 or 0 ) end,
		Def.Quad{ OnCommand=function(s) s:setsize( 50,50 ):x( -130 )
			:diffuse(ColorDarkTone(PlayerCompColor(PlayerNumber))):diffusebottomedge(PlayerColor(PlayerNumber))
			:diffusealpha(0.75)
		end },
		Def.Quad{ OnCommand=function(s) s:setsize( 210,50 ):x( 3 )
			:diffuse(ColorDarkTone(PlayerCompColor(PlayerNumber))):diffusebottomedge(PlayerColor(PlayerNumber))
			:diffusealpha(0.75)
		end },
		Def.BitmapText {
			Font="_Condensed Semibold";
			Text=bpm_text;
			Name="BPMRangeOld",
			InitCommand=function(self) self:x(-56):y(-6):maxwidth(88/bpm_text_zoom):shadowlength(2) end;
			OnCommand=function(self) self:zoom(bpm_text_zoom):diffuse(color("#FFFFFF")) end;
		},
		LoadActor(THEME:GetPathG("_StepsDisplayListRow","arrow")) .. {
			Name="Seperator",
			InitCommand=function(self) self:x(-4) end;
			OnCommand=function(self) self:diffuse(ColorLightTone(PlayerColor(PlayerNumber))) end;
		},
		Def.ActorProxy{
			BeginCommand=function(s)
				local CurNoteSkin = GAMESTATE:GetPlayerState(PlayerNumber):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
				s:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) )
				s:zoom(0.7):x( -130 )
			end,
			LuaNoteSkinsChangeMessageCommand=function(self,param)
				if param.pn == PlayerNumber then
					local name = NOTESKIN:GetNoteSkinNames()[param.choice]
					self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(param.choicename)) )
				end
			end,
		},
		Def.BitmapText {
			Font="_Condensed Semibold";
			Text="100 - 200000";
			Name="BPMRangeNew",
			InitCommand= function(self)
				self:x(58):y(-6):maxwidth(88/bpm_text_zoom):zoom(bpm_text_zoom):shadowlength(2)
				local speed, mode= GetSpeedModeAndValueFromPoptions(PlayerNumber)
				self:playcommand("SpeedChoiceChanged", {pn= PlayerNumber, mode= mode, speed= speed})
			end,
			BPMWillNotChangeCommand=function(self) self:stopeffect():diffuse(ColorLightTone(PlayerCompColor(PlayerNumber))) end;
			BPMWillChangeCommand=function(self) self:diffuseshift():effectcolor1(Color.White):effectcolor2(ColorLightTone(PlayerCompColor(PlayerNumber))) end;
			SpeedChoiceChangedMessageCommand= function(self, param)
				if param.pn ~= PlayerNumber then return end
				local text= ""
				local no_change= true
				if param.mode == "x" then
					if not song_bpms[1] then
						text= "??? - ???"
					elseif song_bpms[1] == song_bpms[2] then
						text= format_bpm(song_bpms[1] * param.speed*.01)
					else
						text= format_bpm(song_bpms[1] * param.speed*.01) .. " - " ..
							format_bpm(song_bpms[2] * param.speed*.01)
					end
					no_change= param.speed == 100
				elseif param.mode == "c" or param.mode == "m" or param.mode == "a" then
					text= param.mode .. param.speed
					no_change= param.speed == song_bpms[2] and song_bpms[1] == song_bpms[2]
				else
					no_change= param.speed == song_bpms[2]
					if song_bpms[1] == song_bpms[2] then
						text= param.mode .. param.speed
					else
						local factor= song_bpms[1] / song_bpms[2]
						text= param.mode .. format_bpm(param.speed * factor) .. " - "
							.. param.mode .. param.speed
					end
				end
				self:settext(text)
				if no_change then
					self:queuecommand("BPMWillNotChange")
				else
					self:queuecommand("BPMWillChange")
				end
			end
		}
	}
};