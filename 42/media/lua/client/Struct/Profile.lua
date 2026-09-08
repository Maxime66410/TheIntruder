--[[
    The Intruder - single reusable profile
    One name, password and relay setting saved to a file, used everywhere.
    A forced suffix is always appended to the name and cannot be edited.
]]

TheIntruderProfile = {}

local FILE = "TheIntruder_profile.ini"

TheIntruderProfile.name = "Intruder"
TheIntruderProfile.password = ""
TheIntruderProfile.useSteamRelay = false

function TheIntruderProfile.getSuffix()
    return TheIntruderConfig.SUFFIX
end

-- Default password
function TheIntruderProfile.getDefaultPassword()
    if getSteamModeActive() then
        local id = getCurrentUserSteamID()
        if id and tostring(id) ~= "" then
            return tostring(id)
        end
    end
    return "intruder"
end

-- Safe Characters
local function sanitize(base)
    base = base or ""
    base = base:gsub("[^%w_]", "")
    if base == "" then base = "Intruder" end
    return base
end

-- Username + SUFFIX
function TheIntruderProfile.getUsername()
    return sanitize(TheIntruderProfile.name) .. TheIntruderConfig.SUFFIX
end

-- Password
function TheIntruderProfile.getPassword()
    local p = TheIntruderProfile.password
    if not p or p == "" then
        return TheIntruderProfile.getDefaultPassword()
    end
    return p
end

function TheIntruderProfile.load()
    local reader = getFileReader(FILE, false)
    if not reader then return end
    while true do
        local line = reader:readLine()
        if line == nil then
            reader:close()
            break
        end
        line = string.trim(line)
        local k, v = line:match("^(%w+)=(.*)$")
        if k == "name" then TheIntruderProfile.name = v end
        if k == "password" then TheIntruderProfile.password = v end
        if k == "useSteamRelay" then TheIntruderProfile.useSteamRelay = (v == "true") end
    end
end

function TheIntruderProfile.save()
    local writer = getFileWriter(FILE, true, false)
    writer:write("name=" .. (TheIntruderProfile.name or "") .. "\r\n")
    writer:write("password=" .. (TheIntruderProfile.password or "") .. "\r\n")
    writer:write("useSteamRelay=" .. tostring(TheIntruderProfile.useSteamRelay == true) .. "\r\n")
    writer:close()
end
