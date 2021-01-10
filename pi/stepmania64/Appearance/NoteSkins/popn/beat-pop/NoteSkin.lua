local Nskin = {}

--Defining on which direction the other directions should be bassed on
--This will let us use less files which is quite handy to keep the noteskin directory nice
--Do remember this will Redirect all the files of that Direction to the Direction its pointed to
--If you only want some files to be redirected take a look at the "custom hold/roll per direction"
Nskin.ButtonRedir =
{
	["Left White"] = "White",
	["Left Yellow"] = "Blue",
	["Left Green"] = "White",
	["Left Blue"] = "Blue",
	Red = "White",
	["Right Blue"] = "Blue",
	["Right Green"] = "White",
	["Right Yellow"] = "Blue",
	["Right White"] = "White"
}

-- Defined the parts to be rotated at which degree
Nskin.Rotate =
{
	["Left White"] = 0,
	["Left Yellow"] = 0,
	["Left Green"] = 0,
	["Left Blue"] = 0,
	Red = 0,
	["Right Blue"] = 0,
	["Right Green"] = 0,
	["Right Yellow"] = 0,
	["Right White"] = 0
}


--Define elements that need to be redirected
Nskin.ElementRedir =
{
	["Tap Fake"] = "Tap Note",
	["Hold Head Active"] = "Tap Note",
	["Hold Head Inactive"] = "Tap Note",
	["Hold Tail Active"] = "Tap Note",
	["Hold Tail Inactive"] = "Tap Note",
	["Tap Explosion Dim"] = "Tap Explosion",
	["Tap Explosion Bright"] = "Tap Explosion"
}

-- Parts of noteskins which we want to rotate
Nskin.PartsToRotate =
{}

-- Parts that should be Redirected to _Blank.png
-- you can add/remove stuff if you want
Nskin.Blank =
{
	["Hold Bottomcap Active"] = true,
	["Hold Bottomcap Inactive"] = true,
	["Hold Topcap Active"] = true,
	["Hold Topcap Inactive"] = true,
	["Roll Bottomcap Active"] = true,
	["Roll Bottomcap Inactive"] = true,
	["Roll Topcap Active"] = true,
	["Roll Topcap Inactive"] = true,
	["Hold Explosion"] = true,
	["Roll Explosion"] = true

}

--Between here we usally put all the commands the noteskin.lua needs to do, some are extern in other files
--If you need help with lua go to http://dguzek.github.io/Lua-For-SM5/API/Lua.xml there are a bunch of codes there
--Also check out common it has a load of lua codes in files there
--Just play a bit with lua its not that hard if you understand coding
--But SM can be an ass in some cases, and some codes jut wont work if you dont have the noteskin on FallbackNoteSkin=common in the metric.ini 
function Nskin.Load()
	local sButton = Var "Button"
	local sElement = Var "Element"
	local sPlayer = Var "Player"

	--Setting global button
	local Button = Nskin.ButtonRedir[sButton] or "White"
				
	--Setting global element
	local Element = Nskin.ElementRedir[sElement] or sElement

	if string.find(Element, "Tap Explosion") or string.find(Element, "Receptor") then
		Button = "Global"
	end
	
	--Returning first part of the code, The redirects, Second part is for commands
	local t = LoadActor(NOTESKIN:GetPath(Button,Element))
	
	local Blank = false
	
	--Set blank redirects	
	if Nskin.Blank[sElement] or Blank then
		t = Def.Actor {}
		--Check if element is sprite only
		if Var "SpriteOnly" then
			t = LoadActor(NOTESKIN:GetPath("","_blank"))
		end
	end
	
	if Nskin.PartsToRotate[sElement] then
		t.BaseRotationZ = Nskin.Rotate[sButton] or nil
	end
			
	return t
end
-- >

-- dont forget to return cuz else it wont work >
return Nskin