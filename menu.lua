local addon = ParseAcademy

local UNIT_MENU_TAGS = {
    { tag = "MENU_UNIT_SELF", fallbackUnit = "player" },
    { tag = "MENU_UNIT_TARGET", fallbackUnit = "target" },
    { tag = "MENU_UNIT_FOCUS", fallbackUnit = "focus" },
    { tag = "MENU_UNIT_PLAYER", fallbackUnit = "target" },
    { tag = "MENU_UNIT_PARTY1", fallbackUnit = "party1" },
    { tag = "MENU_UNIT_PARTY2", fallbackUnit = "party2" },
    { tag = "MENU_UNIT_PARTY3", fallbackUnit = "party3" },
    { tag = "MENU_UNIT_PARTY4", fallbackUnit = "party4" },
    { tag = "MENU_UNIT_RAID" },
    { tag = "MENU_UNIT_RAID_PLAYER" },
    { tag = "MENU_UNIT_FRIEND" },
}

local LEGACY_UNIT_POPUP_MENUS = {
    "SELF",
    "PLAYER",
    "TARGET",
    "FOCUS",
    "PARTY",
    "RAID",
}

local function GetContextUnit(contextData, fallbackUnit)
    if contextData and contextData.unit then
        return contextData.unit
    end

    return fallbackUnit
end

local function GetContextCharacter(contextData)
    if not contextData then
        return nil
    end

    local name = contextData.name or contextData.playerName
    local realm = contextData.server or contextData.realm or contextData.playerRealm

    if name and name ~= "" then
        return name, realm
    end

    return nil
end

local function AddParseOption(rootDescription, contextData, fallbackUnit)
    if not rootDescription then return end

    local unit = GetContextUnit(contextData, fallbackUnit)
    local name, realm = addon:GetUnitCharacter(unit)
    if not name then
        name, realm = GetContextCharacter(contextData)
    end
    if not name then return end

    rootDescription:CreateDivider()

    rootDescription:CreateButton("Copy Parse Academy Link", function()
        local url = addon:BuildURL(name, realm)
        if url then
            addon:ShowLink(url)
        else
            addon:Print("Unable to create a link for " .. name .. ".")
        end
    end)
end

if Menu and Menu.ModifyMenu then
    for _, menu in ipairs(UNIT_MENU_TAGS) do
        local menuTag = menu.tag
        local fallbackUnit = menu.fallbackUnit

        Menu.ModifyMenu(menuTag, function(ownerRegion, rootDescription, contextData)
            AddParseOption(rootDescription, contextData, fallbackUnit)
        end)
    end
elseif UnitPopupButtons and UnitPopupMenus and UIDropDownMenu_AddButton then
    UnitPopupButtons.PARSEACADEMY = {
        text = "Copy Parse Academy Link",
        dist = 0,
    }

    for _, menuName in ipairs(LEGACY_UNIT_POPUP_MENUS) do
        local menu = UnitPopupMenus[menuName]
        if menu then
            local alreadyAdded
            for _, buttonName in ipairs(menu) do
                if buttonName == "PARSEACADEMY" then
                    alreadyAdded = true
                    break
                end
            end

            if not alreadyAdded then
                table.insert(menu, "PARSEACADEMY")
            end
        end
    end

    hooksecurefunc("UnitPopup_OnClick", function(self)
        if self.value ~= "PARSEACADEMY" then return end

        local dropdown = UIDROPDOWNMENU_INIT_MENU
        addon:ShowUnitLink(dropdown and dropdown.unit)
    end)
end
