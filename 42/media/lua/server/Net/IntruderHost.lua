--[[
    The Intruder - server side Admin controls
]]

local MODULE = "TheIntruder"

local function isAdmin(player)
    if not player then return false end
    return string.lower(tostring(player:getAccessLevel())) == "admin"
end

local function kickAllIntruders(reason)
    local online = getOnlinePlayers()
    if not online then return end
    for i = 0, online:size() - 1 do
        local p = online:get(i)
        local u = p and p:getUsername()
        if u and TheIntruderConfig.isIntruderName(u) then
            sendServerCommand(p, MODULE, "rejected", { reason = reason })
        end
    end
end

local function findOnlineByName(name)
    local online = getOnlinePlayers()
    if not online then return nil end
    for i = 0, online:size() - 1 do
        local p = online:get(i)
        if p and p:getUsername() == name then return p end
    end
    return nil
end

local function sendState(player)
    local list = {}
    local online = getOnlinePlayers()
    if online then
        for i = 0, online:size() - 1 do
            local p = online:get(i)
            local u = p and p:getUsername()
            if u and TheIntruderConfig.isIntruderName(u) then table.insert(list, u) end
        end
    end
    sendServerCommand(player, MODULE, "hostState", { open = TheIntruderState.isOpen(), intruders = list })
end

local function onClientCommand(module, command, player, args)
    if module ~= MODULE then return end
    if not isAdmin(player) then return end

    if command == "hostRequestState" then
        sendState(player)
    elseif command == "hostToggleOpen" then
        TheIntruderState.setOpen(not TheIntruderState.isOpen())
        if not TheIntruderState.isOpen() then
            kickAllIntruders("closed")
        end
        sendState(player)
    elseif command == "hostKick" and args and args.name then
        local target = findOnlineByName(args.name)
        if target then sendServerCommand(target, MODULE, "rejected", { reason = "kicked" }) end
        sendState(player)
    elseif command == "hostBan" and args and args.name then
        TheIntruderState.setBanned(args.name, true)
        local target = findOnlineByName(args.name)
        if target then sendServerCommand(target, MODULE, "rejected", { reason = "banned" }) end
        sendState(player)
    end
end

Events.OnClientCommand.Add(onClientCommand)
