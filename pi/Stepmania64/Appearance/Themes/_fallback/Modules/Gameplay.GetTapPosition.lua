return function( sType )
    local tNotePositions = {
	    -- StepMania 3.9/4.0
   		Normal = { -144, 144, },
	    -- ITG
   		Lower = { -125, 145, }
   	}
    return tNotePositions[LoadModule("Config.Load.lua")("NotePosition","Save/OutFoxPrefs.ini") and "Normal" or "Lower"][(sType == 'Standard') and 1 or 2]
end