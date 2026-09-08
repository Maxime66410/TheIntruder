--[[
    The Intruder - force the intruder into PvP
]]

TheIntruderPvp = TheIntruderPvp or {}

local tries = nil

function TheIntruderPvp.ensureUnsafe()
    if not TheIntruderConfig.getForcePvp() then return end
    tries = 300
end

local function onTick()
    if tries == nil then return end
    tries = tries - 1

    local player = getSpecificPlayer(0)
    if not player then
        if tries <= 0 then tries = nil end
        return
    end

    if not getServerOptions():getBoolean("SafetySystem") then tries = nil return end

    local safety = player:getSafety()
    if not safety then tries = nil return end

    if not safety:isEnabled() then tries = nil return end

    if safety:isToggleAllowed() then
        safety:toggleSafety()
        tries = nil
        return
    end

    if tries <= 0 then tries = nil end
end

Events.OnTick.Add(onTick)
