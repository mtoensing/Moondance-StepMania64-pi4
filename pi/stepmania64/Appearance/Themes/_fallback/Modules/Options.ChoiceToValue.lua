return function(Input,ValToFind)
	for i,v in ipairs(Input) do
		if v == ValToFind then return i end
	end
	return 1
end