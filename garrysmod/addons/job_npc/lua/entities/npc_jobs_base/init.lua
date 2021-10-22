AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("OpenJobsMenu")

function ENT:Initialize()
	self:SetModel(self.Model)

	if self.Type == "ai" then
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetSolid(SOLID_BBOX)

		self:DropToFloor()
	else
		self:PhysicsInit(SOLID_VPHYSICS)
	    self:SetMoveType(MOVETYPE_VPHYSICS)
	    self:SetSolid(SOLID_VPHYSICS)
	end
	self:SetUseType(SIMPLE_USE)
end
function ENT:AcceptInput( inputName, ply, called, data )
	if inputName != 'Use' then return end
	if not ply:IsPlayer() then return end
	
	net.Start("OpenJobsMenu")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 1

	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()

	return ent
end