return Def.Model {
	Meshes=NOTESKIN:GetPath('','_LiftNoteMesh_Double');
	Materials=NOTESKIN:GetPath('','_LiftNoteMesh_Double');
	Bones=NOTESKIN:GetPath('','_LiftNoteMesh_Double');
	InitCommand=function(self)
		self:pulse():effectclock("beat"):effectmagnitude(0.9,1,1):effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.8")) 
	end;
};