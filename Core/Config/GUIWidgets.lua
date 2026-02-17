local _, UUF = ...
local AG = UUF.AG
UUF.GUIWidgets = {}

local function DeepDisable(widget, disabled, skipWidget)
    if widget == skipWidget then return end
    if widget.SetDisabled then widget:SetDisabled(disabled) end
    if widget.children then
        for _, child in ipairs(widget.children) do
            DeepDisable(child, disabled, skipWidget)
        end
    end
end

UUF.GUIWidgets.DeepDisable = DeepDisable

local function CreateInformationTag(containerParent, labelDescription, textJustification)
    local informationLabel = AG:Create("Label")
    informationLabel:SetText(UUF.INFOBUTTON .. labelDescription)
    informationLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    informationLabel:SetFullWidth(true)
    informationLabel:SetJustifyH(textJustification or "CENTER")
    informationLabel:SetHeight(24)
    informationLabel:SetJustifyV("MIDDLE")
    containerParent:AddChild(informationLabel)
    return informationLabel
end

UUF.GUIWidgets.CreateInformationTag = CreateInformationTag

local function CreateScrollFrame(containerParent)
    local scrollFrame = AG:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    scrollFrame:SetFullWidth(true)
    containerParent:AddChild(scrollFrame)
    return scrollFrame
end

UUF.GUIWidgets.CreateScrollFrame = CreateScrollFrame

local function CreateInlineGroup(containerParent, containerTitle)
    local inlineGroup = AG:Create("InlineGroup")
    inlineGroup:SetTitle("|cFFFFFFFF" .. containerTitle .. "|r")
    inlineGroup:SetFullWidth(true)
    inlineGroup:SetLayout("Flow")
    containerParent:AddChild(inlineGroup)
    return inlineGroup
end

UUF.GUIWidgets.CreateInlineGroup = CreateInlineGroup

local function CreateHeader(containerParent, headerTitle)
    local headingText = AG:Create("Heading")
    headingText:SetText("|cFFFFCC00" .. headerTitle .. "|r")
    headingText:SetFullWidth(true)
    containerParent:AddChild(headingText)
    return headingText
end

UUF.GUIWidgets.CreateHeader = CreateHeader

local function CreateAbsorbGroupSettings(containerParent, label, db, maxHeight, onValueChanged)
    local Container = CreateInlineGroup(containerParent, label .. " Settings")

    local ShowToggle = AG:Create("CheckBox")
    ShowToggle:SetLabel("Show " .. label .. "s")
    ShowToggle:SetValue(db.Enabled)
    ShowToggle:SetRelativeWidth(0.33)
    Container:AddChild(ShowToggle)

    local StripedTextureToggle = AG:Create("CheckBox")
    StripedTextureToggle:SetLabel("Use Striped Texture")
    StripedTextureToggle:SetValue(db.UseStripedTexture)
    StripedTextureToggle:SetRelativeWidth(0.33)
    Container:AddChild(StripedTextureToggle)

    local MatchParentHeightToggle = AG:Create("CheckBox")
    MatchParentHeightToggle:SetLabel("Match Parent Height")
    MatchParentHeightToggle:SetValue(db.MatchParentHeight)
    MatchParentHeightToggle:SetRelativeWidth(0.33)
    Container:AddChild(MatchParentHeightToggle)

    local ColourPicker = AG:Create("ColorPicker")
    ColourPicker:SetLabel(label .. " Colour")
    ColourPicker:SetColor(unpack(db.Colour))
    ColourPicker:SetHasAlpha(true)
    ColourPicker:SetRelativeWidth(0.33)
    Container:AddChild(ColourPicker)

    local HeightSlider = AG:Create("Slider")
    HeightSlider:SetLabel("Height")
    HeightSlider:SetValue(db.Height)
    HeightSlider:SetSliderValues(1, maxHeight, 0.1)
    HeightSlider:SetRelativeWidth(0.33)
    HeightSlider:SetDisabled(db.MatchParentHeight or db.Position == "ATTACH")
    Container:AddChild(HeightSlider)

    local PositionDropdown = AG:Create("Dropdown")
    PositionDropdown:SetList({["LEFT"] = "Left", ["RIGHT"] = "Right", ["ATTACH"] = "Attach To Missing Health"}, {"LEFT", "RIGHT", "ATTACH"})
    PositionDropdown:SetLabel("Position")
    PositionDropdown:SetValue(db.Position)
    PositionDropdown:SetRelativeWidth(0.33)
    Container:AddChild(PositionDropdown)

    local function refresh()
        DeepDisable(Container, not db.Enabled, ShowToggle)
        HeightSlider:SetDisabled(db.MatchParentHeight or db.Position == "ATTACH")
    end

    ShowToggle:SetCallback("OnValueChanged", function(_, _, value) db.Enabled = value onValueChanged("Enabled", value) refresh() end)
    StripedTextureToggle:SetCallback("OnValueChanged", function(_, _, value) db.UseStripedTexture = value onValueChanged("UseStripedTexture", value) end)
    MatchParentHeightToggle:SetCallback("OnValueChanged", function(_, _, value) db.MatchParentHeight = value onValueChanged("MatchParentHeight", value) refresh() end)
    ColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) db.Colour = {r, g, b, a} onValueChanged("Colour", {r, g, b, a}) end)
    HeightSlider:SetCallback("OnValueChanged", function(_, _, value) db.Height = value onValueChanged("Height", value) end)
    PositionDropdown:SetCallback("OnValueChanged", function(_, _, value) db.Position = value onValueChanged("Position", value) refresh() end)

    refresh()

    return { container = Container, showToggle = ShowToggle, heightSlider = HeightSlider, refresh = refresh }
end

UUF.GUIWidgets.CreateAbsorbGroupSettings = CreateAbsorbGroupSettings

local function CreateHealPredictionGroupSettings(containerParent, db, maxHeight, onValueChanged)
    CreateAbsorbGroupSettings(containerParent, "Absorb", db.Absorbs, maxHeight,
        function(key, value) onValueChanged("Absorbs", key, value) end)
    CreateAbsorbGroupSettings(containerParent, "Heal Absorb", db.HealAbsorbs, maxHeight,
        function(key, value) onValueChanged("HealAbsorbs", key, value) end)
end

UUF.GUIWidgets.CreateHealPredictionGroupSettings = CreateHealPredictionGroupSettings