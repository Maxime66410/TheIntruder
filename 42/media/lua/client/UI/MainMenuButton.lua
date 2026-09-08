--[[
    The Intruder - main menu entry
    Adds an entry right of Multiplayer that opens the server list window.
]]

local original_instantiate = MainScreen.instantiate
function MainScreen:instantiate()
    original_instantiate(self)
    self:addIntruderMenuOption()
end

function MainScreen:addIntruderMenuOption()
    local mp = self.onlineOption
    if not mp then return end
    if self.intruderOption then return end

    self.intruderOption = ISLabel:new(mp:getX(), mp:getY(), mp:getHeight(),
        "The Intruder", 1, 1, 1, 1, UIFont.Large, true)
    self.intruderOption.Type = "ISLabel_IntruderEntry"
    self.intruderOption.internal = "INTRUDER"
    self.intruderOption:initialise()
    self.intruderOption.onMouseDown = MainScreen.onMenuItemMouseDownMainMenu
    self.bottomPanel:addChild(self.intruderOption)
    self.intruderOption:setVisible(mp:isVisible())

    self.intruderOption.fade = UITransition.new()
    self.intruderOption.fade:setFadeIn(false)
    self.intruderOption.prerender = MainScreen.prerenderBottomPanelLabel
end

local original_render = MainScreen.render
function MainScreen:render()
    original_render(self)
    local intr = self.intruderOption
    local mp = self.onlineOption
    if intr and mp then
        local gap = 24
        local nameWidth = getTextManager():MeasureStringX(UIFont.Large, mp.name or "")
        intr:setX(mp:getX() + nameWidth + gap)
        intr:setY(mp:getY())
        intr:setVisible(mp:isVisible())
    end
end

local original_dispatch = MainScreen.onMenuItemMouseDownMainMenu
MainScreen.onMenuItemMouseDownMainMenu = function(item, x, y)
    if item.internal == "INTRUDER" then
        getSoundManager():playUISound("UIActivateMainMenuItem")
        TheIntruderWindow.open()
        return
    end
    original_dispatch(item, x, y)
end
