return function()
    local screen = SCREENMAN:GetTopScreen()
    local screentype = screen:GetScreenType()
    if screen and screentype == "ScreenType_Gameplay" or screentype == "ScreenType_Attract" then
        setenv("song", 	GAMESTATE:GetCurrentSong() )
        setenv("start", getenv("song"):GetFirstBeat() )
        setenv("now",	GAMESTATE:GetSongBeat() )
    end
end