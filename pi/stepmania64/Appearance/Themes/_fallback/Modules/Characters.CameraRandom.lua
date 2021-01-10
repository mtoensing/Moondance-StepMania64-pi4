return function()
    if NumCam and StageHasCamera then
        if tobool( Config.Load( "IsCameraTweenSequential",LoadModule("Characters.CallCurrentStage.lua")().."/ModelConfig.ini",false ) ) then
            if CurrentStageCamera > NumCam then
                CurrentStageCamera = 1
            end
            return CurrentStageCamera
        end
        local newnum = math.random( NumCam )
        return ( NumCam > 1 and ( newnum ~= CurrentStageCamera and newnum or math.random( NumCam ) ) ) or NumCam
    end
    return math.random(5)
end