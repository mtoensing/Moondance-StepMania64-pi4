--[[
	This function is quite literally for one specific thing.
	That thing being Baby-Lon. I was mentioned about this specific model,
	being too big from its original size, so this function checks who has Baby-Lon.
	And if it does, we can do a model size shrink to that player.
]]
return function(pn)
	return GAMESTATE:IsPlayerEnabled(pn) and string.find(GAMESTATE:GetCharacter(pn):GetDisplayName(), "Baby") and CharacterManager:IsSafeToLoad(pn)
end