-- Man, I hate this thing. I tried to do what I could with it, though.

-- I'm not really sure why this needs to be separate from the main CourseContentsList creation...
local transform = function(self,offsetFromCenter,itemIndex,numItems)
	self:y( offsetFromCenter * 64 )
	-- First condition is for making sure the items disappear before going past the banner.
	-- Second condition is to make their transition from the bottom of the screen look a little smoother.
	-- The exact numbers will likely need changing if "NumItemsToDraw" is changed.
	if offsetFromCenter < -1 or offsetFromCenter > 5 then
		self:diffusealpha(0)
	-- And this is just so the objects don't look quite as "THERE" underneath the info pane and footer.
	elseif offsetFromCenter < 0 or offsetFromCenter > 4 then
		self:diffusealpha(0.6)
	end
end

local t = Def.ActorFrame{};

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:zoomto(900,200):MaskSource():y(-141)
	end;
};

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:zoomto(900,200):MaskSource():y(140*2.5-16)
	end;
};

t[#t+1] = Def.CourseContentsList {
	MaxSongs = 999,
    NumItemsToDraw = 12,
	ShowCommand=function(self) 
		self:stoptweening():decelerate(0.3):diffusealpha(1)
	end;
	HideCommand=function(self) 
		self:stoptweening():decelerate(0.3):diffusealpha(0)
	end;
	SetCommand=function(self)
		self:MaskDest()
		self:SetFromGameState()
		self:SetCurrentAndDestinationItem(0)
		self:SetPauseCountdownSeconds(1)
		self:SetSecondsPauseBetweenItems( 0.25 )
		self:SetTransformFromFunction(transform)
		--
		self:SetDestinationItem( math.max(0,self:GetNumItems() - 4.14) )
		self:SetLoop(false)
	end,
	CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end;
	CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end;

	Display = Def.ActorFrame { 
		InitCommand=function(self) self:setsize(800,64) end;

		LoadActor(THEME:GetPathG("CourseEntryDisplay","bar")) .. {
			SetSongCommand=function(self, params)
				self:zoomx(1.5):zoomy(1.1):x(-28)
				if params.Difficulty then
					self:diffuse(ColorMidTone(CustomDifficultyToColor(params.Difficulty)));
				else
					self:diffuse( color("#FFFFFF") );
				end
			end
		},

		Def.TextBanner {
			InitCommand=function(self) self:x(IsWidescreen() and -140 or 170):y(-1):Load("TextBannerCourse"):SetFromString("", "", "", "", "", "") end;
			SetSongCommand=function(self, params)
				if params.Song then
					self:SetFromSong( params.Song );
					self:diffuse(color("#FFFFFF"));
				else
					self:SetFromString( "??????????", "??????????", "", "", "", "" );
					self:diffuse( color("#FFFFFF") );
-- 					self:glow("1,1,1,0");
				end
			end
		},
		Def.BitmapText {
			Font="_SemiBold",
			Text="0",
			InitCommand=function(self) self:xy(390,0):zoom(1):horizalign(right) end;
			SetSongCommand=function(self, params)
				if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
				self:settext( params.Meter )
				self:diffuse( color("#FFFFFF") )
			end
		},
	}
}

return t;