local File, Width = ...
assert( File );
assert( Width );

local FullFile = THEME:GetPathG('','_frame files 3x1/'..File )
local Frame = LoadActor( FullFile )

return Def.ActorFrame {
	Frame .. { InitCommand=cmd(setstate,0;pause;horizalign,right;x,-Width/2) };
	Frame .. { InitCommand=cmd(setstate,1;pause;zoomtowidth,Width) };
	Frame .. { InitCommand=cmd(setstate,2;pause;horizalign,left;x,Width/2) };
};
