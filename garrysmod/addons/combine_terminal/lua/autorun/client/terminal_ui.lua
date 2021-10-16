if IsValid(Terminal.Frame) then Terminal.Frame:Remove() end

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

local function niceButton(parrent, text, func, font)
	local btn = vgui.Create("DButton", parrent)
	btn:SetFont(font or "Trebuchet24")
	btn:SetText(text)
	btn.DoClick = function(self)
		func(self)
	end

	btn.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, s.Col or PanelCol)
	end

	return btn
end

local function niceScroll(prnt)
	local scr = vgui.Create("DScrollPanel", prnt)
	scr:GetCanvas():DockPadding(0, 0, 5, 0)

	local sbar = scr:GetVBar()

	function sbar:Paint( w, h )
		surface.SetDrawColor(color_white)
		draw.RoundedBox( 0, 0, 0, w, h, PanelCol )
	end
	function sbar.btnUp:Paint( w, h )
		surface.SetDrawColor(color_white)

		surface.DrawLine(w/3, h-w/3, w/2, w/3)
		surface.DrawLine(w-w/3, h-w/3, w/2, w/3)

		draw.RoundedBox( 0, 0, 0, w, h, PanelCol )
	end
	function sbar.btnDown:Paint( w, h )
		surface.SetDrawColor(color_white)

		surface.DrawLine(w/3, w/3, w/2, h-w/3)
		surface.DrawLine(w-w/3, w/3, w/2, h-w/3)

		draw.RoundedBox( 0, 0, 0, w, h, PanelCol )
	end
	function sbar.btnGrip:Paint( w, h )
		surface.SetDrawColor(color_white)

		draw.RoundedBox( 0, 0, 0, w, h, PanelCol )
	end

	return scr
end

local function OpenTerminal()
	local scrw, scrh = ScrW(), ScrH()

	local frm = vgui.Create("DFrame")
	Terminal.Frame = frm

	frm:SetSize(scrw/4, scrh/2)
	frm:Center()
	frm:MakePopup()
	frm:DockPadding(10, 10, 10, 10)

	frm:ShowCloseButton(false)
	frm:SetTitle("")
	frm:SetScreenLock(true)

	frm.Paint = function(s, w, h)
		drawblur( s, 15, 20, 255 )
		draw.RoundedBox(0, 0, 0, w, h, TerminalBackground)
	end

	local mainArea = vgui.Create("DPanel", frm)
	mainArea:Dock(LEFT)
	mainArea:SetWide(frm:GetWide()/1.5 - 25)
	mainArea.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, PanelCol) end
	mainArea:DockPadding(5, 5, 5, 5)

	local mainScr = niceScroll(mainArea)
	mainScr:Dock(FILL)
	
	local buttons = vgui.Create("DPanel", frm)
	buttons:Dock(RIGHT)
	buttons:SetWide(frm:GetWide() - frm:GetWide()/1.5 - 5)
	buttons.Paint = nil

	local buttonsScr = niceScroll(buttons)
	buttonsScr:Dock(FILL)

	local popupMenu
	local currentSelected = ""
	local function clear(self)
		if IsValid(popupMenu) then popupMenu:Remove() end

		currentSelected = self:GetText()

		mainScr:Clear()
		if IsValid(mainArea.ToRemove) then mainArea.ToRemove:Remove() end
	end
	local function changeColor(self)
		if currentSelected == self:GetText() then
			self.SetCol = false
			self:SetColor(color_white)
		else
			if not self.SetCol then
				self:SetColor(nil)
				self.SetCol = true
			end
		end
	end

	local dispatch = niceButton(buttonsScr, "Dispatch", function(self)
		clear(self)

		for name, path in pairs(Terminal.DispatchSounds) do
			if path == "" then
				local stopSound = niceButton(mainArea, "Stop dispatch", function()
					net.Start("terminal_Dispatch")
						net.WriteString(name)
					net.SendToServer()
				end, "Trebuchet18")
				stopSound:Dock(TOP)
				stopSound:SetTall(30)
				stopSound:DockMargin(0, 0, 0, 5)

				mainArea.ToRemove = stopSound

				continue
			end

			local snd = niceButton(mainScr, name, function()
				net.Start("terminal_Dispatch")
					net.WriteString(name)
				net.SendToServer()
			end, "Trebuchet18")
			snd:Dock(TOP)
			snd:SetTall(40)
			snd:DockMargin(0, 0, 0, 5)
		end
	end)
	dispatch:Dock(TOP)
	dispatch:SetTall(40)
	dispatch:DockMargin(0, 0, 0, 10)
	dispatch.Think = changeColor
	--------------------------------------------------------------

	local function listCitizens(parrent, funcOnClick)
		local srch = vgui.Create("DTextEntry", mainArea)
		mainArea.ToRemove = srch

		srch:Dock(TOP)
		srch:SetTall(30)
		srch:DockMargin(0, 0, 0, 5)

		srch:SetPlaceholderText("Search by name")
		srch:SetPlaceholderColor(Color(80,80,80))

		srch:SetFont("Trebuchet18")
		srch:SetTextColor( color_white )
		srch:SetDrawBorder( false )
		srch:SetDrawBackground( false )
		srch:SetCursorColor( color_white )
		srch:SetHighlightColor( Color(52, 152, 219) )
		srch.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
			derma.SkinHook( "Paint", "TextEntry", self, w, h )
		end

		local panels = {}
		for i, ply in ipairs(player.GetAll()) do
			if Terminal.Citizens[ply:Team()] then
				local btn = niceButton(parrent, ply:Nick() .. " | " .. ply:getDarkRPVar("job"), funcOnClick, "Trebuchet18")
				btn:Dock(TOP)
				btn:SetTall(40)
				btn:DockMargin(0, 0, 0, 5)

				btn.player = ply

				local avatar = vgui.Create("AvatarImage", btn)
				avatar:Dock(LEFT)
				avatar:SetWide(40)
				avatar:SetPlayer(ply, 64)
				avatar:SetMouseInputEnabled(false)

				panels[#panels + 1] = btn
			end
		end

		srch.OnChange = function(s)
			local txt = s:GetText():lower()
			local show = txt == ""

			for i, pnl in ipairs(panels) do
				if not IsValid(pnl) then table.remove(panels, i) continue end
				if not IsValid(pnl.player) then pnl:Remove() table.remove(panels, i) continue end

				if show then
					pnl:Show()
					pnl:DockMargin(0, 0, 0, 5)
				else
					if pnl.player:Nick():lower():find(txt) then
						pnl:Show()
						pnl:DockMargin(0, 0, 0, 5)
					else
						pnl:Hide()
						pnl:DockMargin(0, 0, 0, 0)
					end
				end
			end
		end
	end

	local bol = niceButton(buttonsScr, "BoL", function(self)
		clear(self)

		listCitizens(mainScr, function(btn)
			if IsValid(popupMenu) then popupMenu:Remove() end

			local bolReason = vgui.Create("DFrame", frm)
			popupMenu = bolReason

			bolReason:SetTitle("Enter a reason")

			bolReason:SetSize(300,75)
			bolReason:Center()
			bolReason:SetDraggable(false)

			bolReason.Paint = function(s, w, h)
				drawblur( s, 15, 20, 255 )
				draw.RoundedBox(0, 0, 0, w, h, TerminalBackground)
			end

			local rsn = vgui.Create("DTextEntry", bolReason)

			rsn:Dock(FILL)

			rsn:SetPlaceholderText("Enter a reason and then press Enter")
			rsn:SetPlaceholderColor(Color(80,80,80))

			rsn:SetFont("Trebuchet18")
			rsn:SetTextColor( color_white )
			rsn:SetDrawBorder( false )
			rsn:SetDrawBackground( false )
			rsn:SetCursorColor( color_white )
			rsn:SetHighlightColor( Color(52, 152, 219) )
			rsn.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
				derma.SkinHook( "Paint", "TextEntry", self, w, h )
			end

			rsn.OnEnter = function()
				if not IsValid(btn.player) then
					notification.AddLegacy("Player has disconnected!", NOTIFY_ERROR, 15)
					
					bolReason:Close()

					return
				end

				local txt = rsn:GetText():Trim()
				if txt == "" or #txt < 3 then
					bolReason:SetTitle("Enter valid reason!")
					bolReason.lblTitle:SetColor(Color(255,0,0))

					return
				end

				net.Start("terminal_BoL")
					net.WriteString(txt)
					net.WriteEntity(btn.player)
				net.SendToServer()

				notification.AddLegacy("BoL '" .. txt .. "' was set on " .. btn.player:Nick(), NOTIFY_GENERIC, 5)

				bolReason:Close()
			end
		end)
	end)
	bol:Dock(TOP)
	bol:SetTall(40)
	bol:DockMargin(0, 0, 0, 10)
	bol.Think = changeColor

	bol:SetTooltip("Be on the Lookout")
	--------------------------------------------------------------

	local cits = niceButton(buttonsScr, "Citizen Index", function(self)
		clear(self)

		listCitizens(mainScr, function()end)
	end)
	cits:Dock(TOP)
	cits:SetTall(40)
	cits:DockMargin(0, 0, 0, 10)
	cits.Think = changeColor
	--------------------------------------------------------------

	local citycont = niceButton(buttonsScr, "City control", function(self)
		clear(self)

		for name, _ in pairs(Terminal.MapButtons) do
			local btn = niceButton(mainScr, name, function()
				net.Start("terminal_ControlMap")
					net.WriteString(name)
				net.SendToServer()
			end, "Trebuchet18")
			btn:Dock(TOP)
			btn:SetTall(40)
			btn:DockMargin(0, 0, 0, 5)
		end
	end)
	citycont:Dock(TOP)
	citycont:SetTall(40)
	citycont:DockMargin(0, 0, 0, 10)
	citycont.Think = changeColor
	--------------------------------------------------------------

	local cls = niceButton(buttons, "Close", function(self)
		frm:Remove()
	end)
	cls:Dock(BOTTOM)
	cls:SetTall(40)
end
OpenTerminal()

net.Receive("terminal_Open", OpenTerminal)

net.Receive("terminal_Dispatch", function()
	local soundKey = net.ReadString()

	local snd = Terminal.DispatchSounds[soundKey]
	if snd == "" then
		if IsValid(Terminal.DispatchStation) then
			Terminal.DispatchStation:Stop()
		end

		return
	end

	sound.PlayFile(snd, "3d", function(station, errCode, errStr)
		if IsValid(station) then
			Terminal.DispatchStation = station

			station:SetPos(Terminal.Dispatch.Position)
			station:Play()
			station:SetVolume(Terminal.Dispatch.Volume)
		else
			print("Error playing sound!", errCode, errStr)
		end
	end)
end)