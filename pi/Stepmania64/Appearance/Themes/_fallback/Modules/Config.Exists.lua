return function(key,file)	
	if not FILEMAN:DoesFileExist(file) then return false end
	
	local Container = {}

	local configfile = RageFileUtil.CreateRageFile()
	configfile:Open(file, 1)
	
	local configcontent = configfile:Read()
	
	configfile:Close()
	configfile:destroy()
	
	for line in string.gmatch(configcontent.."\n", "(.-)\n") do
		for KeyVal, Val in string.gmatch(line, "(.-)=(.+)") do
			if key == KeyVal then
				return true
			end
		end		
	end
	return false
end