--[[
    The Intruder - client tracking receiver
    Stores the resident positions sent by the server, drawn on the map elsewhere.
]]

TheIntruderTracker = TheIntruderTracker or {}
TheIntruderTracker.residents = TheIntruderTracker.residents or {}

local MODULE = "TheIntruder"

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end
    if command == "residentPositions" and args then
        TheIntruderTracker.residents = args.residents or {}
    end
end

Events.OnServerCommand.Add(onServerCommand)
