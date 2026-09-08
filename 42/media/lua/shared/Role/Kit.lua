--[[
    The Intruder - intruder kit
    Gives the loadout built from the sandbox options to a player.
]]

TheIntruderKit = {}

function TheIntruderKit.give(player)
    if not player then return end
    local inv = player:getInventory()
    local items = TheIntruderConfig.buildKitItems()
    for _, id in ipairs(items) do
        if getScriptManager():FindItem(id) then
            local item = inv:AddItem(id)
            sendAddItemToContainer(inv, item)
        else
            print("[The Intruder] Kit item not found, skipped: " .. tostring(id))
        end
    end
end
