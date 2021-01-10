return Def.ActorFrame {
	Def.BitmapText {
		Font="_Medium";
		InitCommand=function(self) self:horizalign(left):zoom(0.75):shadowlength(1) end;
		BeginCommand=function(self)
			-- check network status
			if IsNetConnected() then
				self:diffuse( color("#FFFFFF") );
				self:settext( ToUpper( Screen.String("Network OK") ) );
			else
				self:diffuse( color("#FFFFFF") );
				self:settext( ToUpper( Screen.String("Offline") ) );
			end;
		end;
	};

	Def.BitmapText {
		Font="_Medium";
		Condition=IsNetConnected();
		InitCommand=function(self) self:y(16):horizalign(left):zoom(0.5875):shadowlength(1):diffuse(color("#FFFFFF")) end;
		BeginCommand=function(self)
			self:settext( string.format(Screen.String("Connected to %s"), GetServerName()) );
		end;
	};

};