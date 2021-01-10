local label_text= false

return Def.ActorFrame {
	Def.BitmapText {
		Font="_Medium",
		Text=GetLifeDifficulty();
		AltText="";
		InitCommand=function(self) self:horizalign(left):zoom(0.75) end;
		OnCommand= function(self)
			label_text= self
			self:shadowlength(1):settextf(Screen.String("LifeDifficulty"), "");
		end,
	};
	Def.BitmapText {
		Font="_Medium",
		Text=GetLifeDifficulty();
		AltText="";
		InitCommand=function(self) self:halign(0):zoom(0.75) end;
		OnCommand= function(self)
			self:shadowlength(1):x(label_text:GetZoomedWidth()+8)
		end,
	};
};
