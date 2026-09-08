--[[
    The Intruder - shared config and constants
    Reads the sandbox options and exposes the forced suffix used to spot intruders.
]]

TheIntruderConfig = {}

TheIntruderConfig.SUFFIX = "_TI"

local MELEE = { [1] = nil, [2] = "RANDOM", [3] = "Base.BaseballBat", [4] = "Base.HuntingKnife", [5] = "Base.Crowbar" }
local MELEE_RANDOM = { "Base.BaseballBat", "Base.HuntingKnife", "Base.Crowbar", "Base.Axe", "Base.HandAxe" }
local BAG = { [1] = nil, [2] = "Base.Bag_Schoolbag", [3] = "Base.Bag_DuffelBag", [4] = "Base.Bag_BigHikingBag" }

function TheIntruderConfig.isIntruderName(username)
    if not username or username == "" then return false end
    local s = TheIntruderConfig.SUFFIX
    return #username >= #s and username:sub(-#s) == s
end

local function sv()
    return (SandboxVars and SandboxVars.TheIntruder) or {}
end

function TheIntruderConfig.getMaxIntruders()
    return sv().MaxIntruders or 2
end

function TheIntruderConfig.getSpawnDistance()
    return sv().SpawnDistance or 30
end

function TheIntruderConfig.getRespawnCooldown()
    return sv().RespawnCooldown or 120
end

function TheIntruderConfig.buildKitItems()
    local o = sv()
    local items = {}

    local melee = MELEE[o.KitMelee or 2]
    if melee == "RANDOM" then
        melee = MELEE_RANDOM[ZombRand(#MELEE_RANDOM) + 1]
    end
    if melee then table.insert(items, melee) end

    local bag = BAG[o.KitBag or 2]
    if bag then table.insert(items, bag) end

    local food = o.KitFood or 2
    for _ = 1, food do
        table.insert(items, "Base.TinnedBeans")
    end

    if o.KitFirstAid ~= false then
        table.insert(items, "Base.Bandage")
        table.insert(items, "Base.Bandage")
    end

    local custom = o.KitCustomItems or ""
    for id in string.gmatch(custom, "[^;]+") do
        id = string.trim(id)
        if id ~= "" then table.insert(items, id) end
    end

    return items
end
