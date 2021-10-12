include("config.lua")
AddCSLuaFile("config.lua")
 
local PANEL = {}
 
AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )
 
function PANEL:Init()
 
    self.Navigation = vgui.Create( "DScrollPanel", self )
    self.Navigation:Dock( TOP )
    self.Navigation:SetHeight( 40 )
    self.Navigation:DockMargin( 0, 0, 0, 0 )
 
    self.Content = vgui.Create( "Panel", self )
    self.Content:Dock( FILL )
 
    self.Items = {}
 
end
 
function PANEL:UseButtonOnlyStyle()
    self.ButtonOnly = true
end
 
function PANEL:AddSheet( label, panel, material )
 
    if ( !IsValid( panel ) ) then return end
 
    local Sheet = {}
 
    if ( self.ButtonOnly ) then
        Sheet.Button = vgui.Create( "DImageButton", self.Navigation )
    else
        Sheet.Button = vgui.Create( "DButton", self.Navigation )
    end
 
    Sheet.Button:SetImage( material )
    Sheet.Button.Target = panel
    Sheet.Button:Dock( LEFT )
    Sheet.Button:SetText( label )
    Sheet.Button:DockMargin( 12, 4, 0, 0 )
    Sheet.Button:SetWidth( 105 )
    Sheet.Button.Paint = function(self, w, h)
        surface.SetDrawColor(F4Config.ButtonColor)
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor(F4Config.OutlineButtonColor)
        surface.DrawOutlinedRect( 0, 0, w, h )
   
end
 
    Sheet.Button.DoClick = function()
        self:SetActiveButton( Sheet.Button )
    end
 
    Sheet.Panel = panel
    Sheet.Panel:SetParent( self.Content )
    Sheet.Panel:SetVisible( false )
 
    if ( self.ButtonOnly ) then
        Sheet.Button:SizeToContents()
        --Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
    end
 
    table.insert( self.Items, Sheet )
 
    if ( !IsValid( self.ActiveButton ) ) then
        self:SetActiveButton( Sheet.Button )
    end
 
end
 
function PANEL:SetActiveButton( active )
 
    if ( self.ActiveButton == active ) then return end
 
    if ( self.ActiveButton && self.ActiveButton.Target ) then
        self.ActiveButton.Target:SetVisible( false )
        self.ActiveButton:SetSelected( false )
        self.ActiveButton:SetToggle( false )
    end
 
    self.ActiveButton = active
    active.Target:SetVisible( true )
    active:SetSelected( true )
    active:SetToggle( true )
 
    self.Content:InvalidateLayout()
 
end
 
derma.DefineControl( "CSDColSheet", "", PANEL, "Panel" )