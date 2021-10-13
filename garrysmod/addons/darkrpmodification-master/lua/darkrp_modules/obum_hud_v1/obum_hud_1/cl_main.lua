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
	draw.RoundedBox(3, HUD.PosX-2, HUD.posY-2, HUD.Width+4, HUD.Height+4, Color(30, 30, 30,255))
	draw.RoundedBox(3, HUD.PosX, HUD.PosY, HUD.Width, HUD.Height, Color(50,50,50,255))
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
