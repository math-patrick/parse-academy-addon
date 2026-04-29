local ADDON_NAME = ...

ParseAcademy = ParseAcademy or {}
ParseAcademy.name = ADDON_NAME or "ParseAcademy"

local REGION_MAP = {
    [1] = "us",
    [2] = "kr",
    [3] = "eu",
    [4] = "tw",
    [5] = "cn",
}

local function URLEncode(str)
    str = tostring(str or "")

    return str:gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

local function Trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

function ParseAcademy:GetRegion()
    local regionID = GetCurrentRegion and GetCurrentRegion()
    return REGION_MAP[regionID] or "us"
end

function ParseAcademy:NormalizeRealm(realm)
    realm = Trim(realm)

    if realm == "" and GetNormalizedRealmName then
        realm = GetNormalizedRealmName()
    end

    return Trim(realm):gsub("%s+", "")
end

function ParseAcademy:NormalizeCharacterName(name)
    name = Trim(name)

    if name == "" then
        return nil
    end

    return name:match("^([^-]+)") or name
end

function ParseAcademy:BuildURL(name, realm)
    name = self:NormalizeCharacterName(name)

    if not name then
        return nil
    end

    local region = self:GetRegion()
    realm = self:NormalizeRealm(realm)

    if realm == "" then
        return nil
    end

    name = URLEncode(name)
    realm = URLEncode(realm)

    return "https://parseacademy.com/character/" .. region .. "/" .. realm .. "/" .. name
end

function ParseAcademy:GetUnitCharacter(unit)
    if not unit or not UnitExists(unit) or not UnitIsPlayer(unit) then
        return nil
    end

    if UnitFullName then
        local name, realm = UnitFullName(unit)
        if name and name ~= "" then
            return name, realm
        end
    end

    return UnitName(unit)
end

function ParseAcademy:ShowUnitLink(unit)
    local name, realm = self:GetUnitCharacter(unit)
    local url = self:BuildURL(name, realm)

    if not url then
        self:Print("Unable to create a ParseAcademy link for that character.")
        return
    end

    self:ShowLink(url)
end

function ParseAcademy:Print(message)
    print("|cff33ff99ParseAcademy:|r " .. tostring(message or ""))
end

SLASH_PARSEACADEMY1 = "/parseacademy"
SLASH_PARSEACADEMY2 = "/pa"
SlashCmdList.PARSEACADEMY = function(input)
    input = Trim(input):lower()

    if input == "player" or input == "me" then
        ParseAcademy:ShowUnitLink("player")
    elseif input == "focus" then
        ParseAcademy:ShowUnitLink("focus")
    else
        ParseAcademy:ShowUnitLink("target")
    end
end
