return Def.ActorFrame{
	Def.Model {
		Meshes=NOTESKIN:GetPath('','_MineMesh');
		Materials=NOTESKIN:GetPath('','_MineMesh');
		Bones=NOTESKIN:GetPath('','_MineMesh');
		InitCommand=function(self)
			self:spin():effectclock('beat'):effectmagnitude(0,0,-33)
		end;
	};
};
