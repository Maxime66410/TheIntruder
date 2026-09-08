-- The Intruder - boot check
-- Confirms the mod is loaded, prints to console at boot and game start

local BANNER = "=================================================="

local function onGameBoot()
    print(BANNER)
    print("[The Intruder] Mod loaded successfully (OnGameBoot)")
    print("[The Intruder] Base OK, mod Lua runs fine")
    print(BANNER)
end

local function onGameStart()
    print("[The Intruder] Game started (OnGameStart), mod active in game")
end

Events.OnGameBoot.Add(onGameBoot)
Events.OnGameStart.Add(onGameStart)
