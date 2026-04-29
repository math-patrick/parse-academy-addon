local addon = ParseAcademy

local function AddParseOption(owner, rootDescription, contextData)
    if not rootDescription or not contextData or not contextData.unit then return end

    local unit = contextData.unit
    local name, realm = addon:GetUnitCharacter(unit)
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
    for _, menuTag in ipairs({
        "MENU_UNIT_PLAYER",
        "MENU_UNIT_FRIEND",
        "MENU_UNIT_PARTY",
        "MENU_UNIT_RAID",
    }) do
        Menu.ModifyMenu(menuTag, AddParseOption)
    end
end
