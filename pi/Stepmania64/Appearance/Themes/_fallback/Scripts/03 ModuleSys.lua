function LoadModule(ModuleName,...)
	
	local Path = THEME:GetCurrentThemeDirectory().."Modules/"..ModuleName
	
	for _,theme in pairs(THEME:get_theme_fallback_list()) do
		if not FILEMAN:DoesFileExist(Path) then
			Path = "Appearance/Themes/"..theme.."/Modules/"..ModuleName
		end
	end
	
	if not FILEMAN:DoesFileExist(Path) then
		Path = "Appearance/Themes/_fallback/Modules/"..ModuleName
	end
	
	if ... then
		return loadfile(Path)(...)
	end
	return loadfile(Path)()
end

function CheckIfUserOrMachineProfile(pn)
	if PROFILEMAN:GetProfileDir(pn) == "" then
		return "Save/MachineProfile/OutFoxPrefsForPlayerp"..pn+1
	else
		return PROFILEMAN:GetProfileDir(pn)
	end
end

function fornumrange(s,e,it)
	local num = {}
	for i = s,e,it or 1 do
		num[#num+1] = i
	end
	return num
end