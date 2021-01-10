local t = Def.ActorFrame{}
local args = ...
local p = args

local eval_part_offs = string.find(p, "P1") and -310 or 310

local graphsizes = { 300,230 }
local panel_width = 336

local OffsetTable = getenv("OffsetTable")
local sm = LoadModule("Gameplay.Median.lua")( p, OffsetTable, graphsizes )

-- Load Timing information
local f = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini")
local JudgNames = {"ProW1","ProW2","ProW3","ProW4","ProW5","W1","W2","W3","W4","W5"}
local Name,Timings

for i = 1,#TimingWindow do
    Name,Timings = TimingWindow[i]()
    if f == Name then break end
end

------------------------------------------
-- Header Title
------------------------------------------
t[#t+1] = Def.BitmapText {
    Font = "_Bold",
    InitCommand=function(self)
        self:zoom(1.25):xy(_screen.cx +(eval_part_offs),_screen.cy-165+70):maxwidth(260):horizalign(center)
        self:diffuse(Color.White):diffusebottomedge(ColorLightTone(PlayerCompColor(p)))
    end,
    OffCommand=function(self)
        self:linear(0.2):diffusealpha(0)
    end,
    Text=THEME:GetString("ScreenEvaluation","HistogramCol")
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:xy(  _screen.cx + eval_part_offs, _screen.cy-4 ):zoomto( panel_width , 236  ):vertalign(top)
		:diffuse( Color.Black )
	end,
	OffCommand=function(s)
		s:sleep(0.2):decelerate(0.62):croptop(1):cropbottom(1)
	end,
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:xy(  _screen.cx + eval_part_offs, _screen.cy-74 ):zoomto( panel_width , 70  ):vertalign(0)
		:diffuse( PlayerColor(p) ):croptop(0.96)
	end,
	OffCommand=function(s)
		s:sleep(0.2):decelerate(0.3):y( _screen.cy+40 ):sleep(0.1):accelerate(0.3):cropleft(1)
	end,
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:xy(  _screen.cx + eval_part_offs, _screen.cy+192+(78/2) ):zoomto( panel_width , 70  ):vertalign(bottom)
		:diffuse( PlayerColor(p) ):croptop(0.96)
	end,
	OffCommand=function(s)
		s:sleep(0.2):decelerate(0.3):y( _screen.cy+192-80 ):sleep(0.1):accelerate(0.3):cropleft(1)
	end,
}
local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini")

for k,v in pairs( sm.TimingList[1] ) do
	if Timings[ "TapNoteScore_"..v ] > 0 then
		local position = scale( Timings[ "TapNoteScore_"..v ], sm.HighWindow ,sm.LowWindow, 0, graphsizes[1]*.528 )
		for i=1,2 do
			t[#t+1] = Def.Quad{
				OnCommand=function(s)
					s:zoomto( 2, graphsizes[2] ):diffuse( ColorDarkTone(JudgmentLineToColor( "JudgmentLine_"..v )) )
					:diffusealpha(0.7)
					:xy( _screen.cx + eval_part_offs + ( i == 2 and -position or position), _screen.cy+188-76 )
					s:fadebottom( 0.7 )
				end,
				OffCommand=function(s)
					s:sleep(0.02*k):decelerate(0.1):croptop(1)
				end,
			}

			t[#t+1] = Def.BitmapText{
				Font="Common Normal",
				Text=THEME:GetString( CurPrefTiming or "Original" , "Judgment"..v ),
				OnCommand=function(s)
					s:diffuse( ColorDarkTone(JudgmentLineToColor( "JudgmentLine_"..v )) )
					:diffusealpha(0.7):rotationz(90):zoom(0.6):halign(0)
					:xy( _screen.cx + eval_part_offs + ( i == 2 and -position+6 or position-6), _screen.cy )
				end,
				OffCommand=function(s)
					s:sleep(0.02*k):decelerate(0.1):diffusealpha(0)
				end,
			}
		end
	end
end

t[#t+1] = Def.ActorMultiVertex{
	OnCommand=function(s)
		s:SetDrawState{Mode="DrawMode_Lines"}:SetVertices( sm.Vertex )
		s:SetLineWidth(1.2)
		s:xy(  _screen.cx + (eval_part_offs-155) , _screen.cy+188+(78/2) )
		s:SetPointSize(1.5)
	end,
	OffCommand=function(s)
		s:decelerate(0.3):diffusealpha(0)
	end,
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:xy(  _screen.cx + eval_part_offs, _screen.cy+188+(78/2) ):zoomto( 2 , graphsizes[2]  ):vertalign(bottom)
	end,
	OffCommand=function(s)
		s:decelerate(0.3):diffusealpha(0):croptop(1)
	end,
}

local TopAreaLabels = { "Mean", "Median", "Mode" }

for k,v in pairs(TopAreaLabels) do
	t[#t+1] = Def.BitmapText{
		Font = "_Bold",
		OnCommand=function(s)
			s:xy(  _screen.cx + eval_part_offs + scale( k, 1, #TopAreaLabels, -130, 140 ) , _screen.cy-56 ):halign( k/#TopAreaLabels ):zoom(0.8)
			:uppercase(true):settext( THEME:GetString("ScreenEvaluation",v) )
		end,
		OffCommand=function(s)
			s:sleep(0.02*k):decelerate(0.3):diffusealpha(0)
		end,
	}

	t[#t+1] = Def.BitmapText{
		Font="Common Normal",
		Text=sm[k].."ms",
		OnCommand=function(s)
			s:xy(  _screen.cx + eval_part_offs + scale( k, 1, #TopAreaLabels, -120, 120 ) , _screen.cy-30 ):zoom(0.8)
		end,
		OffCommand=function(s)
			s:sleep(0.02*k):decelerate(0.3):diffusealpha(0)
		end,
	}
end

local times = { "Early", "Late" }
for k,v in pairs(times) do
	t[#t+1] = Def.BitmapText{
		Font="Common Normal",
		Text=THEME:GetString("ScreenEvaluation",v),
		OnCommand=function(s)
			s:xy(  _screen.cx + eval_part_offs + scale( k, 1, #times, -10, 10 ), _screen.cy+250 ):halign( (1-(k-1)) ):zoom(0.7)
		end,
		OffCommand=function(s)
			s:sleep(0.02*k):decelerate(0.3):diffusealpha(0)
		end,
	}
end

return t