local Nskin = {}

--Defining on which direction the other directions should be bassed on
--This will let us use less files which is quite handy to keep the noteskin directory nice
--Do remember this will Redirect all the files of that Direction to the Direction its pointed to
--If you only want some files to be redirected take a look at the "custom hold/roll per direction"
Nskin.ButtonRedir =
{
	Left = "Up",
	UpLeft = "Up",
	Up = "Up",
	UpRight = "Up",
	Right = "Up"
}

-- Defined the parts to be rotated at which degree
Nskin.Rotate =
{
	Left = -90,
	UpLeft = -45,
	Up = 0,
	UpRight = 45,
	Right = 90
}


--Define elements that need to be redirected
Nskin.ElementRedir =
{
	["Tap Explosion Dim"] = "Tap Explosion Bright",
	["Hold Tail Active"] = "Hold Head Active",
	["Hold Tail Inactive"] = "Hold Head Active",
	["Hold Head Inactive"] = "Hold Head Active",
	["Hold Bottomcap Inactive"] = "Hold Bottomcap Active",
	["Hold Body Inactive"] = "Hold Body Active",
	["Hold Topcap Inactive"] = "Hold Topcap Active"
}

-- Parts of noteskins which we want to rotate
Nskin.PartsToRotate =
{
	["Receptor"] = true,
	["Tap Ghost Dim"] = true,
	["Tap Ghost Bright"] = true,
	["Tap Note"] = true,
	["Tap Fake"] = true,
	["Tap Lift"] = true,
	["Tap Addition"] = true,
	["Hold Head Active"] = true,
	["Hold Head Inactive"] = true,
	["Hold Tail Active"] = true,
	["Hold Tail Inactive"] = true
}

-- Parts that should be Redirected to _Blank.png
-- you can add/remove stuff if you want
Nskin.Blank =
{
	["Hold Explosion"] = true,
}

--Between here we usally put all the commands the noteskin.lua needs to do, some are extern in other files
--If you need help with lua go to http://dguzek.github.io/Lua-For-SM5/API/Lua.xml there are a bunch of codes there
--Also check out common it has a load of lua codes in files there
--Just play a bit with lua its not that hard if you understand coding
--But SM can be an ass in some cases, and some codes jut wont work if you dont have the noteskin on FallbackNoteSkin=common in the metric.ini 
function Nskin.Load()
	local sButton = Var "Button"
	local sElement = Var "Element"

	--Setting global button
	local Button = Nskin.ButtonRedir[sButton] or sButton

	--Setting global element
	local Element = Nskin.ElementRedir[sElement] or sElement
	
	--Returning first part of the code, The redirects, Second part is for commands
	local t = LoadActor(NOTESKIN:GetPath(Button,Element))
	
	--Set blank redirects
	if Nskin.Blank[sElement] then
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