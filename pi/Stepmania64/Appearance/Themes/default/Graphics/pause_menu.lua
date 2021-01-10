local ColorTable = LoadModule("Theme.Colors.lua")( LoadModule("Config.Load.lua")("SoundwavesSubTheme","Save/OutFoxPrefs.ini") );

course_stopped_by_pause_menu= false

local prompt_text= {
	Start= THEME:GetString("ScreenGameplay", "GiveUpStartText"),
	Select= THEME:GetString("ScreenGameplay", "GiveUpSelectText"),
	Back= THEME:GetString("ScreenGameplay", "GiveUpBackText"),
}
local prompt_actor= false

local screen_gameplay= false
local menu_items= {[PLAYER_1]= {}, [PLAYER_2]= {}}
local menu_frames= {}
local menu_choices= {
	"continue_playing",
	"restart_song",
	"forfeit_song",
}
if GAMESTATE:IsCourseMode() then
	menu_choices= {
		"continue_playing",
		"skip_song",
		"forfeit_course",
		"end_course",
	}
end
local menu_item_height = 64
local menu_spacing= menu_item_height + 12
local menu_bg_width= _screen.w * .2
local menu_text_width= _screen.w * .35
local menu_x= {[PLAYER_1]= Center1Player() and SCREEN_CENTER_X or THEME:GetMetric(Var "LoadingScreen","PlayerP1OnePlayerOneSideX"), [PLAYER_2]= Center1Player() and SCREEN_CENTER_X or THEME:GetMetric(Var "LoadingScreen","PlayerP2OnePlayerOneSideX")}
local menu_y= _screen.cy - (#menu_choices * .25 * menu_spacing)
local current_menu_choice= {}
local menu_is_showing= {}
local enabled_players= {}

local function create_menu_item(pn, x, y, item_name)
	return 
	Def.ActorFrame {
		InitCommand=function(self) table.insert(menu_items[pn], self) end;
		Def.Quad {InitCommand=function(self) self:xy(x, y):zoomto(menu_bg_width,menu_item_height):diffuse( ColorTable["menuBlockBase"] ) end;},	
		Def.ActorFrame {
			InitCommand= function(self) self:playcommand("LoseFocus") end,
			LoseFocusCommand= function(self) self:diffusealpha(0.2) end,
			GainFocusCommand= function(self) self:diffusealpha(0.8)	end,
			-- Fade BG
			Def.Quad {InitCommand=function(self) self:xy(x, y):horizalign(right):faderight(0.9):zoomto(menu_bg_width/2,menu_item_height):diffuse( ColorTable["menuBlockGlow"] ) end,},
			Def.Quad {InitCommand=function(self) self:xy(x, y):horizalign(left):fadeleft(0.9):zoomto(menu_bg_width/2,menu_item_height):diffuse( ColorTable["menuBlockGlow"] ) end,},
			-- Stripeys
			Def.Quad {InitCommand=function(self) self:xy(x, y):addy(menu_item_height/2):vertalign(bottom):zoomto(menu_bg_width,menu_item_height*0.11):diffuse(  ColorTable["menuBlockHighlightA"] ):diffuserightedge(  ColorTable["menuBlockHighlightB"] ):blend("Add") end,},
			Def.Quad {InitCommand=function(self) self:xy(x, y):addy(-(menu_item_height/2)):vertalign(top):zoomto(menu_bg_width,menu_item_height*0.11):diffuse(  ColorTable["menuBlockHighlightA"] ):diffuserightedge(  ColorTable["menuBlockHighlightB"] ):blend("Add") end,},
		};
		Def.BitmapText{
			Font= "_Medium", Text= THEME:GetString("PauseMenu", item_name),
			InitCommand= function(self)
				self:xy(x, y):diffuse( ColorTable["menuTextGainFocus"] )
				self:playcommand("LoseFocus")
			end,
			LoseFocusCommand= function(self)
				self:diffusealpha(0.5)
			end,
			GainFocusCommand= function(self)
				self:diffusealpha(1)
			end,
		}
	}
end

local function create_menu_frame(pn, x, y)
	local frame= Def.ActorFrame{
		InitCommand= function(self)
			self:xy(x, y):playcommand("Hide")
			menu_frames[pn]= self
		end,
		ShowCommand= function(self)
			self:visible(true)
		end,
		HideCommand= function(self)
			self:visible(false)
		end,
	}
	for i, choice in ipairs(menu_choices) do
		frame[#frame+1]= create_menu_item(pn, 0, (i-1)*menu_spacing, choice)
	end
	return frame
end

local function backout(screen)
	screen_gameplay:SetPrevScreenName(screen):begin_backing_out()
end

local function show_menu(pn)
	menu_frames[pn]:playcommand("Show")
	for i, item in ipairs(menu_items[pn]) do
		item:playcommand("LoseFocus")
	end
	current_menu_choice[pn]= 1
	menu_items[pn][current_menu_choice[pn]]:playcommand("GainFocus")
	menu_is_showing[pn]= true
end

local function close_menu(pn)
	menu_frames[pn]:playcommand("Hide")
	menu_is_showing[pn]= false
	local stay_paused= false
	for pn, showing in pairs(menu_is_showing) do
		if showing then
			stay_paused= true
		end
	end
	if not stay_paused then
		local fg= screen_gameplay:GetChild("SongForeground")
		if fg then fg:visible(old_fg_visible) end
		screen_gameplay:PauseGame(false)
	end
end

local choice_actions= {
	continue_playing= function(pn)
		close_menu(pn)
	end,
	restart_song= function(pn)
		backout("ScreenStageInformation")
	end,
	forfeit_song= function(pn)
		backout(SelectMusicOrCourse())
	end,
	skip_song= function(pn)
		screen_gameplay:PostScreenMessage("SM_NotesEnded", 0)
	end,
	forfeit_course= function(pn)
		backout(SelectMusicOrCourse())
	end,
	end_course= function(pn)
		course_stopped_by_pause_menu= true
		screen_gameplay:PostScreenMessage("SM_NotesEnded", 0)
	end,
}

local menu_actions= {
	Start= function(pn)
		local choice_name= menu_choices[current_menu_choice[pn]]
		if choice_actions[choice_name] then
			choice_actions[choice_name](pn)
		end
	end,
	Left= function(pn)
		if current_menu_choice[pn] > 1 then
			menu_items[pn][current_menu_choice[pn]]:playcommand("LoseFocus")
			current_menu_choice[pn]= current_menu_choice[pn] - 1
			menu_items[pn][current_menu_choice[pn]]:playcommand("GainFocus")
		end
	end,
	Right= function(pn)
		if current_menu_choice[pn] < #menu_choices then
			menu_items[pn][current_menu_choice[pn]]:playcommand("LoseFocus")
			current_menu_choice[pn]= current_menu_choice[pn] + 1
			menu_items[pn][current_menu_choice[pn]]:playcommand("GainFocus")
		end
	end,
}
menu_actions.Up= menu_actions.Left
menu_actions.Down= menu_actions.Right
menu_actions.MenuLeft= menu_actions.Left
menu_actions.MenuRight= menu_actions.Right
menu_actions.MenuUp= menu_actions.Up
menu_actions.MenuDown= menu_actions.Down

local function pause_and_show(pn)
	screen_gameplay:PauseGame(true)
	local fg= screen_gameplay:GetChild("SongForeground")
	if fg then
		old_fg_visible= fg:GetVisible()
		fg:visible(false)
	end
	prompt_actor:playcommand("Hide")
	show_menu(pn)
end

local function show_prompt(button)
	prompt_actor:playcommand("Show", {text= prompt_text[button]})
end

local function hide_prompt()
	prompt_actor:playcommand("Hide")
end

local function input(event)
	local pn= event.PlayerNumber
	if not enabled_players[pn] then return end
	local button= event.GameButton
	if not button then return end
	if event.type == "InputEventType_Release" then return end
	local is_paused= screen_gameplay:IsPaused()
	if is_paused then
		if menu_is_showing[pn] then
			if menu_actions[button] then
				menu_actions[button](pn)
				return
			end
		else
			if button == "Start" then
				show_menu(pn)
				return
			end
		end
	end
end

local frame= Def.ActorFrame{
	OnCommand= function(self)
		screen_gameplay= SCREENMAN:GetTopScreen()
		if screen_gameplay:GetName() == "ScreenGameplaySyncMachine" then return end
		screen_gameplay:AddInputCallback(input)
	end,
	PlayerHitPauseMessageCommand= function(self, params)
		pause_and_show(params.pn)
	end,
	ShowPausePromptMessageCommand= function(self, params)
		show_prompt(params.button)
	end,
	HidePausePromptMessageCommand= function(self)
		hide_prompt()
	end,
	pause_controller_actor(),
	Def.BitmapText{
		Font= "_Medium", InitCommand= function(self)
			prompt_actor= self
			self:xy(_screen.cx, _screen.h*.75):zoom(1):strokecolor(color("#101E4B")):shadowlength(1):diffusealpha(0)
		end,
		ShowCommand= function(self, param)
			self:stoptweening():settext(param.text):accelerate(.25):diffusealpha(1)
				:sleep(1):queuecommand("Hide")
		end,
		HideCommand= function(self)
			self:stoptweening():decelerate(.25):diffusealpha(0)
		end,
	},
}

for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
	enabled_players[pn]= true
	frame[#frame+1]= create_menu_frame(pn, menu_x[pn], menu_y)
end

return frame
