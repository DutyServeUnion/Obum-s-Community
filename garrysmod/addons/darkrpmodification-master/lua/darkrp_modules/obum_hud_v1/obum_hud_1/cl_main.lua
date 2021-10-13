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
    ["DarkRP_ZombieInfo"] 		   = true,
	["DarkRP_LocalPlayerHUD"] 	   = true,    
    ["DarkRP_Agenda"] 			   = true,    

    local function hideElements(name)
    if name = "CHudHealths"