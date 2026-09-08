--[[
    The Intruder - open the host panel with a key
    Home key, admins only.
]]

local function onKeyPressed(key)
    if key ~= Keyboard.KEY_HOME then return end
    if getAccessLevel() ~= "admin" then return end
    TheIntruderHostPanel.open()
end

Events.OnKeyPressed.Add(onKeyPressed)
