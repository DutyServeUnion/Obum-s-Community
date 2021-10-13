include("config.lua")
AddCSLuaFile("config.lua")

surface.CreateFont( "Welcome Text", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


local PANEL = {
	Init = function( self )
		self:SetSize(900,700 )
		self:Center()
		self:SetVisible( true )
		
		local x, y = self:GetSize()
		
		surface.SetFont( "DermaLarge" )
		local titleX, titleY = surface.GetTextSize( "DarkRP F4Menu" )
		
		local title = vgui.Create( "DLabel", self)
		title:SetText(F4Config.TitleText)
		title:SetSize(titleX, titleY)
		title:SetPos( 20, 6 )
		title:SetFont( "DermaLarge" )
		title:SetTextColor( Color(255,255,255,255) )
		title:SetExpensiveShadow(2, Color(0,0,0,255) )
		
		local closebutton = vgui.Create( "DButton", self)
		closebutton:SetText( "Close" )
		closebutton:SetSize(75, 30)
		closebutton:SetPos( x-81, 6)
		closebutton.Paint = function(self, w, h)
			surface.SetDrawColor( 30,30,30, 50)
			surface.DrawRect( 0, 0, w, h )
			surface.SetDrawColor( 20,20,20, 150)
			surface.DrawOutlinedRect( 0, 0, w, h )
			
		end
		closebutton.DoClick = function()
			CSF4Menu:SetVisible( false )
			gui.EnableScreenClicker( false )
		end
		
				local pagesback = vgui.Create( "DPanel" , self )
		pagesback:SetPos( 6, 37 )
		pagesback:SetSize( x - 12, y - 46 )
		pagesback.Paint = function( self, w, h )
		surface.SetDrawColor( 30, 30, 30, 150 )
        surface.DrawRect( 0, 0, w, h )
		
	end
	
		local pages = vgui.Create( "CSDColSheet", pagesback )
		pages:Dock ( FILL )
		
		-- HOME tab
		local homearea = vgui.Create( "DPanel" , pages )
		homearea:Dock( FILL )
		homearea.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
	pages:AddSheet( "Home", homearea )
	
		local text = vgui.Create( "DLabel", homearea)
			text:SetSize(500, 50)
			text:SetFont( "Welcome Text" )
			text:SetPos(250,1)
			text:SetText(F4Config.WelcomeTitle)
	
	
		local button = vgui.Create( "DButton", homearea)
			button:SetSize( 300, 50 )
			button:SetPos(290,100)
			button:SetText("Join Our Website")
			button.DoClick = function()
			gui.OpenURL("")
end
		local button = vgui.Create( "DButton", homearea)
			button:SetSize( 300, 50 )
			button:SetPos(290,250)
			button:SetText("Join Our SteamGroup")
			button.DoClick = function()
			gui.OpenURL("")
end
			local button = vgui.Create( "DButton", homearea)
			button:SetSize( 300, 50 )
			button:SetPos(290,400)
			button:SetText("Donate For Special Benefits!")
			button.DoClick = function()
			gui.OpenURL("")
end	
		
		local jobs = vgui.Create( "DScrollPanel" , pages )
		jobs:Dock( FILL )
		jobs.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
	
		pages:AddSheet( "Jobs", jobs )
		
		local shop = vgui.Create( "DScrollPanel" , pages )
		shop:Dock( FILL )
		shop.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
	
		pages:AddSheet( "Entities", shop )
		
		local ammo = vgui.Create( "DScrollPanel" , pages )
		ammo:Dock( FILL )
		ammo.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
	
		pages:AddSheet( "Ammo", ammo )
		
		local ShipmentsWeapons = vgui.Create( "DScrollPanel" , pages )
		ShipmentsWeapons:Dock( FILL )
		ShipmentsWeapons.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
	
		pages:AddSheet( "Shop", ShipmentsWeapons )
		

		
		
		-- bye weapons tab lol

		
		-- entities tab
		for k, v in pairs(DarkRPEntities) do
		
		local entbackround = vgui.Create( "DPanel" , shop )
		entbackround:Dock( TOP )
		entbackround:SetSize( 0,150 )
		entbackround:DockMargin( 5, 5, 5, 5)
		entbackround.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
		entbackround:SetExpensiveShadow(2, Color(0,0,0,255) )
	end 
	
		local entback = vgui.Create( "DPanel", entbackround)
		entback:Dock(LEFT)
		entback:SetSize( 0, 150 )
		entback:DockMargin( 5, 5, 5, 5 )
		entback.Paint = function( self, w, h )
			surface.SetDrawColor( 20,20,20,150 )
			surface.DrawRect(0, 0, w, h)
			
		end	 
	
		surface.SetFont( "Trebuchet24" )
		local entnamesX, entnamesY = surface.GetTextSize( v.name )
	
		local entnames = vgui.Create( "DLabel", entbackround)
		entnames:SetText( v.name )
		entnames:SetSize( entnamesX, entnamesY)
		entnames:Dock( TOP )
		entnames:DockMargin( 5, 5, 0, 0 )
		entnames:SetFont( "Trebuchet24" )
		entnames:SetTextColor( Color(255,255,255,255) )
		entnames:SetExpensiveShadow(2, Color(0,0,0,255) )
		
			local entmodels = vgui.Create( "SpawnIcon", entbackround)
			entmodels:Dock(LEFT)
			entmodels:SetSize( 150, 50 )
			entmodels:DockMargin( 5, 5, 5, 5 )
			entmodels:SetModel(v.model)
			
		surface.SetFont( "Trebuchet24" )
		local entpriceX, entpriceY = surface.GetTextSize( "Price: " .. DarkRP.formatMoney(v.price) )
		
		local entprice = vgui.Create( "DLabel", entbackround)
		entprice:SetText( "Price: " .. DarkRP.formatMoney(v.price) )
		entprice:SetSize( entpriceX, entpriceY)
		entprice:Dock( TOP )
		entprice:DockMargin( 5, 5, 0, 0 )
		entprice:SetFont( "Trebuchet24" )
		entprice:SetTextColor( Color(255,255,255,255) )
		entprice:SetExpensiveShadow(2, Color(0,0,0,255) )
		
		surface.SetFont( "Trebuchet24" )
		local entmaxX, entmaxY = surface.GetTextSize( "Max: " .. v.max )
		
		local entmax = vgui.Create( "DLabel", entbackround)
		entmax:SetText( "Max: " .. v.max)
		entmax:SetSize( entmaxX, entmaxY)
		entmax:Dock( TOP )
		entmax:DockMargin( 5, 5, 0, 0 )
		entmax:SetFont( "Trebuchet24" )
		entmax:SetTextColor( Color(255,255,255,255) )
		entmax:SetExpensiveShadow(2, Color(0,0,0,255) )


		local entpurchasebutton = vgui.Create( "DButton", entbackround )
		entpurchasebutton:SetText("Purchase")
		entpurchasebutton:SetTextColor( Color(255,255,255,255) )
		entpurchasebutton:SetExpensiveShadow(2, Color(0,0,0,255) )
		entpurchasebutton:Dock(BOTTOM)
		entpurchasebutton:DockMargin(5, 5, 5, 5)
		entpurchasebutton.Paint = function( self, w, h )
			surface.SetDrawColor( 30, 30, 30, 150 )
			surface.DrawRect(0,0, w, h )
			surface.SetDrawColor( 20, 20, 20, 150 )
			surface.DrawOutlinedRect( 0, 0, w, h )
			end
		entpurchasebutton.DoClick = function()
			RunConsoleCommand( "say", "/" .. v.cmd )
			
		end

	end
		-- job tab
		for k, v in pairs(RPExtraTeams) do
		
		local jobbackround = vgui.Create( "DPanel" , jobs )
		jobbackround:Dock( TOP )
		jobbackround:SetSize( 0,150 )
		jobbackround:DockMargin( 5, 5, 5, 5)
		jobbackround.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
		jobbackround:SetExpensiveShadow(2, Color(0,0,0,255) )
	end 
	
		local names = vgui.Create( "DLabel", jobbackround)
		names:SetText( v.name )
		names:Dock( TOP )
		names:DockMargin( 5, 5, 0, 0 )
		names:SetFont( "Trebuchet24" )
		names:SetTextColor( Color(255,255,255,255) )
		names:SetExpensiveShadow(2, Color(0,0,0,255) )
		
		if util.IsValidModel( v.model[1] ) then
			local models = vgui.Create( "SpawnIcon", jobbackround)
			models:Dock(LEFT)
			models:SetSize( 150, 50 )
			models:DockMargin( 5, 5, 5, 5 )
			models:SetModel(v.model[1])
			
		else

			local models = vgui.Create( "SpawnIcon", jobbackround)
			models:Dock(LEFT)
			models:SetSize( 150, 50 )
			models:DockMargin( 5, 5, 5, 5 )
			models:SetModel(v.model)
		
		end	
		
		local desc = vgui.Create( "DPanel", jobbackround)
		desc:Dock(FILL)
		desc:SetSize( 0, 150 )
		desc:DockMargin( 5, 5, 5, 5 )
		desc.Paint = function( self, w, h )
			surface.SetDrawColor( 20,20,20,150 )
			surface.DrawRect(0, 0, w, h)
			
		end	

		surface.SetFont( "Trebuchet18" )
		local desX, desY = surface.GetTextSize( v.description )		
		
		local description = vgui.Create( "DLabel", desc)
		description:SetText( v.description )
		description:Dock( TOP )
		description:DockMargin( 5, 5, 5, 5 )
		description:SetSize( desX, desY )
		description:SetFont( "Trebuchet18" )
		description:SetTextColor( Color(255,255,255,255) )
		description:SetExpensiveShadow(2, Color(0,0,0,255) )
		
		local jobbutton = vgui.Create( "DButton", jobbackround )
		jobbutton:SetText("Become Job")
		jobbutton:SetTextColor( Color(255,255,255,255) )
		jobbutton:SetExpensiveShadow(2, Color(0,0,0,255) )
		jobbutton:Dock(BOTTOM)
		jobbutton:DockMargin(5, 5, 5, 5)
		jobbutton.Paint = function( self, w, h )
			surface.SetDrawColor( 30, 30, 30, 150 )
			surface.DrawRect(0,0, w, h )
			surface.SetDrawColor( 20, 20, 20, 150 )
			surface.DrawOutlinedRect( 0, 0, w, h )
			end
		jobbutton.DoClick = function()
			RunConsoleCommand( "say", "/" .. v.command )
			
		end

		
		
		-- actions tab
		local commandsarea = vgui.Create( "DPanel" , pages )
		commandsarea:Dock( FILL )
		commandsarea.Paint = function(self, w, h )
			surface.SetDrawColor( 30,30,30, 150 )
			surface.DrawRect( 0, 0, w, h )
	end
		
	function commandsarea:addButton( text, func )
		local commandsbutton = vgui.Create( "DButton", commandsarea)
		commandsbutton:SetText( text )
		commandsbutton:Dock( TOP )
		commandsbutton:DockMargin(5,5,5,5)
		commandsbutton.Paint = function( self, w, h )
			surface.SetDrawColor(30,30,30,150)
			surface.DrawRect(0,0,w,h )
			surface.SetDrawColor( 50, 50, 50, 150)
			surface.DrawOutlinedRect( 0, 0, w, h)
		end
		commandsbutton.DoClick = func

	end
	pages:AddSheet( "Actions", commandsarea )
	
	commandsarea:addButton( "Give money to(looking at)", function() 
		Derma_StringRequest( "Give Money", "How Much?", "", function( txt )
			RunConsoleCommand( "say", "/give " .. txt )
		end)
	end )
	
	commandsarea:addButton( "Drop Money", function() 
		Derma_StringRequest( "Drop Money", "How Much?", "", function( txt )
			RunConsoleCommand( "say", "/dropmoney " .. txt )
		end)
	end )

	commandsarea:addButton( "Call an Admin", function() 
		RunConsoleCommand( "say", "@ Admin i need help." )
end )

		commandsarea:addButton( "Drop Current Weapon", function() 
		RunConsoleCommand( "say", "/dropweapon" .. txt )
end )

		commandsarea:addButton( "Change your RPName", function() 
		Derma_StringRequest( "RPName", "What's Your New Name?", "", function( txt )
		RunConsoleCommand( "say", "/rpname " .. txt )
	end)
end )
		
		
end,
	
	
	Paint = function( self, w, h )
		surface.SetDrawColor( 50,50,50, 150)
		surface.DrawRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 2, 2, w - 4, h - 4 )
	
	end

}
vgui.Register( "cs_f4_menu", PANEL)

timer.Simple( 2, function()
GAMEMODE.ShowSpare2 = openF4
end ) 

concommand.Add("open_f4", function()
openF4()
end)
