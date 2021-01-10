local label_text= false
return Def.ActorFrame {
	Def.BitmapText {
		Font="_Medium";
		Text=GetTimingDifficulty();
		AltText="";
		InitCommand=function(self) self:horizalign(left):zoom(0.75) end;
		OnCommand= function(self)
			label_text= self
			self:shadowlength(1):settextf(Screen.String("TimingDifficulty"), "");
		end,
	};
	Def.BitmapText {
		Font="_Medium";
		Text=GetTimingDifficulty();
		AltText="";
		InitCommand=function(self) self:x(136):zoom(0.75):halign(0) end;
		OnCommand=function(self)
			self:shadowlength(1):skewx(-0.125):x(label_text:GetZoomedWidth()+8)
			if GetTimingDifficulty() == 9 then
				self:settext(Screen.String("Hardest Timing"));
				self:zoom(0.5):diffuse(ColorLightTone( Color("Orange")))
			else
				self:settext( GetTimingDifficulty() );
			end
		end;
	};
};
