--[[
    The Intruder - server side runtime state
]]

TheIntruderState = TheIntruderState or {}
if TheIntruderState.open == nil then TheIntruderState.open = true end
TheIntruderState.banned = TheIntruderState.banned or {}
TheIntruderState.lastDeath = TheIntruderState.lastDeath or {}

function TheIntruderState.isOpen()
    return TheIntruderState.open == true
end

function TheIntruderState.setOpen(v)
    TheIntruderState.open = (v == true)
end

function TheIntruderState.isBanned(name)
    return TheIntruderState.banned[name] == true
end

function TheIntruderState.setBanned(name, v)
    TheIntruderState.banned[name] = v and true or nil
end

function TheIntruderState.recordDeath(name)
    TheIntruderState.lastDeath[name] = getTimestamp()
end

function TheIntruderState.cooldownLeft(name)
    local last = TheIntruderState.lastDeath[name]
    if not last then return 0 end
    local left = TheIntruderConfig.getRespawnCooldown() - (getTimestamp() - last)
    if left < 0 then left = 0 end
    return left
end

function TheIntruderState.countOnlineIntruders()
    local online = getOnlinePlayers()
    if not online then return 0 end
    local n = 0
    for i = 0, online:size() - 1 do
        local p = online:get(i)
        local u = p and p:getUsername()
        if u and TheIntruderConfig.isIntruderName(u) then n = n + 1 end
    end
    return n
end

function TheIntruderState.canAdmit(player)
    local name = player:getUsername()
    if not TheIntruderState.isOpen() then return false, "closed" end
    if TheIntruderState.isBanned(name) then return false, "banned" end
    local cd = TheIntruderState.cooldownLeft(name)
    if cd > 0 then return false, "cooldown " .. math.ceil(cd) .. "s" end
    if TheIntruderState.countOnlineIntruders() > TheIntruderConfig.getMaxIntruders() then
        return false, "full"
    end
    return true, nil
end
