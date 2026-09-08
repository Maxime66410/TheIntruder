--[[
    The Intruder - client networking for the arrival alert
    Sends our arrival to the server, and reacts to the broadcast alert with a
    sound and a banner for normal players.
]]

TheIntruderNet = {}

local MODULE = "TheIntruder"
local ALERT_SOUND = "HouseAlarm"

function TheIntruderNet.announceArrival(player)
    sendClientCommand(player, MODULE, "intruderArrived", {})
end

local pendingDelay = nil

function TheIntruderNet.scheduleAnnounce()
    pendingDelay = 60
end

local function onTick()
    if pendingDelay == nil then return end
    pendingDelay = pendingDelay - 1
    if pendingDelay <= 0 then
        pendingDelay = nil
        local p = getSpecificPlayer(0)
        if p then TheIntruderNet.announceArrival(p) end
    end
end

Events.OnTick.Add(onTick)

local function reasonText(code, seconds)
    if code == "closed" then return getText("IGUI_TheIntruder_Reason_Closed") end
    if code == "banned" then return getText("IGUI_TheIntruder_Reason_Banned") end
    if code == "full" then return getText("IGUI_TheIntruder_Reason_Full") end
    if code == "kicked" then return getText("IGUI_TheIntruder_Reason_Kicked") end
    if code == "cooldown" then return getText("IGUI_TheIntruder_Reason_Cooldown", tostring(seconds or 0)) end
    return getText("IGUI_TheIntruder_Reason_Closed")
end

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end

    if command == "intruderAlert" then
        local p = getSpecificPlayer(0)
        if p and TheIntruderConfig.isIntruderName(p:getUsername()) then return end

        getSoundManager():playUISound(ALERT_SOUND)
        TheIntruderBanner.show(getText("IGUI_TheIntruder_Alert"), 10, 1, 0.55, 0.1)

    elseif command == "teleportNear" and args then
        local p = getSpecificPlayer(0)
        if p then p:teleportTo(args.x, args.y, args.z) end

    elseif command == "rejected" then
        local p = getSpecificPlayer(0)
        if p then p:setBlockMovement(true) end
        local msg = reasonText(args and args.reason, args and args.seconds)
        local sw, sh = getCore():getScreenWidth(), getCore():getScreenHeight()
        local modal = ISModalDialog:new(sw / 2 - 175, sh / 2 - 75, 350, 150,
            msg, false, nil, function() forceDisconnect() end)
        modal:initialise()
        modal:addToUIManager()
    end
end

Events.OnServerCommand.Add(onServerCommand)
