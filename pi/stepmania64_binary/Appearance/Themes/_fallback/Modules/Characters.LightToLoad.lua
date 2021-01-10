-- This is to load the stage's time of day.
-- It goes along the Current Stage Lighting setting found on the
-- Theme Options.
return function()
	return (Hour() < 6 or Hour() > 19) and "Night" or "Day"
end