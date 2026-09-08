--[[
    The Intruder - edit profile window
    Edits the single reusable profile, name, password and steam relay.
]]

TheIntruderEditProfile = ISCollapsableWindow:derive("TheIntruderEditProfile")

function TheIntruderEditProfile:createChildren()
    ISCollapsableWindow.createChildren(self)

    local pad = 14
    local top = self:titleBarHeight() + 12
    local labelW = 70
    local entryX = pad + labelW
    local entryW = self.width - entryX - pad

    -- Name
    local nameLabel = ISLabel:new(pad, top, 18, "Name", 1, 1, 1, 1, UIFont.Medium, true)
    nameLabel:initialise()
    self:addChild(nameLabel)

    self.nameEntry = ISTextEntryBox:new("", entryX, top - 2, entryW - 90, 24)
    self.nameEntry:initialise()
    self.nameEntry:instantiate()
    self:addChild(self.nameEntry)

    self.suffixLabel = ISLabel:new(entryX + entryW - 84, top, 18,
        TheIntruderProfile.getSuffix() .. "", 0.6, 0.6, 0.6, 1, UIFont.Small, true)
    self.suffixLabel:initialise()
    self:addChild(self.suffixLabel)

    -- Password
    local passY = top + 36
    local passLabel = ISLabel:new(pad, passY, 18, "Password", 1, 1, 1, 1, UIFont.Medium, true)
    passLabel:initialise()
    self:addChild(passLabel)

    self.passEntry = ISTextEntryBox:new("", entryX, passY - 2, entryW, 24)
    self.passEntry:initialise()
    self.passEntry:instantiate()
    self.passEntry:setMasked(true)
    self:addChild(self.passEntry)

    -- Hint
    local hintY = passY + 28
    local hint = ISLabel:new(pad, hintY, 16, "Leave empty to use your Steam ID as password.",
        0.6, 0.6, 0.6, 1, UIFont.Small, true)
    hint:initialise()
    self:addChild(hint)

    -- Steam relay option
    local relayY = hintY + 26
    self.relayTick = ISTickBox:new(pad, relayY, 20, 20, "", nil, nil)
    self.relayTick:initialise()
    self.relayTick:addOption("Use Steam relay (enable if direct connect fails)")
    self:addChild(self.relayTick)

    -- Buttons
    local btnW, btnH = 110, 25
    local by = self.height - btnH - pad
    self.saveBtn = ISButton:new(self.width / 2 - btnW - 6, by, btnW, btnH, "Save", self, TheIntruderEditProfile.onClickSave)
    self.saveBtn:initialise()
    self:addChild(self.saveBtn)

    self.cancelBtn = ISButton:new(self.width / 2 + 6, by, btnW, btnH, "Cancel", self, TheIntruderEditProfile.onClickCancel)
    self.cancelBtn:initialise()
    self:addChild(self.cancelBtn)

    TheIntruderProfile.load()
    self.nameEntry:setText(TheIntruderProfile.name or "")
    self.passEntry:setText(TheIntruderProfile.password or "")
    self.relayTick:setSelected(1, TheIntruderProfile.useSteamRelay == true)
end

function TheIntruderEditProfile:onClickSave()
    TheIntruderProfile.name = self.nameEntry:getText()
    TheIntruderProfile.password = self.passEntry:getInternalText()
    TheIntruderProfile.useSteamRelay = self.relayTick:isSelected(1)
    TheIntruderProfile.save()
    self:close()
end

function TheIntruderEditProfile:onClickCancel()
    self:close()
end

function TheIntruderEditProfile:close()
    self:setVisible(false)
    self:removeFromUIManager()
    TheIntruderEditProfile.instance = nil
end

function TheIntruderEditProfile.open()
    if TheIntruderEditProfile.instance then
        TheIntruderEditProfile.instance:close()
    end

    local w, h = 460, 250
    local x = (getCore():getScreenWidth() - w) / 2
    local y = (getCore():getScreenHeight() - h) / 2

    local win = TheIntruderEditProfile:new(x, y, w, h)
    win.title = "Edit Profile"
    win:initialise()
    win:addToUIManager()
    win:setAlwaysOnTop(true)
    win:bringToTop()
    TheIntruderEditProfile.instance = win
end
