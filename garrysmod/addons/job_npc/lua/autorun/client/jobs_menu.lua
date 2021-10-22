local TerminalBackground = Color(50, 53, 60, 220)
local PanelCol = Color(0, 0, 0, 150)

local blur = Material( "pp/blurscreen" )
local function drawblur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

net.Receive("OpenJobsMenu", function()
	local npc = net.ReadEntity()

	if IsValid(JobMenu) then JobMenu:Remove() return end

	local scrw, scrh = ScrW(), ScrH()

	local frm = vgui.Create("DFrame")
	JobMenu = frm
	frm:SetSize(scrw/3, scrh/2)
	frm:Center()
	frm:MakePopup()
	frm:DockPadding(10, 25, 10, 10)

	frm:ShowCloseButton(true)
	frm:SetTitle("")
	frm:SetScreenLock(true)

	frm.Paint = function(s, w, h)
		drawblur( s, 15, 20, 255 )
		draw.RoundedBox(0, 0, 0, w, h, TerminalBackground)
	end

	local top = vgui.Create("DPanel", frm)
	top:Dock(TOP)
	top:SetTall(30)
	top.Paint = nil

	local category = vgui.Create("DComboBox", top)
	category:Dock(LEFT)
	category:SetValue(npc.CategoryUIReplace or "Category")
	category:SetWide(frm:GetWide()/3)
	category:DockMargin(0, 0, 30, 0)

	for cat --[[Not a kitten!]], _ in pairs(npc.Categories) do
		category:AddChoice(cat)
	end

	local class = vgui.Create("DComboBox", top)
	class:Dock(LEFT)
	class:SetValue("Class")
	class:SetWide(frm:GetWide()/3)

	category.OnSelect = function(s, i, val)
		class:Clear()
		for k, tm in pairs(RPExtraTeams) do
			if tm.category == val then
				class:AddChoice(tm.name, k)
			end
		end
	end

	local mainCanvas = vgui.Create("DPanel", frm)
	mainCanvas:Dock(FILL)
	mainCanvas:SetTall(30)
	mainCanvas.Paint = nil
	mainCanvas:DockPadding(0, 20, 0, 0)

	local descPanel = vgui.Create("DPanel", mainCanvas)
	descPanel:Dock(LEFT)
	descPanel:SetWide(frm:GetWide()/1.75)
	descPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, PanelCol)
	end

	local desc = vgui.Create("RichText", descPanel)
	desc:Dock(FILL)
	desc:SetText("")
	function desc:PerformLayout()
		self:SetFontInternal( "Trebuchet24" )
	end

	local mdlPanel = vgui.Create("DPanel", mainCanvas)
	mdlPanel:Dock(FILL)
	mdlPanel.Paint = nil

	local mdl = vgui.Create("DModelPanel", mdlPanel)
	mdl:Dock(FILL)
	mdl:SetModel(LocalPlayer():GetModel())
	mdl:SetFOV(40)

	local selectedClass

	local sel = vgui.Create("DButton", mdlPanel)
	sel:Dock(BOTTOM)
	sel:SetText("Select")
	sel:SetFont("Trebuchet24")
	sel.DoClick = function(self)
		if not selectedClass then return end

		net.Start("darkrpChangeTeam")
			net.WriteUInt(selectedClass.team, 16)
		net.SendToServer()
	end

	sel.Paint = function(s, w, h)
		local a = PanelCol.a
		a = not selectedClass and a - 50 or a
		
		if s:IsHovered() then
			a = a + 25
		end

		draw.RoundedBox(0, 0, 0, w, h, Color(PanelCol.r, PanelCol.g, PanelCol.b, a))
	end

	class.OnSelect = function(s, i, val, data)
		local tm = RPExtraTeams[data]
		selectedClass = tm
		sel:SetColor(color_white)

		mdl:SetModel(istable(tm.model) and table.Random(tm.model) or tm.model)
		desc:SetText(tm.description)
	end
end)