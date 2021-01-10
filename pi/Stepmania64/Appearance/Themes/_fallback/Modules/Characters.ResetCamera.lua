-- This will reset the camera in case it is needed.
-- It is quite recommended that this is applied on the start of every Camera MessageCommand.
return function()
    Camera:rotationy(180):rotationx(0):rotationz(0)
    :Center():z(WideScale(300,400)):addy(10)
    :stopeffect()

    return self
end