return Def.Model {
	Meshes=NOTESKIN:GetPath('','_TapNoteMesh');
	Materials=NOTESKIN:GetPath('','_TapNoteMaterial'); -- For other noteskins to fallback and override
	Bones=NOTESKIN:GetPath('','_TapNoteMesh');
};