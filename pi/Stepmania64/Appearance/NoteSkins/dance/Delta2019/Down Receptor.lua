return Def.ActorFrame {
	Def.Sprite {
		Texture = NOTESKIN:GetPath('_receptor', ''),
		Frame0000 = 0,
		Delay0000 = 0.95,
		Frame0001 = 1,
		Delay0001 = 1,
		Frame0002 = 2,
		Delay0002 = 1,
		Frame0003 = 3,
		Delay0003 = 1,
		Frame0004 = 0,
		Delay0004 = 0.05,
		InitCommand = NOTESKIN:GetMetricA('ReceptorArrow', 'InitCommand'),
		NoneCommand = NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand')
	},
	Def.Sprite {
		Texture = NOTESKIN:GetPath('_receptor', ''),
		Frame0000 = 0,
		Delay0000 = 0.95,
		Frame0001 = 1,
		Delay0001 = 1,
		Frame0002 = 2,
		Delay0002 = 1,
		Frame0003 = 3,
		Delay0003 = 1,
		Frame0004 = 0,
		Delay0004 = 0.05,
		InitCommand = NOTESKIN:GetMetricA('ReceptorOverlay', 'InitCommand'),
		PressCommand = NOTESKIN:GetMetricA('ReceptorOverlay', 'PressCommand'),
		LiftCommand = NOTESKIN:GetMetricA('ReceptorOverlay', 'LiftCommand'),
		NoneCommand = NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand')
	}
}
