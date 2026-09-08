--[[
    The Intruder - map markers
    On the world map, if the local player is an intruder, draw a marker at each
    normal player position (fed by the server tracking feed).
]]

local original_render = ISWorldMap.render
function ISWorldMap:render()
    original_render(self)

    local me = getSpecificPlayer(0)
    if not me or not TheIntruderConfig.isIntruderName(me:getUsername()) then return end
    if not self.mapAPI then return end

    local data = TheIntruderTracker and TheIntruderTracker.residents
    if not data then return end

    local size = 10
    for _, r in ipairs(data) do
        local sx = self.mapAPI:worldToUIX(r.x, r.y)
        local sy = self.mapAPI:worldToUIY(r.x, r.y)
        if sx >= 0 and sy >= 0 and sx < self.width and sy < self.height then
            self:drawRect(sx - size / 2, sy - size / 2, size, size, 1.0, 1.0, 0.2, 0.2)
            self:drawRectBorder(sx - size / 2, sy - size / 2, size, size, 1.0, 1.0, 1.0, 1.0)
            if r.username then
                self:drawText(r.username, sx + size, sy - 6, 1.0, 0.4, 0.4, 1.0, UIFont.Small)
            end
        end
    end
end
