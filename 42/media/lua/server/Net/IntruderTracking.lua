--[[
    The Intruder - server side tracking feed
    The client only knows nearby players, so the server periodically sends every
    normal player position to each intruder, for the map markers.
]]

local MODULE = "TheIntruder"
local INTERVAL = 30

local counter = 0

local function onTick()
    counter = counter + 1
    if counter < INTERVAL then return end
    counter = 0

    local online = getOnlinePlayers()
    if not online then return end

    local residents = {}
    local intruders = {}
    for i = 0, online:size() - 1 do
        local p = online:get(i)
        local uname = p and p:getUsername()
        if uname then
            if TheIntruderConfig.isIntruderName(uname) then
                table.insert(intruders, p)
            else
                table.insert(residents, { username = uname, x = p:getX(), y = p:getY() })
            end
        end
    end

    if #intruders == 0 or #residents == 0 then return end

    for _, intr in ipairs(intruders) do
        sendServerCommand(intr, MODULE, "residentPositions", { residents = residents })
    end
end

Events.OnTick.Add(onTick)
