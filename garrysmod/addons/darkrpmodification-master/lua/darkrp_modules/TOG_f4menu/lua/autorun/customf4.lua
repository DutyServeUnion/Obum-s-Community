if SERVER then

	AddCSLuaFile( "vgui/cs_f4_menu.lua" )
	util.AddNetworkString("f4menu")

	hook.Add( "ShowSpare2", "F4MenuHook", function( ply )
		net.Start( "f4menu" )
		net.Send ( ply )


	
	end)
	
end

if CLIENT then
	include( "vgui/cs_f4_menu.lua" )
	net.Receive( "f4menu", function()	
		if( !CSF4Menu ) then
			CSF4Menu = vgui.Create( "cs_f4_menu" )
			CSF4Menu:SetVisible ( false )
		end

		
		if( CSF4Menu:IsVisible() ) then
			CSF4Menu:SetVisible( false )
			gui.EnableScreenClicker( false )
		
		else
			CSF4Menu:SetVisible( true )
			gui.EnableScreenClicker( true )
		
		end
		
			
	end)
end