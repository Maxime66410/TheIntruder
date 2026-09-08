--[[
    The Intruder - server list window
    Lists public servers running this mod. Joining uses the saved profile.
]]

local MATCH_TOKEN = "TheIntruder"

TheIntruderWindow = ISCollapsableWindow:derive("TheIntruderWindow")

function TheIntruderWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    local pad = 10
    local top = self:titleBarHeight() + 6
    local w = self.width
    local btnH = 25
    local by = self.height - btnH - pad
    local dcY = by - 36
    local tickY = dcY - 30
    local listY = top + 22
    local listH = tickY - listY - 8

    self.statusLabel = ISLabel:new(pad, top, 18, "Opening...", 1, 1, 1, 1, UIFont.Small, true)
    self.statusLabel:initialise()
    self:addChild(self.statusLabel)

    self.list = ISScrollingListBox:new(pad, listY, w - pad * 2, listH)
    self.list:initialise()
    self.list:instantiate()
    self.list.itemheight = 44
    self.list.font = UIFont.Medium
    self.list.drawBorder = true
    self:addChild(self.list)

    self.showAllTick = ISTickBox:new(pad, tickY, 20, 20, "", nil, nil)
    self.showAllTick:initialise()
    self.showAllTick:addOption("Show all servers (debug)")
    self:addChild(self.showAllTick)

    local dcLabel = ISLabel:new(pad, dcY, 18, "Direct:", 1, 1, 1, 1, UIFont.Small, true)
    dcLabel:initialise()
    self:addChild(dcLabel)

    self.ipEntry = ISTextEntryBox:new("127.0.0.1", pad + 55, dcY - 2, 150, 22)
    self.ipEntry:initialise()
    self.ipEntry:instantiate()
    self:addChild(self.ipEntry)

    self.portEntry = ISTextEntryBox:new("16261", pad + 213, dcY - 2, 70, 22)
    self.portEntry:initialise()
    self.portEntry:instantiate()
    self:addChild(self.portEntry)

    self.joinIpBtn = ISButton:new(pad + 293, dcY - 3, 120, btnH, "Join by IP", self, TheIntruderWindow.onClickJoinIP)
    self.joinIpBtn:initialise()
    self:addChild(self.joinIpBtn)

    local btnW = 110
    self.refreshBtn = ISButton:new(pad, by, btnW, btnH, "Refresh", self, TheIntruderWindow.onClickRefresh)
    self.refreshBtn:initialise()
    self:addChild(self.refreshBtn)

    self.editBtn = ISButton:new(pad + btnW + 10, by, btnW, btnH, "Edit Profile", self, TheIntruderWindow.onClickEditProfile)
    self.editBtn:initialise()
    self:addChild(self.editBtn)

    self.joinBtn = ISButton:new(w - btnW * 2 - 20, by, btnW, btnH, "Join", self, TheIntruderWindow.onClickJoin)
    self.joinBtn:initialise()
    self:addChild(self.joinBtn)

    self.closeBtn = ISButton:new(w - btnW - pad, by, btnW, btnH, "Close", self, TheIntruderWindow.onClickClose)
    self.closeBtn:initialise()
    self:addChild(self.closeBtn)
end

function TheIntruderWindow:doRefresh()
    self.queried = {}
    self.lastSig = nil
    self.list:clear()
    self.statusLabel.name = "Scanning public servers..."
    local mp = MainScreen.instance and MainScreen.instance.multiplayer
    if mp then
        mp:requestServerList()
    end
end

function TheIntruderWindow:onClickRefresh()
    self:doRefresh()
end

function TheIntruderWindow:onClickEditProfile()
    TheIntruderEditProfile.open()
end

function TheIntruderWindow:update()
    ISCollapsableWindow.update(self)
    self.tick = (self.tick or 0) + 1
    if self.tick % 20 ~= 0 then return end
    self:scanAndPopulate()
end

function TheIntruderWindow:scanAndPopulate()
    local mp = MainScreen.instance and MainScreen.instance.multiplayer
    if not mp or not mp.serverList then return end

    local steam = getSteamModeActive()
    local showAll = self.showAllTick:isSelected(1)
    self.queried = self.queried or {}

    local total = 0
    local matches = {}
    local requests = 0

    for _, server in ipairs(mp.serverList) do
        total = total + 1
        local key = tostring(server:getIp()) .. ":" .. tostring(server:getPort())

        if steam and not self.queried[key] and requests < 15 then
            self.queried[key] = true
            requests = requests + 1
            steamRequestServerDetails(getHostByName(server:getIp()), server:getPort())
        end

        local mods = server:getMods() or ""
        local isIntruder = mods ~= "" and mods:find(MATCH_TOKEN) ~= nil
        if showAll or isIntruder then
            table.insert(matches, { server = server, isIntruder = isIntruder })
        end
    end

    local sig = tostring(showAll)
    for _, m in ipairs(matches) do
        sig = sig .. m.server:getIp() .. m.server:getPort() ..
            (m.isIntruder and "1" or "0") .. tostring(m.server:getPlayers())
    end

    if sig ~= self.lastSig then
        self.lastSig = sig
        local prevKey = nil
        local sel = self.list.items[self.list.selected]
        if sel then prevKey = sel.item.key end

        self.list:clear()
        for _, m in ipairs(matches) do
            local s = m.server
            local tag = m.isIntruder and "  [INTRUDER]" or ""
            local text = s:getName() .. "   (" .. s:getPlayers() .. "/" .. s:getMaxPlayers() .. ")" .. tag
            local key = tostring(s:getIp()) .. ":" .. tostring(s:getPort())
            self.list:addItem(text, { server = s, key = key })
            if key == prevKey then self.list.selected = #self.list.items end
        end
    end

    if showAll then
        self.statusLabel.name = "Showing all " .. total .. " public servers (" ..
            self:countIntruder(matches) .. " with The Intruder)"
    else
        self.statusLabel.name = "Scanned " .. total .. " servers, found " .. #matches .. " with The Intruder"
    end
end

function TheIntruderWindow:countIntruder(matches)
    local n = 0
    for _, m in ipairs(matches) do
        if m.isIntruder then n = n + 1 end
    end
    return n
end

function TheIntruderWindow:connectAsIntruder(ip, port, serverPwd, loadingBg, localIP)
    TheIntruderProfile.load()
    if not TheIntruderProfile.name or TheIntruderProfile.name:trim() == "" then
        self.statusLabel.name = "Set your profile first (Edit Profile)"
        TheIntruderEditProfile.open()
        return
    end

    local username = TheIntruderProfile.getUsername()
    local password = TheIntruderProfile.getPassword()

    TheIntruder = TheIntruder or {}
    TheIntruder.joinAsIntruder = true

    if getSteamModeActive() then steamReleaseInternetServersRequest() end
    getCore():setNoSave(false)
    local useSteamRelay = getSteamModeActive() and TheIntruderProfile.useSteamRelay == true
    ConnectToServer.instance.loadingBackground = loadingBg
    ConnectToServer.instance:connect(self, "", username, password,
        ip, localIP or "", tostring(port),
        serverPwd or "", useSteamRelay, true, 1)
end

function TheIntruderWindow:onClickJoin()
    local sel = self.list.items[self.list.selected]
    if not sel then
        self.statusLabel.name = "Select a server first"
        return
    end
    local s = sel.item.server
    local localIP = getSteamModeActive() and s:getLocalIP() or ""
    self:connectAsIntruder(s:getIp(), s:getPort(), s:getServerPassword(),
        s:getServerLoadingScreen(), localIP)
end

function TheIntruderWindow:onClickJoinIP()
    local ip = self.ipEntry:getText()
    if not ip or ip:trim() == "" then
        self.statusLabel.name = "Enter an IP"
        return
    end
    local port = self.portEntry:getText()
    if not port or port:trim() == "" then port = "16261" end
    self:connectAsIntruder(ip:trim(), port:trim(), "", nil, "")
end

function TheIntruderWindow:onClickClose()
    self:close()
end

function TheIntruderWindow:close()
    self:setVisible(false)
    self:removeFromUIManager()
    TheIntruderWindow.instance = nil
end

function TheIntruderWindow.open()
    if TheIntruderWindow.instance then
        TheIntruderWindow.instance:close()
    end

    local w, h = 620, 560
    local x = (getCore():getScreenWidth() - w) / 2
    local y = (getCore():getScreenHeight() - h) / 2

    local win = TheIntruderWindow:new(x, y, w, h)
    win.title = "The Intruder"
    win:initialise()
    win:addToUIManager()
    win:setAlwaysOnTop(true)
    win:bringToTop()
    TheIntruderWindow.instance = win
    win:doRefresh()
end
