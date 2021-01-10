return function(Mode)
	local Dir = FILEMAN:GetDirListing("Appearance/Judgments/",false,true)
	local NewDir = {}
	for _,v in pairs(Dir) do
		if Mode == "Show" then
			NewDir[#NewDir+1] = string.match(v,".+/(.-) %d")
		else
			NewDir[#NewDir+1] = v
		end
	end
	return NewDir
end