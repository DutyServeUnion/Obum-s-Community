local PLUGIN = PLUGIN

PLUGIN.name = "CP Rank Selection"
PLUGIN.author = "The Apex Typhon"
PLUGIN.schema = "HL2:RP"
PLUGIN.description = "Adds a custom derma-UI and custom system for selecting division and rank as CP."

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

local cpmodel = "models/dpfilms/metropolice/hdpolice.mdl"

local cprank = ""
local division = ""

if CLIENT then
    netstream.Hook("ixCPRankUse", function(data)

        local base = vgui.Create("DFrame")
        base:SetSize(500, 450)
        base:SetTitle("CP Rank Officer")
        base:Center()
        base:SetVisible(true)
        base:ShowCloseButton(true)
        base:MakePopup()
        function base:Paint(w,h)
            draw.RoundedBox(5, 0, 0, 500, 450, Color(18, 16, 14))
            draw.RoundedBox(5, 2, 2, 500-4, 450-4, Color(46, 40, 35))
        end

        local divisionSelection = vgui.Create("DComboBox", base)
        divisionSelection:SetPos( 15, 30 )
        divisionSelection:SetSize( 100, 50)
        divisionSelection:GetSortItems(false)
        divisionSelection:SetValue("Select Division")
        divisionSelection:AddChoice("UNION")
        divisionSelection:AddChoice("GRID")
        divisionSelection:AddChoice("JURY")
        divisionSelection:AddChoice("KING")
        divisionSelection:AddChoice("VICE")   
        function divisionSelection:OnSelect(index, text, data)
            print(text .." was selected at index ".. index)
            function GetDivision(player, string, any, index, text)
                if(text == "UNION" and index == 1) then
                    division = "union"
                    cpmodel = "models/dpfilms/metropolice/hdpolice.mdl"
                elseif(text == "GRID" and index == 2) then
                    division = "grid"
                    cpmodel = "models/dpfilms/metropolice/hl2concept.mdl"
                elseif(text == "JURY" and index == 3) then
                    division = "jury"
                    cpmodel = "models/dpfilms/metropolice/policetrench.mdl"
                elseif(text == "KING" and index == 5) then
                    division = "king"
                    cpmodel = "models/dpfilms/metropolice/elite_police.mdl"
                elseif(text == "VICE" and index == 6) then
                    division = "vice"
                else
                    division = "invalid"
                end
                net.Start("CPDivision")
                net.Send(division)
            end
        end

        local rankSelection = vgui.Create("DComboBox", base)
        rankSelection:SetPos( 165, 30 )
        rankSelection:SetSize( 100, 50)
        rankSelection:GetSortItems(false)
        rankSelection:SetValue("Select Rank")
        rankSelection:AddChoice("i4")
        rankSelection:AddChoice("i3")
        rankSelection:AddChoice("i2")
        rankSelection:AddChoice("i1")
        rankSelection:AddChoice("OfC")
        rankSelection:AddChoice("SqL")
        rankSelection:AddChoice("DvL")
        function rankSelection:OnSelect(index, text, data)
            print(text .." was selected at index ".. index)
            function GetRank(player, string, index, text)
                if(text == "i4" and index == 1) then
                    cprank = "i4"
                elseif(text == "i3" and index == 2) then
                    cprank = "i3"
                elseif(text == "i2" and index == 3) then
                    cprank = "i2"
                elseif(text == "i1" and index == 4) then
                    cprank = "i1"
                elseif(text == "OfC" and index == 6) then
                    cprank = "ofc"
                elseif(text == "SqL" and index == 8) then
                    cprank = "sql"
                elseif(text == "DvL" and index == 9) then
                    cprank = "dvl"
                else
                    cprank = "invalid"
                end
            end
        end
        local finishButton = vgui.Create( "DButton", base )
        finishButton:SetText("Finish")
        finishButton:SetSize( 250, 30 )	
        finishButton:SetPos( 125, 400 )
        function finishButton.DoClick(text, index)
            function setRank(client, string, index, text, data, any)
                local character = client:GetCharacter()
                character:SetName("CP-C17-".. cpr .."-" .. div .. "-" .. Schema:ZeroNumber(math.random(999, 9999), 4))
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
