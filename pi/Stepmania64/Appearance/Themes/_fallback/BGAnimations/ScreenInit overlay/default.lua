local Intro = {
	"Train",
	"Dreamcast"
}

return Def.ActorFrame {
	OnCommand = function(self)
		self:zoom(SCREEN_HEIGHT/720):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+((SCREEN_HEIGHT/720)*180))
	end,
	loadfile( THEME:GetPathB("ScreenInit", "overlay/"..Intro[math.random(1,2)]) )()
}
