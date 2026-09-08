--[[
    The Intruder - host control panel (admin only)
]]

TheIntruderHostPanel = ISCollapsableWindow:derive("TheIntruderHostPanel")

function TheIntruderHostPanel:createChildren()
    ISCollapsableWindow.createChildren(self)

    local pad = 10
    local top = self:titleBarHeight() + 6
    local w = self.width
    local btnH = 25
    local by = self.height - btnH - pad

    -- Opening toggle
    self.openBtn = ISButton:new(pad, top, w - pad * 2, btnH, getText("IGUI_TheIntruder_OpeningOn"), self, TheIntruderHostPanel.onToggleOpen)
    self.openBtn:initialise()
    self:addChild(self.openBtn)

    local listY = top + btnH + 8
    if not getServerOptions():getBoolean("PVP") then
        self.pvpWarn = ISLabel:new(pad, top + btnH + 6, 16, getText("IGUI_TheIntruder_PvpWarning"),
            1, 0.3, 0.3, 1, UIFont.Small, true)
        self.pvpWarn:initialise()
        self:addChild(self.pvpWarn)
        listY = top + btnH + 28
    end

    -- Intruder list
    local listH = by - listY - 8
    self.list = ISScrollingListBox:new(pad, listY, w - pad * 2, listH)
    self.list:initialise()
    self.list:instantiate()
    self.list.itemheight = 24
    self.list.font = UIFont.Medium
    self.list.drawBorder = true
    self:addChild(self.list)

    -- Bottom buttons
    local btnW = 100
    self.kickBtn = ISButton:new(pad, by, btnW, btnH, getText("IGUI_TheIntruder_Kick"), self, TheIntruderHostPanel.onKick)
    self.kickBtn:initialise()
    self:addChild(self.kickBtn)

    self.banBtn = ISButton:new(pad + btnW + 10, by, btnW, btnH, getText("IGUI_TheIntruder_Ban"), self, TheIntruderHostPanel.onBan)
    self.banBtn:initialise()
    self:addChild(self.banBtn)

    self.closeBtn = ISButton:new(w - btnW - pad, by, btnW, btnH, getText("IGUI_TheIntruder_Close"), self, TheIntruderHostPanel.onClose)
    self.closeBtn:initialise()
    self:addChild(self.closeBtn)

    self:refreshFromState()
    TheIntruderHost.requestState()
end

function TheIntruderHostPanel:refreshFromState()
    self.openBtn:setTitle(getText(TheIntruderHost.open and "IGUI_TheIntruder_OpeningOn" or "IGUI_TheIntruder_OpeningOff"))
    local prev = self.list.items[self.list.selected]
    local prevName = prev and prev.item
    self.list:clear()
    for _, name in ipairs(TheIntruderHost.intruders or {}) do
        self.list:addItem(name, name)
        if name == prevName then self.list.selected = #self.list.items end
    end
end

-- Keep the panel live: ask the server for a fresh state about once a second
function TheIntruderHostPanel:update()
    ISCollapsableWindow.update(self)
    self.refreshTick = (self.refreshTick or 0) + 1
    if self.refreshTick % 60 == 0 then
        TheIntruderHost.requestState()
    end
end

function TheIntruderHostPanel:selectedName()
    local sel = self.list.items[self.list.selected]
    return sel and sel.item or nil
end

function TheIntruderHostPanel:onToggleOpen()
    TheIntruderHost.toggleOpen()
end

function TheIntruderHostPanel:onKick()
    local name = self:selectedName()
    if name then TheIntruderHost.kick(name) end
end

function TheIntruderHostPanel:onBan()
    local name = self:selectedName()
    if name then TheIntruderHost.ban(name) end
end

function TheIntruderHostPanel:onClose()
    self:setVisible(false)
    self:removeFromUIManager()
    TheIntruderHostPanel.instance = nil
end

function TheIntruderHostPanel.open()
    if TheIntruderHostPanel.instance then
        TheIntruderHostPanel.instance:onClose()
    end
    local w, h = 380, 320
    local x = (getCore():getScreenWidth() - w) / 2
    local y = (getCore():getScreenHeight() - h) / 2
    local win = TheIntruderHostPanel:new(x, y, w, h)
    win.title = getText("IGUI_TheIntruder_HostTitle")
    win:initialise()
    win:addToUIManager()
    win:setAlwaysOnTop(true)
    win:bringToTop()
    TheIntruderHostPanel.instance = win
end
