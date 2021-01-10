return function(key,file,Cat)	
	if not FILEMAN:DoesFileExist(file) then return false end
	
	local Container = {}

	local configfile = RageFileUtil.CreateRageFile()
	configfile:Open(file, 1)
	
	local configcontent = configfile:Read()
	
	configfile:Close()
	configfile:destroy()
	
	local Caty = true
	
	for line in string.gmatch(configcontent.."\n", "(.-)\n") do	
		for Con in string.gmatch(line, "%[(.-)%]") do
			if Con == Cat or Cat == nil then Caty = true else Caty = false end
		end	
		for KeyVal, Val in string.gmatch(line, "(.-)=(.+)") do
			if key == KeyVal and Caty then
				if Val == "true" then return true end
				if Val == "false" then return false end
				return Val 
			end
		end	
	end
	return false
end
