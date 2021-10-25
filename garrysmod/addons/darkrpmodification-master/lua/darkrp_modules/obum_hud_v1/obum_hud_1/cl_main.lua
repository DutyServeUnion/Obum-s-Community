local HUD = {}

-- you can eddit settings here
HUD.x = "left"
HUD.Y = "bottom";   -- bottom

HUD.HealthColor = Color(192, 57, 43, 255)
HUD.ArmorColor = Color(41, 128, 185, 255)

-- if you change this I will kill you 
HUD.Width = 400
HUD.Height = 15-

HUD.Border = 15

HUD.PosX = 0 
HUD.PosY = 0
--- now edit below here

local hideHUDElements = {
    ["DarkRP_HUD"]                 = true,
    ["DarkRP_EntityDisplay"]       = true,
    ["DarkRP_Hungermod"]           = true,
    ["DarkRP_ZombieInfo"]          = true,
    ["DarkRP_LocalPlayerHUD"] 	   = true,    
    ["DarkRP_Agenda"] 		   = true,    

    local function hideElements(name)
    if name = "CHudHealths" or name = "CHudBattery" or name == "CHudSuitPower" then
	return false 
    end
		if hideHUDElments [name] then
		   return false
		end 
   end
	
	
	hook.Add("HUDShouldDraw", "hideElments", hideElments)
	
	-- prcess setting--
if HUD.X == "left" then
	HUD.PosX == HUD.Border
elseif HUD.X == "center" then
	HUD.PosX = ScrW() / 2 - HUD.Width / 2
elseif HUD.X == "right" then
	HUD.PosX = ScrW() - HUD.Border
else
   HUD.PosX = HUD.Border
end
	
	-- Format Number Func --/
local function formatNumber(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
	end
	return n
end
	
	-- hud element sjit --
HUD.BHeight = HUD.Height / 2 - 15
HUD.BPosY = HUD.PosY + HUD.Height / 2 + HUD.Border

HUD.BHeight1 = HUD.BHeight / 2 - 10
HUD.BPosY1 = HUD.BPosY + 3
HUD.BPosY2 = HUD.BPosY + 27

HUD.BarWidth = HUD.Width - 90

HUD.HHeight = HUD.Height / 2 + 11

local function Base()

		-- back ground
		draw.RoundedBox(4, HUD.PosX-1, HUD.PosY-1, HUD.Width+2, HUD.Height+2, Color(30,30,30,255))
		draw.RoundedBox(4, HUD.PosX, HUD.PosY, HUD.Width, HUD.Height, Color(50,50,50,255))
		-- borders
		draw.RoundedBox(0, HUD.PosX, HUD.BPosY-4, HUD.Width, 2, Color(30,30,30,255))
		draw.RoundedBox(0, HUD.PosX, HUD.BPosY-2, HUD.Width, 2, Color(90,90,90,255))
		
		draw.RoundedBox(0, HUD.PosX + HUD.Width - 50 - 4, HUD.PosY, 2, HUD.HHeight, Color(30,30,30,255))
		draw.RoundedBox(0, HUD.PosX + HUD.Width - 50 - 2, HUD.PosY, 2, HUD.HHeight, Color(90,90,90,255))
		
		draw.RoundedBox(0, HUD.PosX + 75 + 2, HUD.PosY, 2, HUD.HHeight, Color(30,30,30,255))
		draw.RoundedBox(0, HUD.PosX + 75, HUD.PosY, 2, HUD.HHeight, Color(90,90,90,255))
		
		-- sections
		draw.RoundedBoxEx(4, HUD.PosX, HUD.BPosY, HUD.Width, HUD.BHeight, Color(70,70,70,255), false, false, true, true)
		draw.RoundedBoxEx(4, HUD.PosX + HUD.Width - 50, HUD.PosY, 50, HUD.HHeight, Color(60,60,60,255), false, true, false, false)
		draw.RoundedBoxEx(4, HUD.PosX, HUD.PosY, 75, HUD.HHeight, Color(70,70,70,255), true, false, false, false)	
end
	
	local function PlayerModel()

	PlayerModel = vgui.Create("DModelPanel")
	function PlayerModel:LayoutEntity( Entity ) return end
	PlayerModel:SetModel( LocalPlayer():GetModel() )
	PlayerModel:SetPos(HUD.PosX, HUD.PosY)
	PlayerModel:SetSize(80, HUD.HHeight)
	PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
	PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
		
	timer.Create( "UpdatePlayerModel", 0.5, 0, function()
			if LocalPlayer():GetModel() != PlayerModel.Entity:GetModel() then
					PlayerModel:Remove()
					PlayerModel = vgui.Create("DModelPanel")
					function PlayerModel:LayoutEntity( Entity ) return end         
					PlayerModel:SetModel( LocalPlayer():GetModel())
					PlayerModel:SetPos(HUD.PosX, HUD.PosY)
					PlayerModel:SetSize(75, HUD.HHeight)
					PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
					PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
			end
	end)

end

hook.Add("InitPostEntity", "PlayerMdl", PlayerModel)
-- health and values (Apex continue here)
local function Health()
			-- Values
	local Health = LocalPlayer():Health() or 0
	local FullHealth = LocalPlayer():Health() or 0
	if Health < 0 then Health = 0 elseif Health > 100 then Health = 100 end
	local DrawHealth = math.Min(Health/GAMEMODE.Config.startinghealth, 1)
	-- one sec i forgot tex TITLE HERE - -
