return function(Mode)
	local Dir = FILEMAN:GetDirListing("Appearance/Toasties/",true,true)
	local NewDir = {}
	for _,v in pairs(Dir) do
		print(v)
		if Mode == "Show" then
			NewDir[#NewDir+1] = string.match(v,".+/(.+)")
		else
			NewDir[#NewDir+1] = v
		end
	end
	return NewDir
end