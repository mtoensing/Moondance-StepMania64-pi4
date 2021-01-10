return Def.ActorFrame{
	Def.BitmapText {
		Font="_Bold";
		InitCommand=function(self)
			self:horizalign(right):zoom(0.65):maxwidth(50/0.65)
		end;
		SetMessageCommand=function(self,param)
			if not param then return end
			local sString = THEME:GetString("StepsType",ToEnumShortString(param.StepsType));
			if param.Steps and param.Steps:IsAutogen() then
				self:diffusebottomedge(color("0.75,0.75,0.75,1"));
			else
				self:diffuse(Color("White"));
			end;
			self:settext( ToUpper(sString) );
		end;
	};
};

-- Unfortunately doing it like this leaks like crazy
-- Def.Sprite{
	-- InitCommand=function(self) self:x(8):halign(1) end;
	-- SetMessageCommand=function(self,param)
		-- if param then
			-- local path = THEME:GetPathG("","_StepsType/" .. ToEnumShortString(param.StepsType) .. ".png") 
			-- self:Load( FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_StepsType/missing") )
		-- end
	-- end
-- }