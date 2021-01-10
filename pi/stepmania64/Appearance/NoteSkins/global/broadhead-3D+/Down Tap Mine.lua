return Def.ActorFrame{
	Def.Model {
		Meshes=NOTESKIN:GetPath('','_MineMesh_Double');
		Materials=NOTESKIN:GetPath('','_MineMesh_Double');
		Bones=NOTESKIN:GetPath('','_MineMesh_Double');
		InitCommand=function(self)
			self:spin():effectclock('beat'):effectmagnitude(0,0,-33)
		end;
	};
};
