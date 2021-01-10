return function()
	local ResultTable = {};
	-- Load the directory where the stages are located.
	local Directory = FILEMAN:GetDirListing( "/Appearance/DanceStages/", true, false )

	-- It has been found, then let's begin the search.
	if Directory then
		-- Each stage will be added as the name of the folder.
		for i,stage in ipairs(Directory) do
			ResultTable[#ResultTable+1] = stage
		end
	end
	-- Insert None as the first result as a default. 
	table.insert(ResultTable, 1, "None")
	
	return ResultTable
end