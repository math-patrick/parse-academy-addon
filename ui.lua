local addon = ParseAcademy

function addon:CreateUI()
    local frame = CreateFrame("Frame", "ParseAcademyLinkFrame", UIParent, "BackdropTemplate")
    frame:SetSize(460, 132)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetScript("OnHide", function(self)
        self.editBox:ClearFocus()
    end)
    table.insert(UISpecialFrames, frame:GetName())

    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:Hide()

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 18, -16)
    title:SetText("ParseAcademy Link")

    local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    hint:SetText("Press Ctrl+C to copy, then Escape to close.")

    local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    editBox:SetSize(400, 30)
    editBox:SetPoint("BOTTOM", 0, 22)
    editBox:SetAutoFocus(true)
    editBox:SetMaxLetters(512)
    editBox:SetScript("OnEscapePressed", function(self)
        self:GetParent():Hide()
    end)
    editBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    close:SetScript("OnClick", function()
        frame:Hide()
    end)

    frame.editBox = editBox

    self.frame = frame
end

function addon:ShowLink(url)
    url = tostring(url or "")

    if url == "" then
        self:Print("Unable to create a link.")
        return
    end

    if not self.frame then
        self:CreateUI()
    end

    self.frame:Show()
    self.frame.editBox:SetText(url)
    self.frame.editBox:SetFocus()
    self.frame.editBox:HighlightText()
end
