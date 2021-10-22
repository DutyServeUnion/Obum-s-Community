include('shared.lua')

local drawDist = 100^2

function ENT:Draw()
	self:DrawModel()
		
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > drawDist then return end

	cam.Start3D2D( self:LocalToWorld(Vector(0,0,83)), self:LocalToWorldAngles(Angle(0,90,90)), .2 )
		draw.SimpleText(self.PrintName, "DermaLarge",0,0,Color(255,255,255,dr),1,2)
	cam.End3D2D()
end