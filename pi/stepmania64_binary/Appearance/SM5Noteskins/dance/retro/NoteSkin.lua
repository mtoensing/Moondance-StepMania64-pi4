-- HELP HOW DO I USE NOTESKINS

local ret = ... or {};

ret.RedirTable =
{
	Up = "Down",
	Down = "Down",
	Left = "Down",
	Right = "Down",
	UpLeft = "Down",
	UpRight = "Down",
};

local OldRedir = ret.Redir;
ret.Redir = function(sButton, sElement)
	sButton, sElement = OldRedir(sButton, sElement);

	-- Instead of separate roll heads (for now), use the tap note graphics.
	if sElement == "Roll Head Inactive" or
	   sElement == "Roll Head Active"
	then
		sElement = "Tap Note";
	end

	sButton = ret.RedirTable[sButton];

	return sButton, sElement;
end

-- To have separate graphics for each hold part:
local OldRedir = ret.Redir;
ret.Redir = function(sButton, sElement)
	-- Redirect non-hold, non-roll parts.
	if string.find(sElement, "hold") then
		return sButton, sElement;
	end
	return OldRedir(sButton, sElement);
end

local OldFunc = ret.Load;
function ret.Load()
	local t = OldFunc();

	-- The main "Explosion" part just loads other actors;it.
	if Var "Element" == "Explosion" then
		t.BaseRotationZ = nil;
	end
	return t;
end

ret.PartsToRotate =
{
	["Receptor"] = true,
	["Go Receptor"] = true,
	["Ready Receptor"] = true,
	["Tap Explosion Bright"] = true,
	["Tap Explosion Dim"] = true,
	["Tap Note"] = true,
	["Hold Head Active"] = true,
	["Hold Head Inactive"] = true,
	["Roll Head Active"] = true,
	["Roll Head Inactive"] = true,
	["Hold Explosion"] = true,
	["Roll Explosion"] = true,
};
ret.Rotate =
{
	Up = 180,
	Down = 0,
	Left = 90,
	Right = -90,
	UpLeft = 135,
	UpRight = 225,
};

-- If a derived skin wants to have separate UpLeft graphics,
-- use this:

ret.RedirTable.UpLeft = "UpLeft";
ret.RedirTable.UpRight = "UpLeft";
ret.Rotate.UpLeft = 0;
ret.Rotate.UpRight = 90;

ret.Blank =
{
	["Hold Topcap Active"] = true,
	["Hold Topcap Inactive"] = true,
	["Roll Topcap Active"] = true,
	["Roll Topcap Inactive"] = true,
	["Hold Tail Active"] = true,
	["Hold Tail Inactive"] = true,
	["Roll Tail Active"] = true,
	["Roll Tail Inactive"] = true,
};

return ret;
