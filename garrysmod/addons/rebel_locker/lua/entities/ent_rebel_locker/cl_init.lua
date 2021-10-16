local drawDist = 150^2 -- at which distance draw locker's tip when looking at it? Note: must be squared (^2)
local ShowDescriptionTime = 1 -- in seconds
local description = "Change your outfit"

















local ScrW = ScrW
local ScrH = ScrH
local IsValid = IsValid
local FrameTime = FrameTime
local RealTime = RealTime
local Lerp = Lerp
local draw = draw

include('shared.lua')

function ENT:Initialize()
	self.RebelJob = _G[self.RebelJob]
	self.CitizenJob = _G[self.CitizenJob]
end

function ENT:Draw()
	self:DrawModel()
end

if IsValid(ClothingMenu) then ClothingMenu:Remove() end
local function openClothng()
	local frm = vgui.Create("DFrame")
	ClothingMenu = frm

	frm:SetSize(300,500)
	frm:Center()
	frm:MakePopup()
	frm:SetTitle("Locker")
	frm.btnClose.Paint = function(self, w, h)
		draw.SimpleText("X","DermaDefault",w/2,h/2,color_white,1,1)
	end
	frm.OnClose = function()end 
	frm.btnMaxim:Hide()
	frm.btnMinim:Hide()
	frm:DockPadding(20, 40, 20, 20)

	frm.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20,20,20,250))
		draw.RoundedBox(0, 0, 0, w, 25, Color(50,50,50,250))
	end

	local mdlConvas = vgui.Create("DPanel", frm)
	mdlConvas:Dock(FILL)
	mdlConvas.Paint = nil

	local mdl = vgui.Create("DModelPanel", mdlConvas)
	mdl:Dock(FILL)
	local mdlId = 1
	mdl:SetModel(LocalPlayer():GetModel())
	mdl:SetFOV(50)

	local confirm = vgui.Create("DButton", frm)
	confirm:Dock(BOTTOM)
	confirm:SetTall(75)
	confirm:DockMargin(0, 10, 0, 0)
	confirm:SetText("Change")
	confirm:SetColor(color_white)
	confirm:SetFont("DermaLarge")

	local selectingModel
	confirm.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,250))

		if selectingModel then
			draw.RoundedBox(0, 0, 0, w, 6, Color(20,20,20))
			draw.RoundedBox(0, 0, 0, w * math.Remap(selectingModel - RealTime(), 5, 0, 0, 1), 6, Color(0,100,150))
		end
	end

	confirm.DoClick = function()
		if confirm.a then return end
		confirm.a = true

		net.Start("changeCloths")
		net.SendToServer()

		frm.btnClose:Hide()

		selectingModel = RealTime() + 5

		timer.Simple(5, function()
			if not IsValid(frm) then return end

			frm:Close()
		end)
	end
end

net.Receive("changeCloths", function()
	openClothng()
end)

local titleShow = 0
local descShow = 0

local lastWatch = 0
local isWatching = false
hook.Add("HUDPaint", "HoverLockerText", function()
	local ply = LocalPlayer()
	if not IsValid(ply) or not ply:Alive() then return end

	local scrw, scrh = ScrW(), ScrH()
	local ft = FrameTime()
	local rt = RealTime()

	local tr = ply:GetEyeTrace()
	if IsValid(tr.Entity) and tr.Entity:GetClass() == "ent_rebel_locker" and ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= drawDist then
		titleShow = Lerp(ft*10, titleShow, 1)
		
		if not isWatching then
			isWatching = true

			lastWatch = rt + ShowDescriptionTime
		end
	else
		titleShow = Lerp(ft*10, titleShow, -.1)
		isWatching = false
		lastWatch = 0
	end

	if isWatching and lastWatch - rt <= 0 then
		descShow = Lerp(ft*10, descShow, 1)
	else
		descShow = Lerp(ft*10, descShow, -.1)
	end
	
	draw.SimpleText("Locker", "Trebuchet24", scrw/2, scrh/2, Color(224, 181, 54, 255 * titleShow), 1, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(description, "Trebuchet18", scrw/2, scrh/2, Color(150, 150, 150, 255 * descShow), 1, TEXT_ALIGN_TOP)
end)