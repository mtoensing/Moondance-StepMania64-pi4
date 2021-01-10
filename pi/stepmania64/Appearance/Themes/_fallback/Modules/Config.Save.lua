return function(key,value,file)
	if not FILEMAN:DoesFileExist(file) then 
		local Createfile = RageFileUtil.CreateRageFile()
		Createfile:Open(file, 2)
		Createfile:Write("")
		Createfile:Close()
		Createfile:destroy()
	end

	local Container = {}

	local configfile = RageFileUtil.CreateRageFile()
	configfile:Open(file, 1)
	
	local configcontent = configfile:Read()

	configfile:Close()

	local found = false

	for line in string.gmatch(configcontent.."\n", "(.-)\n") do
		for KeyVal, Val in string.gmatch(line, "(.-)=(.+)") do
			if key == KeyVal then Val = value found = true end
			Container[KeyVal] = Val
		end		
	end
	
	if found == false then Container[key] = value end
	
	local output = ""
	
	for k,v in pairs(Container) do
		output = output..k.."="..v.."\n"
	end	
	
	configfile:Open(file, 2)
	configfile:Write(output)
	configfile:Close()
	configfile:destroy()
end