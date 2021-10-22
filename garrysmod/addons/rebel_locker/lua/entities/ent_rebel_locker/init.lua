AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr, cl )
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create( cl )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.RebelJob = _G[self.RebelJob]
	self.CitizenJob = _G[self.CitizenJob]
end

util.AddNetworkString("changeCloths")
function ENT:Use(ply)
	ply.UsingLocker = self

	self:EmitSound("doors/door_metal_thin_open1.wav")

	net.Start("changeCloths")
	net.Send(ply)
end

net.Receive("changeCloths", function(_, ply)
	if not IsValid(ply.UsingLocker) or ply.ChangingCloths then return end

	local TEAM = RPExtraTeams[ply:Team() == ply.UsingLocker.CitizenJob and ply.UsingLocker.RebelJob or ply.UsingLocker.CitizenJob]
	if not TEAM then return end

	timer.Create(ply.UsingLocker:EntIndex() .. "makeClothingSounds", 1, 4, function()
		if IsValid(ply) and IsValid(ply.UsingLocker) then
			ply.UsingLocker:EmitSound(ply.UsingLocker.ClothingSounds[math.random(1,#ply.UsingLocker.ClothingSounds)])
		end
	end)

	ply:Freeze(true)
	ply.ChangingCloths = true
	timer.Simple(5, function()
		if not IsValid(ply) then return end
		ply.ChangingCloths = nil

		ply.UsingLocker:EmitSound("doors/door_metal_thin_close2.wav")

		ply:Freeze(false)
		
		-- ugly
		if ply:Team() == ply.UsingLocker.RebelJob then
			ply:changeTeam(ply.UsingLocker.CitizenJob)
		elseif ply:Team() == ply.UsingLocker.CitizenJob then
			ply:changeTeam(ply.UsingLocker.RebelJob)
		end

		ply.UsingLocker = nil

		ply:SetModel(TEAM.model[math.random(1,#TEAM.model)])
	end)
end)