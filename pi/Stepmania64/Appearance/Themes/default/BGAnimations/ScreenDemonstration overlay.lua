local nativeTitle = PREFSMAN:GetPreference("ShowNativeLanguage") and 1 or 0
return Def.ActorFrame{
	-- A temporary frame for the jacket.
	Def.Quad {
		InitCommand=function(self) 
			self:horizalign(right):vertalign(bottom):xy(_screen.w-39,_screen.h-46):zoomto(192,192):diffuse(color("#00000075"))
		end;
		OnCommand=function(self)
			self:diffusealpha(0):sleep(2):smooth(2):diffusealpha(1)
		end
	},
	
	Def.Sprite {
		InitCommand=function(self) self:horizalign(right):vertalign(bottom):xy(_screen.w-49,_screen.h-46-10) end;
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song and song:HasJacket() then
				self:LoadBanner(song:GetJacketPath())
			elseif song and song:HasBackground() then
				self:LoadBanner(song:GetBackgroundPath())
			else
				self:LoadBanner(THEME:GetPathG("Common","fallback jacket"))
			end
			self:scaletoclipped(172,172)
			self:diffusealpha(0):sleep(2):smooth(2):diffusealpha(1)
		end
	},
	-- Song title.
	Def.BitmapText {
		Font = "_Bold",
		InitCommand=function(self) self:horizalign(right):xy(_screen.w-250,_screen.h-64-150):strokecolor(color("#42292E")):shadowlength(1):maxwidth(SCREEN_WIDTH*0.75) end;
		Text=nativeTitle == 1 and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitMainTitle();
		OnCommand=function(self)
			self:diffusealpha(0):sleep(2):smooth(2):diffusealpha(1)
		end
	},
	-- Song artist.
	Def.BitmapText {
		Font = "_Bold",
		InitCommand=function(self) self:horizalign(right):xy(_screen.w-250,_screen.h-40-150):zoom(0.75):strokecolor(color("#42292E")):shadowlength(1):maxwidth(SCREEN_WIDTH*0.75) end;
		Text=nativeTitle == 1 and GAMESTATE:GetCurrentSong():GetDisplayArtist() or GAMESTATE:GetCurrentSong():GetTranslitArtist();	
		OnCommand=function(self)
			self:diffusealpha(0):sleep(2):smooth(2):diffusealpha(1)
		end
    },
    
   LoadActor( THEME:GetPathB("_Arcade","decorations") );
}