return Def.Model {
		Meshes=NOTESKIN:GetPath('_Outfox','HexMine_Double');
		Materials=NOTESKIN:GetPath('_Outfox','HexMine_Double');
		Bones=NOTESKIN:GetPath('_Outfox','HexMine_Double');
		InitCommand=function(self)
			self:wag():effectclock('beat'):effectmagnitude(0,0,6)
		end;
}