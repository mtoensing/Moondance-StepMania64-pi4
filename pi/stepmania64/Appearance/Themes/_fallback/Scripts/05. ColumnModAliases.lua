--Mod aliases for those who wish to use the old syntax, or for simfiles/themes that haven't been updated.
--If MAX_COLS_PER_PLAYER or MAX_NOTE_TRACKS gets changed from 16, the for loop's bound may need to be updated.
for i=1,16 do
	PlayerOptions['MoveX'..i] = function (self, mag, speed, chain)
		return self:MoveXCol(i,mag,speed,chain)
	end
	PlayerOptions['MoveY'..i] = function (self, mag, speed, chain)
		return self:MoveYCol(i,mag,speed,chain)
	end
	PlayerOptions['MoveZ'..i] = function (self, mag, speed, chain)
		return self:MoveZCol(i,mag,speed,chain)
	end
	PlayerOptions['ConfusionXOffset'..i] = function (self, mag, speed, chain)
		return self:ConfusionXOffsetCol(i,mag,speed,chain)
	end
	PlayerOptions['ConfusionYOffset'..i] = function (self, mag, speed, chain)
		return self:ConfusionYOffsetCol(i,mag,speed,chain)
	end
	PlayerOptions['ConfusionOffset'..i] = function (self, mag, speed, chain)
		return self:ConfusionOffsetCol(i,mag,speed,chain)
	end
	PlayerOptions['Dark'..i] = function (self, mag, speed, chain)
		return self:DarkCol(i,mag,speed,chain)
	end
	PlayerOptions['Stealth'..i] = function (self, mag, speed, chain)
		return self:StealthCol(i,mag,speed,chain)
	end
	PlayerOptions['Tiny'..i] = function (self, mag, speed, chain)
		return self:TinyCol(i,mag,speed,chain)
	end
	PlayerOptions['Bumpy'..i] = function (self, mag, speed, chain)
		return self:BumpyCol(i,mag,speed,chain)
	end
	PlayerOptions['Reverse'..i] = function (self, mag, speed, chain)
		return self:ReverseCol(i,mag,speed,chain)
	end
end
