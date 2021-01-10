return Def.Model {
	Meshes=NOTESKIN:GetPath('_Outfox','Note_Double');
	-- use material file so the itgcolor version can fallback on this
	-- cant name it NoteMaterial cause it conflicts with the just Note file apparently
	Materials=NOTESKIN:GetPath('_Outfox','Material');
	Bones=NOTESKIN:GetPath('_Outfox','Note_Double');
};