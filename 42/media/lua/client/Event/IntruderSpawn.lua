--[[
    The Intruder - spawn handler
]]

local waitTicks = nil

local function resolveIntruder()
    local player = getSpecificPlayer(0)
    if not player then return false end
    local username = player:getUsername()
    if not username or username == "" then return false end

    if TheIntruderConfig.isIntruderName(username) then
        TheIntruderBanner.show("YOU ARE THE INTRUDER", 10)
        TheIntruderNet.scheduleAnnounce()
    end
    return true
end

local function onTick()
    if waitTicks == nil then return end
    waitTicks = waitTicks - 1
    if resolveIntruder() or waitTicks <= 0 then
        waitTicks = nil
    end
end

local function onCreatePlayer(playerIndex, player)
    if not player or not player:isLocalPlayer() then return end
    waitTicks = 600
end

Events.OnCreatePlayer.Add(onCreatePlayer)
Events.OnTick.Add(onTick)
