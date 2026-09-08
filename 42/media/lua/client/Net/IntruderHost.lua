--[[
    The Intruder - client host controls networking
    Sends admin actions to the server and receives the host state for the panel.
]]

TheIntruderHost = TheIntruderHost or {}
TheIntruderHost.open = true
TheIntruderHost.intruders = {}

local MODULE = "TheIntruder"

function TheIntruderHost.requestState()
    sendClientCommand(getSpecificPlayer(0), MODULE, "hostRequestState", {})
end

function TheIntruderHost.toggleOpen()
    sendClientCommand(getSpecificPlayer(0), MODULE, "hostToggleOpen", {})
end

function TheIntruderHost.kick(name)
    sendClientCommand(getSpecificPlayer(0), MODULE, "hostKick", { name = name })
end

function TheIntruderHost.ban(name)
    sendClientCommand(getSpecificPlayer(0), MODULE, "hostBan", { name = name })
end

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end
    if command == "hostState" and args then
        TheIntruderHost.open = args.open
        TheIntruderHost.intruders = args.intruders or {}
        if TheIntruderHostPanel and TheIntruderHostPanel.instance then
            TheIntruderHostPanel.instance:refreshFromState()
        end
    end
end

Events.OnServerCommand.Add(onServerCommand)
