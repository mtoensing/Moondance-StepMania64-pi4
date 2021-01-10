return Def.Sprite {
		Texture=NOTESKIN:GetPath( "_DownLeft", "Tap Note" ),
		Frame0000=105,
		Delay0000=1,
		NoneCommand=NOTESKIN:GetMetricA("ReceptorArrow", "NoneCommand"),
		InitCommand=function(self)
			self:glowblink()
				:effectcolor1(0.4,0.4,0.4,0.4)
				:effectcolor2(0.8,0.8,0.8,0.4)
				:effectclock('beat')
				:effecttiming(0.2,0,0.8,0)
		end
}
