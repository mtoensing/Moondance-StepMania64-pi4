return function()
    return (LoadModule("Characters.HasAnyCharacters.lua")(PLAYER_1) or LoadModule("Characters.HasAnyCharacters.lua")(PLAYER_2))
end