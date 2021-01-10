local p = ...
-- a table to store the vertices
local verts = {
	Hits = {},
	Misses = {}
}
local MissTimes = {}
-- Get our song
local steptype = GAMESTATE:GetCurrentSteps(p):GetStepsType()
local IsEndless = GAMESTATE:GetPlayMode() == "PlayMode_Endless"
local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( p );
local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
local FirstSecond = function()
	if GAMESTATE:IsCourseMode() then
		return 0
	end
	return SongOrCourse:GetFirstSecond()
end
local TotalSeconds = function()
	if GAMESTATE:IsCourseMode() then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
		if not IsEndless then
			if trail then
				return TrailUtil.GetTotalSeconds(trail);
			end;
			return 0;
		end
		return vStats:GetAliveSeconds()
	end
	return SongOrCourse:GetLastSecond()
end
local OffsetTable = getenv("OffsetTable")
local Offset, CurrentSecond, NoteType, x, y
local OffLimit = 0.25
local BodyWidth, BodyHeight = 333,78

-- Grab the table.
for x in ivalues(OffsetTable[p]) do
	-- Set contents to recgonizable locals.
	CurrentSecond = x[1]
	Offset = x[2]
	NoteType = x[3]

	if Offset ~= "Miss" then
		CurrentSecond = CurrentSecond - Offset
	else
		CurrentSecond = CurrentSecond - OffLimit
	end

	-- Let's scale the graph
	x = scale(CurrentSecond, FirstSecond(), TotalSeconds(), -BodyWidth/2, BodyWidth/2)

	-- Check if the current item is not Miss
	if Offset ~= "Miss" then
		local val = "JudgmentLine_"..ToEnumShortString( NoteType )
		-- Set the y position to about the position where the limit would be
		y = scale(Offset, OffLimit, -OffLimit, 0, BodyHeight)
		local ColorType = JudgmentLineToColor( val )

		-- Now create a Square, with the judgment color
		table.insert( verts.Hits, {{x, y, 0}, ColorType } )

	else
		table.insert( MissTimes, CurrentSecond )
		-- If it was a miss, we'll generate it on a separate vectorset.
		table.insert( verts.Misses, {{x, 0, 0}, color("#ff000077")} )
		table.insert( verts.Misses, {{x, BodyHeight, 0}, color("#ff000077")} )
	end
end;

-- Finally, put everything to a AMV.
-- It turns out this is way better than doing a Quad loop as it reduces the
-- ammount of Draw calls drastically.
local oldzoom = 0
local amvhit = Def.ActorMultiVertex{
	OnCommand=function(self)
		self:SetDrawState{Mode="DrawMode_Points"}:SetVertices(verts.Hits):SetPointSize(2.5)
		:SetPointState(true)
	end,
	ScatterZoomMessageCommand=function(s,param)
		if param.Player == p then
			s:stoptweening():decelerate(0.2)
			
			-- If the player requests a zoom, we need to recalculate the vertices.
			local WidthConv = (BodyWidth/2)*param.Zoom
			for i=1,#verts.Hits do
				local pos = scale(OffsetTable[p][i][1], FirstSecond(), TotalSeconds(), -WidthConv, WidthConv)
				-- Now it is time to perform some operations on some of the vertices.
				verts.Hits[i][1][1] = pos
			end

			s:SetNumVertices( #verts.Hits ):SetVertices( verts.Hits )
			s:x( param.Zoom > 1 and -scale(param.Xpos, 1, param.MaxSegment, 0, BodyWidth) or 0 )
		end
	end,
	ScatterMoveMessageCommand=function(s,param)
		if param.Player == p then
			s:stoptweening():decelerate(0.2)
			s:x( param.Zoom > 1 and -scale(param.Xpos, 1, param.MaxSegment, 0, BodyWidth) or 0 )
		end
	end,
}

local amvmiss = Def.ActorMultiVertex{
	OnCommand=function(self)
		self:SetDrawState{Mode="DrawMode_Lines"}:SetVertices(verts.Misses):SetLineWidth(2.5)
	end,
	ScatterZoomMessageCommand=function(s,param)
		if param.Player == p then
			s:stoptweening():decelerate(0.2)
			
			-- If the player requests a zoom, we need to recalculate the vertices.
			-- Doing a simple zoomx is not going to work because it's going to make a distorted experience.
			local offindex = 0
			local WidthConv = (BodyWidth/2)*param.Zoom
			for i=1,#verts.Misses,2 do
				offindex = offindex + 1
				local pos = scale(MissTimes[offindex], FirstSecond(), TotalSeconds(), -WidthConv, WidthConv)
				-- Now it is time to perform some operations on some of the vertices.
				-- Trick: The first vertice (of 4) on the segment of the quad never changes,
				-- so we can use that as the starting point for the vertice transformation.
				verts.Misses[i][1][1] = pos
				verts.Misses[i+1][1][1] = pos
			end

			s:SetNumVertices( #verts.Misses ):SetVertices( verts.Misses )
			s:x( param.Zoom > 1 and -scale(param.Xpos, 1, param.MaxSegment, 0, BodyWidth) or 0 )
		end
	end,
	ScatterMoveMessageCommand=function(s,param)
		if param.Player == p then
			s:stoptweening():decelerate(0.2)
			s:x( param.Zoom > 1 and -scale(param.Xpos, 1, param.MaxSegment, 0, BodyWidth) or 0 )
		end
	end,
}

return Def.ActorFrame{amvmiss,amvhit};
