local p = ...
local fade_out_speed = 0.2
local fade_out_pause = 0.1
local off_wait = 0.75

local t = Def.ActorFrame{
	OffCommand=function(self)
		self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
	end;
};
-- A very useful table...
local NoteTable = getenv("perColJudgeData")

local eval_part_offs = string.find(p, "P1") and -310 or 310
local score_parts_offs = string.find(p, "P1") and -100 or 100

-- Step counts.
t[#t+1] = Def.BitmapText {
    Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1):xy(_screen.cx +(eval_part_offs),_screen.cy-165+70):maxwidth(260):horizalign(center)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
    end;
    Text=THEME:GetString("ScreenEvaluation","ColumnSc");
};

-- offset and spacing for the columns
local Name,Length = LoadModule("Options.SmartTapNoteScore.lua")()
local DLW = LoadModule("Config.Load.lua")("DisableLowerWindows","Save/OutFoxPrefs.ini") or false
table.sort(Name)
Name[#Name+1] = "Miss"
Length = Length + 1
for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
	for ind,val in ipairs( Name ) do
		local cur_line = "JudgmentLine_" .. val
		t[#t+1] = Def.BitmapText{
			Font="_Condensed Semibold",
			OnCommand=function(self)
				local col = GAMESTATE:GetCurrentStyle():ColumnsPerPlayer();
				local sidespacing = scale( col,3,10,87,146 )
				self:x( _screen.cx + scale( i, 1, col, eval_part_offs-sidespacing, eval_part_offs+sidespacing ) )
				:y( SCREEN_CENTER_Y-30+((44-(Length*2.6))*ind)):zoom(1.5-(Length*0.1) )
				:settext( NoteTable[p][i][val] )
				self:diffuse( BoostColor( JudgmentLineToColor(cur_line), 1 ) )
				self:diffusealpha(0):sleep(0.1 * ind):decelerate(0.6):diffusealpha(0.86)
				if DLW then
					for i=0,1 do
						if (v == 'W'..(5-i) and tonumber(DLW) >= (i+1)) then self:diffusealpha( 0.4 ) end
					end
				end
			end;
		};
	end
end

-- Noteskin Operation
local noteskin = GAMESTATE:GetPlayerState(p):GetPlayerOptions('ModsLevel_Song'):NoteSkin():lower()

-- Print the noteskin columns
for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
	-- Check if the noteskin actually exists, otherwise warn, and use the first noteskin
	-- available on the array.
	if not NOTESKIN:DoesNoteSkinExist( noteskin ) then
		Warn( "The noteskin currently set does not exist on this game mode. Using ".. NOTESKIN:GetNoteSkinNames()[1] .." instead." )
		noteskin = NOTESKIN:GetNoteSkinNames()[1]
	end
	local tcol = GAMESTATE:GetCurrentStyle():GetColumnInfo( p, i )
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			local col = GAMESTATE:GetCurrentStyle():ColumnsPerPlayer();
			local sidespacing = scale( col,3,10,87,146 )
			self:x( _screen.cx + scale( i, 1, col, eval_part_offs-sidespacing, eval_part_offs+sidespacing ) )
			:y( _screen.cy-48)
			:zoom(0.75)
		end,
		NOTESKIN:LoadActorForNoteSkin( tcol["Name"], "Tap Note", noteskin)
	}
end

t[#t+1] = Def.GraphDisplay{
	InitCommand=function(self) self:vertalign(bottom):x(_screen.cx + (eval_part_offs)):y(_screen.cy+196+70) end;
	BeginCommand=function(self)
		self:Load("GraphDisplayTransp")
		local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(p)
		local stageStats = STATSMAN:GetCurStageStats()
		self:Set(stageStats, playerStageStats)
	end,
	OnCommand=function(self)
		self:zoomy(0):sleep(1.2):decelerate(0.4):zoomy(1)
	end;
	OffCommand=function(self)
		self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
	end;
	CheckCurrentPageCommand=function(s,param)
		if getenv("PageIndex") then
			local PageInd = getenv("PageIndex")
			s:diffusealpha( (PageInd[p] == 2 and param.Zoom > 1) and 0.3 or 1)
		end
	end,
	PageUpdatedMessageCommand=function(self)
		if getenv("PageIndex") then
			local PageInd = getenv("PageIndex")
			self:finishtweening():decelerate(0.2)
			:diffusealpha( PageInd[p] == 2 and 1 or 0 )
		end
	end,
	ScatterZoomMessageCommand=function(s,param) s:playcommand("CheckCurrentPage",{Zoom=param.Zoom}) end,
	ScatterMoveMessageCommand=function(s,param) s:playcommand("CheckCurrentPage",{Zoom=param.Zoom}) end
};

t[#t+1] = Def.BitmapText {
    Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1):xy(_screen.cx +(eval_part_offs)-160 ,_screen.cy-165+340):maxwidth(260):horizalign(left):zoom(0.6)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p))):diffusealpha(0.5)
    end;
	ScatterZoomMessageCommand=function(s,param)
		if param.Player == p then
			s:settext( string.format( THEME:GetString("ScreenEvaluation","CurrentZoom"), param.Zoom ) )
		end
	end
};

t[#t+1] = Def.BitmapText {
	Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1):xy(_screen.cx +(eval_part_offs)+160 ,_screen.cy-165+340):maxwidth(340):horizalign(right):zoom(0.6)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p))):diffusealpha(0.5)
    end;
	ScatterZoomMessageCommand=function(s,param)
		if param.Player == p then
			local touse = param.Zoom > 1 and "ZoomHelp2" or "ZoomHelp1"
			s:settext( THEME:GetString("ScreenEvaluation",touse) )
		end
	end
};

t[#t+1] = Def.ActorFrameTexture{
	InitCommand=function(s)
		s:SetWidth( 333 ):SetHeight( 78 ):EnableAlphaBuffer(true):SetTextureName("Scatterplot"..p):Create()
	end,

	Def.ActorFrame{
		OnCommand=function(s)
			s:x( 333/2 )
		end,
		Def.Quad{
			OnCommand=function(s)
				s:zoomto(333,78):diffusetopedge( color("#FF8D47") ):diffusebottomedge( color("#FFC447") ):diffusealpha(0.4)
				:xy(0,78/2):MaskDest()
			end,
			ScatterZoomMessageCommand=function(s,param)
				if param.Player == p then
					s:zoomto( scale( param.Zoom, 1, 10, 333, 333/10 ) ,78 )
					s:x( scale(param.Xpos, 1, param.MaxSegment, 0, (333/param.MaxSegment)) )
				end
			end,
			ScatterMoveMessageCommand=function(s,param)
				s:x( scale(param.Xpos, 1, param.MaxSegment, 0, (333/param.MaxSegment)) )
			end,
		};
	};

	Def.ActorFrame{
		InitCommand=function(self) self:xy(333/2,0) end;
		LoadActor("Scatter.lua",p)..{
			OnCommand=function(self)
				self:vertalign(bottom)
			end;
			OffCommand=function(self)
				self:sleep(fade_out_pause):decelerate(fade_out_speed):diffusealpha(0)
			end;
		};
	};
}

t[#t+1] = Def.Sprite{
	Texture="Scatterplot"..p,
	OnCommand=function(s)
		s:xy( _screen.cx + (eval_part_offs), _screen.cy+188+(78/2) )
	end,
}

return t;
