--[[
    The Intruder - server side admission
]]

local MODULE = "TheIntruder"

local function pickResident(intruder)
    local online = getOnlinePlayers()
    if not online then return nil end
    local candidates = {}
    for i = 0, online:size() - 1 do
        local p = online:get(i)
        local uname = p and p:getUsername()
        if p and p ~= intruder and uname and not TheIntruderConfig.isIntruderName(uname) then
            table.insert(candidates, p)
        end
    end
    if #candidates == 0 then return nil end
    return candidates[ZombRand(#candidates) + 1]
end

local function admit(player)
    -- Kit once per character
    local md = player:getModData()
    if not md.TheIntruder_serverKit then
        md.TheIntruder_serverKit = true
        TheIntruderKit.give(player)
    end

    -- Teleport near a random resident
    local target = pickResident(player)
    if target then
        local dist = TheIntruderConfig.getSpawnDistance()
        local angle = ZombRand(360) * math.pi / 180
        local x = target:getX() + math.cos(angle) * dist
        local y = target:getY() + math.sin(angle) * dist
        sendServerCommand(player, MODULE, "teleportNear", { x = x, y = y, z = target:getZ() })
    end

    -- Alert everyone
    sendServerCommand(MODULE, "intruderAlert", {})
end

local function onClientCommand(module, command, player, args)
    if module ~= MODULE then return end
    if command ~= "intruderArrived" then return end
    if not player then return end
    if not TheIntruderConfig.isIntruderName(player:getUsername()) then return end

    local ok, reason, seconds = TheIntruderState.canAdmit(player)
    if not ok then
        sendServerCommand(player, MODULE, "rejected", { reason = reason, seconds = seconds })
        return
    end

    admit(player)
end

Events.OnClientCommand.Add(onClientCommand)
