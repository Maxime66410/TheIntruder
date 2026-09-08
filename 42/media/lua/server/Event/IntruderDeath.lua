--[[
    The Intruder - server side death tracking
]]

local MODULE = "TheIntruder"

local function onPlayerDeath(player)
    if not player then return end
    local uname = player:getUsername()
    if uname and TheIntruderConfig.isIntruderName(uname) then
        TheIntruderState.recordDeath(uname)
    end
end

local function onClientCommand(module, command, player, args)
    if module ~= MODULE then return end
    if command ~= "intruderDied" then return end
    if not player then return end
    local uname = player:getUsername()
    if not (uname and TheIntruderConfig.isIntruderName(uname)) then return end

    TheIntruderState.recordDeath(uname)

    local cd = TheIntruderConfig.getRespawnCooldown()
    if cd > 0 then
        sendServerCommand(player, MODULE, "rejected", { reason = "died, cooldown " .. cd .. "s" })
    end
end

Events.OnPlayerDeath.Add(onPlayerDeath)
Events.OnClientCommand.Add(onClientCommand)
