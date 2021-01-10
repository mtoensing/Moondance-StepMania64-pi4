local t = Def.ActorFrame {};
t.InitCommand=function(self)
	self:name("ArcadeOverlay")
	ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
end;
t[#t+1] = Def.ActorFrame {
	Name="ArcadeOverlay.Text";
	InitCommand=function(self)
		ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
	end;
	LoadActor(THEME:GetPathB("_frame","3x1"),"rounded fill", 250) .. {
		OnCommand=function(self) 
			self:zoomy(1.5):diffuseshift():effectcolor1(color("#F5A04B")):effectcolor2(color("#E1694B")):effectperiod(1)
		end;
	};
	Def.BitmapText {
		Font="_Semibold";
		InitCommand=function(self) self:zoom(1):vertalign(middle):diffuse(color("#EEF1FF")) end;
		Text="...";
		OnCommand=function(self) self:playcommand("Refresh") end;
		CoinInsertedMessageCommand=function(self) self:playcommand("Refresh") end;
		CoinModeChangedMessageCommand=function(self) self:playcommand("Refresh") end;
		RefreshCommand=function(self)
			local bCanPlay = GAMESTATE:EnoughCreditsToJoin();
			local bReady = GAMESTATE:GetNumSidesJoined() > 0;
			if bCanPlay or bReady then
				self:settext( ToUpper(THEME:GetString("ScreenTitleJoin","HelpTextJoin")) );
			else
				self:settext( ToUpper(THEME:GetString("ScreenTitleJoin","HelpTextWait")) );
			end
		end;
	};
};

return t
