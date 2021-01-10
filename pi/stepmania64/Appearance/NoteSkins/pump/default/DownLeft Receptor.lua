local player = Var "Player" or GAMESTATE:GetMasterPlayerNumber()

local function Beat(self)
	-- too many locals
	local this = self:GetChildren()
	local playerstate = GAMESTATE:GetPlayerState( player )
	local songposition = playerstate:GetSongPosition() -- GAMESTATE:GetSongPosition()
	
	local beat = songposition:GetSongBeat() -- GAMESTATE:GetSongBeat()
	
	local part = beat%1
	part = clamp(part,0,0.5)
	local eff = scale(part,0,0.5,1,0)
	if (songposition:GetDelay() or false) and part == 0 then eff = 0 end
	if beat < 0 then
		eff = 0
	end
	this.Glow:diffusealpha(eff)
end

return Def.ActorFrame {
	-- COMMANDS --
	InitCommand=function(self) self:SetUpdateFunction(Beat) end,
	
	-- LAYERS --
	NOTESKIN:LoadActor("DownLeft", "Ready Receptor")..{
		Name="Base",
		Frames={{ Frame = 0 }},
		PressCommand=function(self) self:finishtweening():linear(0.05):zoom(0.9):linear(0.1):zoom(1) end
	},
	NOTESKIN:LoadActor("DownLeft", "Ready Receptor")..{
		Name="Glow",
		Frames= {{ Frame = 1 }},
		InitCommand=function(self) self:blend('BlendMode_Add') end,
		PressCommand=function(self) self:finishtweening():linear(0.05):zoom(0.9):linear(0.1):zoom(1) end
	};
}