local function CreditsText( pn )
	local text = LoadFont(Var "LoadingScreen","credits") .. {
		InitCommand=function(self)
			self:name("Credits" .. PlayerNumberToString(pn))
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		UpdateTextCommand=function(self)
			local str = ScreenSystemLayerHelpers.GetCreditsMessage(pn);
			self:settext(str);
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				MESSAGEMAN:Broadcast("UpdateCreditLayer")
			end
		end
	};
	return text;
end;
--
return Def.ActorFrame {
	-- Aux
	LoadActor(THEME:GetPathB("ScreenSystemLayer","aux"));
	-- Credits
	Def.ActorFrame {
		UpdateCreditLayerMessageCommand=function(self)
			local screen = SCREENMAN:GetTopScreen()
			local bShow = 1
			if screen then
				local sClass = screen:GetName()
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" ) and 1 or 0
			end
			self:linear(0.5):diffusealpha( bShow )
		end,
		CreditsText( PLAYER_1 );
		CreditsText( PLAYER_2 ); 
	};
	-- Text
	Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self) self:zoomtowidth(SCREEN_WIDTH):zoomtoheight(42):horizalign(left):vertalign(top):y(SCREEN_TOP):diffuse(color("0,0,0,0")) end;
			OnCommand=function(self) self:finishtweening():diffusealpha(0.85) end;
			OffCommand=function(self) self:sleep(3):linear(0.5):diffusealpha(0) end;
		};
		Def.BitmapText{
			Font="ScreenConsoleOverlay SystemMessage";
			Name="Text";
			InitCommand=function(self) self:maxwidth(SCREEN_WIDTH*0.76):horizalign(left):vertalign(top):xy(SCREEN_LEFT+10,SCREEN_TOP+14):shadowlength(1):diffusealpha(0) end;
			OnCommand=function(self) self:finishtweening():diffusealpha(1):zoom(1) end;
			OffCommand=function(self) self:sleep(3):linear(0.5):diffusealpha(0) end;
		};
		SystemMessageMessageCommand = function(self, params)
			self:GetChild("Text"):settext( params.Message );
			self:playcommand( "On" );
			if params.NoAnimate then
				self:finishtweening();
			end
			self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = function(self) self:finishtweening() end;
	};

};