include("../obum_settings.lua")



hook.Add( "ScoreboardShow", "ScoreboardOpen", function() 
    
    surface.CreateFont( "Pseudo_font", {
        font = "Bebas Neue",
        size = 25,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } )

    surface.CreateFont( "ping_font", {
        font = "Bebas Neue",
        size = 17,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } )

    surface.CreateFont( "Pseudo_font1", {
        font = "Bebas Neue",
        size = 35,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } )

    surface.CreateFont( "ping_font1", {
        font = "Bebas Neue",
        size = 20,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } ) 

    surface.CreateFont( "panel_font1", {
        font = "Bebas Neue",
        size = 27,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } ) 

    surface.CreateFont( "panel_font2", {
        font = "Bebas Neue",
        size = 25,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    } ) 

    scoreboard = vgui.Create( "DFrame" )
    scoreboard:SetSize( 300, surface.ScreenHeight() - 300 )
    scoreboard:SetPos( 10, 0 )
    scoreboard:SetTitle( "" )
    scoreboard:SetVisible( true )
    scoreboard:ShowCloseButton( false )
    scoreboard:MakePopup()
    scoreboard:SetDraggable( false )

--scoreboarde
    function scoreboard:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) )
    end

    local scroll = vgui.Create( "DScrollPanel", scoreboard )
        scroll:Dock( FILL )

            for i, player in pairs( player.GetAll() ) do
                local ListPlayer = scroll:Add( "DPanelList", scroll )
                    ListPlayer:SetTall( 55 )
                    ListPlayer:SetWide( 230 )
                    ListPlayer:SetPos( 20, 60 * i - 60)
                function ListPlayer:Paint()
                    if ulx && GroupsColors[ player:GetUserGroup() ] then
                        new_color = GroupsColors[ player:GetUserGroup() ].color
                    else 
                        new_color = GroupsColors[ "other" ].color
                    end
                    draw.RoundedBox( 5, 0, 0, ListPlayer:GetWide(), ListPlayer:GetTall()-7, new_color )
                end

                local logo = vgui.Create( "AvatarImage", ListPlayer )
                    logo:SetSize( 40, 40 )
                    logo:SetPos( 4, 4 )
                    logo:SetPlayer(player, 40)

                local Pseudo = vgui.Create( "DLabel", ListPlayer )
                    Pseudo:SetPos( 55, 5 )
                    Pseudo:SetText( player:Name() )
                    Pseudo:SetFont( "Pseudo_font" )
                    Pseudo:SizeToContents()
                    Pseudo:SetMouseInputEnabled( true )
                    function Pseudo:DoClick()
                        if  IsValid( panel ) then panel:Remove() end
                        OpenPanel(player)
                    end
                
                local Latence = vgui.Create( "DLabel", ListPlayer )
                    Latence:SetPos( 55, 27 )
                    Latence:SetColor( Color( 255, 255, 255, 90 ) )
                    Latence:SetText( 'Ping: '..player:Ping() )
                    Latence:SetFont( "ping_font" ) 
                    Latence:SizeToContents()

            end    

    return false

end )

hook.Add( "ScoreboardHide", "ScoreboardClose", function() 
    if IsValid( scoreboard ) then scoreboard:Remove() end
    if IsValid( panel ) then panel:Remove() end
end )e
