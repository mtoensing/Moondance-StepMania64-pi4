-- Loads up a slew of objects to load into the screen, like how 3.9 does.
-- I prefer to keep these optional, incase another screen wants to hide 
-- these elements.
return Def.ActorFrame {
	StandardDecorationFromFileOptional("Header","Header");
	StandardDecorationFromFileOptional("Footer","Footer");
	StandardDecorationFromFileOptional( "Help", "Help" );
	
};
