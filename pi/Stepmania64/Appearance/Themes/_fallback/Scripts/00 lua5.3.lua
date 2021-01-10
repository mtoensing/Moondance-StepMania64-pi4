if string.find(_VERSION, "5.3") then

function math.pow(x,y) return x^y end
function math.ldexp(x,exp) return x * 2.0^exp end
math.mod = math.fmod
string.gfind = string.gmatch
math.atan2 = math.atan
loadstring = load
unpack = table.unpack

function table.getn(t) return #t end
function math.log10(x) return math.log(x,10) end

-- helper function for `getfenv`/`setfenv`
local function envlookup(f)
  local name, val
  local up = 0
  local unknown
  repeat
    up=up+1; name, val = debug.getupvalue(f, up)
    if name == '' then unknown = true end
  until name == '_ENV' or name == nil
  if name ~= '_ENV' then
    up = nil
    if unknown then error("upvalues not readable in Lua 5.2 when debug info missing", 3) end
  end
  return (name == '_ENV') and up, val, unknown
end

-- helper function for `getfenv`/`setfenv`
local function envhelper(f, name)
  if type(f) == 'number' then
    if f < 0 then
      error(("bad argument #1 to '%s' (level must be non-negative)"):format(name), 3)
    elseif f < 1 then
      error("thread environments unsupported in Lua 5.2", 3) --[*]
    end
    f = debug.getinfo(f+2, 'f').func
  elseif type(f) ~= 'function' then
    error(("bad argument #1 to '%s' (number expected, got %s)"):format(type(name, f)), 2)
  end
  return f
end
-- [*] might simulate with table keyed by coroutine.running()
  
-- 5.1 style `setfenv` implemented in 5.2
function setfenv(f, t)
  local f = envhelper(f, 'setfenv')
  local up, val, unknown = envlookup(f)
  if up then
    debug.upvaluejoin(f, up, function() return up end, 1) -- unique upvalue [*]
    debug.setupvalue(f, up, t)
  else
    local what = debug.getinfo(f, 'S').what
    if what ~= 'Lua' and what ~= 'main' then -- not Lua func
      error("'setfenv' cannot change environment of given object", 2)
    end -- else ignore no _ENV upvalue (warning: incompatible with 5.1)
  end
  return f
end
-- [*] http://lua-users.org/lists/lua-l/2010-06/msg00313.html

-- 5.1 style `getfenv` implemented in 5.2
function getfenv(f)
  if f == 0 or f == nil then return _G end -- simulated behavior
  local f = envhelper(f, 'setfenv')
  local up, val = envlookup(f)
  if not up then return _G end -- simulated behavior [**]
  return val
end

--cosh, sinh and tanh functions.
function math.cosh (x)
  if x == 0.0 then return 1.0 end
  if x < 0.0 then x = -x end
  x = math.exp(x)
  x = x / 2.0 + 0.5 / x
  return x
end


function math.sinh (x)
  if x == 0 then return 0.0 end
  local neg = false
  if x < 0 then x = -x; neg = true end
  if x < 1.0 then
    local y = x * x
    x = x + x * y *
        (((-0.78966127417357099479e0  * y +
           -0.16375798202630751372e3) * y +
           -0.11563521196851768270e5) * y +
           -0.35181283430177117881e6) /
        ((( 0.10000000000000000000e1  * y +
           -0.27773523119650701667e3) * y +
            0.36162723109421836460e5) * y +
           -0.21108770058106271242e7)
  else
    x =  math.exp(x)
    x = x / 2.0 - 0.5 / x
  end
  if neg then x = -x end
  return x
end


function math.tanh (x)
  if x == 0 then return 0.0 end
  local neg = false
  if x < 0 then x = -x; neg = true end
  if x < 0.54930614433405 then
    local y = x * x
    x = x + x * y *
        ((-0.96437492777225469787e0  * y +
          -0.99225929672236083313e2) * y +
          -0.16134119023996228053e4) /
        (((0.10000000000000000000e1  * y +
           0.11274474380534949335e3) * y +
           0.22337720718962312926e4) * y +
           0.48402357071988688686e4)
  else
    x = math.exp(x)
    x = 1.0 - 2.0 / (x * x + 1.0)
  end
  if neg then x = -x end
  return x
end

end
