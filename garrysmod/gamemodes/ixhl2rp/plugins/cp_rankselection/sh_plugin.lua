local PLUGIN = PLUGIN

PLUGIN.name = "CP Rank Selection"
PLUGIN.author = "The Apex Typhon"
PLUGIN.schema = "HL2:RP"
PLUGIN.description = "Adds a custom derma-UI and custom system for selecting division and rank as CP."

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

function GetDivision(player, string, any)
    local char = Player:GetCharacter()
    local divval = divisionSelection:GetOptionText()
    local divind = divisionSelection:GetSelectedID()
    local division = string

    if(divval == "UNION" and divind == 1) then
        division = "union"
    elseif(divval == "GRID" and divind == 2) then
        division = "grid"
    elseif(divval == "JURY" and divind == 3) then
        division = "jury"
    elseif(divval == "KING" and divind == 5) then
        division = "king"
    elseif(divval == "VICE" and divind == 6) then
        division = "vice"
    else
        division = "invalid"
    end
end
function GetRank(player, string, any)
    local char = Player:GetCharacter()
    local rankval = rankSelection:GetOptionText()
    local rankind = rankSelection:GetSelectedID()
    local cprank = ""

    if(rankval == "i4" and rankind == 1) then
        cprank = "i4"
    elseif(rankval == "i3" and rankind == 2) then
        cprank = "i3"
    elseif(rankval == "i2" and rankind == 3) then
        cprank = "i2"
    elseif(rankval == "i1" and rankind == 4) then
        cprank = "i1"
    elseif(rankval == "OfC" and rankind == 6) then
        cprank = "ofc"
    elseif(rankval == "SqL" and rankind == 8) then
        cprank = "sql"
    elseif(rankval == "DvL" and rankind == 9) then
        cprank = "dvl"
    end

end

function setRank(player, string, index, value, data, any)
    local char = Player:GetCharacter()
    local cpr = GetRank():cprank
    local div = GetDivision():division
  
    char:SetName("CP-C17-".. cpr .."-" .. div .. "-" .. Schema:ZeroNumber(math.random(999, 9999), 4))

end

if CLIENT
    netstream.Hook("ixCPRankUse", function(data)
        local base = vgui.Create("DFrame")
        base:SetSize(500, 450)
        base:SetTitle("CP Rank Officer")
        base:Center()
        base:SetVisible(true)
        base:ShowCloseButton(true)
        base:MakePopup()
        base:Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, Color(18, 16, 14))
            draw.RoundedBox(5, 2, 2, w-4, h-4, Color(46, 40, 35))
        end

        local divisionSelection = vgui.Create("DComboBox", base)
        divisionSelection.SetSize(100, 50)
        divisionSelection:SetPos( 15, 30 )
        divisionSelection:SetValue("Select Division")
        divisionSelection:AddChoice("UNION")
        divisionSelection:AddChoice("GRID")
        divisionSelection:AddChoice("JURY")
        divisionSelection:AddSpacer()
        divisionSelection:AddChoice("KING")
        divisionSelection:AddChoice("VICE")
        divisionSelection:GetSortItems(false)
        divisionSelection:OnSelect(index, value, data)
            print(value .." was selected at index ".. index)
            GetDivision()
        end

        local rankSelection = vgui.Create("DComboBox", base)
        rankSelection.SetSize(100, 50)
        rankSelection:SetPos( 65, 30 )
        rankSelection:SetValue("Select Rank")
        rankSelection:AddChoice("i4")
        rankSelection:AddChoice("i3")
        rankSelection:AddChoice("i2")
        rankSelection:AddChoice("i1")
        rankSelection:AddSpacer()
        rankSelection:AddChoice("OfC")
        rankSelection:AddSpacer()
        rankSelection:AddChoice("SqL")
        rankSelection:AddChoice("DvL")
        rankSelection:GetSortItems(false)
        rankSelection:OnSelect(index, text, data)
            print(value .." was selected at index ".. index)
            GetRank()
        end

        local finishButton = vgui.Create( "DButton", base )
        finishButton:SetText("Finish")
        finishButton:SetSize( 250, 30 )	
        finishButton.DoClick(player, string, any)
            if(GetDivision():division != nil and GetRank():cprank != nil)
                setRank()
            else
                return
            end
        end
    end)

    function PLUGIN:PopulateEntityInfo(ent, tooltip)
        if ent:GetClass() == "ix_cprankvendor" then
            local pop = tooltip:AddRow("name")
            pop:SetText("CP Rank Vendor")
            pop:SetBackgroundColor(Color(255,165,0))
            pop:SetImportant()
            pop:SizeToContents()

            local desc = tooltip:AddRowAfter("name", "desc")
            desc:SetText("This Civil Protection Unit will provide you your rank.")
            desc:SetBackgroundColor(Color(255,140,0))
            desc:SizeToContents()
        end
    end
end
