return Def.ActorFrame {
	Def.Sprite {
		Texture=NOTESKIN:GetPath( "_"..Var "Button", "Explosion" ),
		W1Command=function(self) self:diffusealpha(1):zoom(1):linear(0.1):zoom(1):linear(0.06):diffusealpha(0) end,
		W2Command=function(self) self:diffusealpha(1):zoom(1):linear(0.1):zoom(1):linear(0.06):diffusealpha(0) end,
		W3Command=function(self) self:diffusealpha(1):zoom(1):linear(0.1):zoom(1):linear(0.06):diffusealpha(0) end,
		W4Command=function(self) self:diffusealpha(0) end,
		W5Command=function(self) self:diffusealpha(0) end
	}
}
