return Def.Model {
	Meshes=NOTESKIN:GetPath('','_LiftNoteMesh');
	Materials=NOTESKIN:GetPath('','_LiftNoteMesh');
	Bones=NOTESKIN:GetPath('','_LiftNoteMesh');
	InitCommand=function(self)
		self:pulse():effectclock("beat"):effectmagnitude(0.9,1,1):effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.8")) 
	end;
};