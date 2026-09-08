--[[
    The Intruder - client death report
    OnPlayerDeath fires reliably on the client, so the intruder tells the server
    it died, which starts the respawn cooldown.
]]

local MODULE = "TheIntruder"

local function onPlayerDeath(player)
    if not player or not player:isLocalPlayer() then return end
    if not TheIntruderConfig.isIntruderName(player:getUsername()) then return end
    sendClientCommand(player, MODULE, "intruderDied", {})
end

Events.OnPlayerDeath.Add(onPlayerDeath)
