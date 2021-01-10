return function(PData,ForEveryProfile)
	local Dir = FILEMAN:GetDirListing("/Appearance/Avatars/")
	if ForEveryProfile then
		local profile = PROFILEMAN:GetLocalProfileFromIndex(PData)
		local config_loc = "/Save/LocalProfiles/"..PROFILEMAN:GetLocalProfileIDFromIndex(PData).."/OutFoxPrefs.ini"
		local Info = {
			[PData] = {}
		}
		Info.PData = { Name="", Image="" }
		
		Info[PData].Image = THEME:GetPathG("UserProfile","generic icon")
		if profile and profile:GetDisplayName() ~= "" then
			Info[PData].Name = profile:GetDisplayName()
			if not LoadModule("Config.Load.lua")("AvatarImage",config_loc) then
				for _,v in ipairs(Dir) do
					if string.match(v, "(%w+)") == profile:GetDisplayName() then
						Info[PData].Image = "/Appearance/Avatars/"..v
						LoadModule("Config.Save.lua")("AvatarImage",Info[PData].Image,config_loc)
					end
				end
			else
				Info[PData].Image = LoadModule("Config.Load.lua")("AvatarImage",config_loc)
			end
		end
		return Info[PData]
	else
		local profile = PROFILEMAN:GetProfile(PData) or PROFILEMAN:GetMachineProfile()
		local config_loc = CheckIfUserOrMachineProfile(string.sub(PData,-1)-1).."OutFoxPrefs.ini"
		local playerString = string.find(PData, "P1") and THEME:GetString("GameState","Player 1") or THEME:GetString("GameState","Player 2")
		local Info = {
			[PData] = {}
		}
		Info.PData = { Name="", Image="" }
	
		Info[PData].Image = THEME:GetPathG("UserProfile","generic icon")
		Info[PData].Name = playerString
		if profile and profile:GetDisplayName() ~= "" then
			Info[PData].Name = profile:GetDisplayName()
			if not LoadModule("Config.Load.lua")("AvatarImage",config_loc) then
				for _,v in ipairs(Dir) do
					if string.match(v, "(%w+)") == profile:GetDisplayName() then
						Info[PData].Image = "/Appearance/Avatars/"..v
						LoadModule("Config.Save.lua")("AvatarImage",Info[PData].Image,config_loc)
					end
				end
			else
				Info[PData].Image = LoadModule("Config.Load.lua")("AvatarImage",config_loc)
			end
		end	
		return Info[PData]
	end
end