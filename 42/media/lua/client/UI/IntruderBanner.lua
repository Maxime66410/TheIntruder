--[[
    The Intruder - on screen banner
    Big centered text that fades in and out over a chosen duration.
]]

TheIntruderBanner = ISUIElement:derive("TheIntruderBanner")

function TheIntruderBanner:new(x, y, width, height)
    local o = ISUIElement:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    return o
end

function TheIntruderBanner:render()
    local elapsed = getTimestampMs() - self.startMs
    local remain = self.totalMs - elapsed
    if remain <= 0 then
        self:removeFromUIManager()
        if TheIntruderBanner.instance == self then TheIntruderBanner.instance = nil end
        return
    end

    local a = 1.0
    if elapsed < 400 then a = elapsed / 400 end
    if remain < 900 then a = remain / 900 end

    local font = UIFont.Title or UIFont.Large
    self:drawTextCentre(self.text, self.width / 2, 0, self.r, self.g, self.b, a, font)
end

function TheIntruderBanner.show(text, seconds, r, g, b)
    if TheIntruderBanner.instance then
        TheIntruderBanner.instance:removeFromUIManager()
        TheIntruderBanner.instance = nil
    end

    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local o = TheIntruderBanner:new(0, sh * 0.22, sw, 60)
    o:initialise()
    o.text = text
    o.totalMs = (seconds or 5) * 1000
    o.startMs = getTimestampMs()
    o.r = r or 1
    o.g = g or 0.2
    o.b = b or 0.2
    o:addToUIManager()
    o:setAlwaysOnTop(true)
    TheIntruderBanner.instance = o
end
