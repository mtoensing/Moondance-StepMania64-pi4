local t = Def.ActorFrame{
	OnCommand=function(self)
		if LoadModule("Characters.AnyoneHasChar.lua")() then
			if SCREENMAN:GetTopScreen():GetChild("SongBackground") then
				local SBG_sc = SCREENMAN:GetTopScreen():GetChild("SongBackground"):GetChild("")
    			local BGBrightness = SBG_sc:GetChild("")[5]:GetChild("BrightnessOverlay")
    			for i=1,3 do
        			BGBrightness[i]:zoom(0)
				end
				SCREENMAN:GetTopScreen():GetChild("SongBackground"):visible(false)
			end
		end;
    end
};
t[#t+1] = LoadActor("ScreenFilter");

for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
	if LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") then
		t[#t+1] = LoadActor("MeasureCount", pn)
	end
end

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	if not LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(0).."/OutFoxPrefs.ini") then
		t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(1)
	end
end

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	if not LoadModule("Config.Load.lua")("ToastiesDraw",CheckIfUserOrMachineProfile(1).."/OutFoxPrefs.ini") then
		t[#t+1] = LoadModule("Options.SmartToastieActors.lua")(2)
	end
end


return t;