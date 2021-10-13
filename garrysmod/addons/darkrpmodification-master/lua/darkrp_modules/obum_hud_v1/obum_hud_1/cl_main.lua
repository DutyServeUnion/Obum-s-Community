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
      
