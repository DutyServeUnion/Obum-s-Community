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

local setButtons
function ENT:Initialize()
	self:SetModel(Terminal.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	if not setButtons then
		setButtons = true

		for btn, pos in pairs(Terminal.MapButtons) do
			for i, ent in ipairs(ents.FindInSphere(pos, 10)) do
				if ent:GetClass() == "func_button" then
					Terminal.MapButtons[btn] = ent

					break
				end
			end
		end
	end
end

util.AddNetworkString("terminal_Open")
function ENT:Use(ply)
	--if not Terminal.CanUse[ply:Team()] then return end

	net.Start("terminal_Open")
	net.Send(ply)
end

util.AddNetworkString("terminal_Dispatch")
net.Receive("terminal_Dispatch", function(_, ply)
	--if not Terminal.CanUse[ply:Team()] then return end
	local soundKey = net.ReadString()
	if not soundKey or not Terminal.DispatchSounds[soundKey] then return end

	net.Start("terminal_Dispatch")
		net.WriteString(soundKey)
	net.Broadcast()
end)

util.AddNetworkString("terminal_ControlMap")
net.Receive("terminal_ControlMap", function(_, ply)
	--if not Terminal.CanUse[ply:Team()] then return end
	local btnKey = net.ReadString()
	if not btnKey or not IsValid(Terminal.MapButtons[btnKey]) then return end

	Terminal.MapButtons[btnKey]:Fire("Press")
end)

util.AddNetworkString("terminal_BoL")
net.Receive("terminal_BoL", function(_, ply)
	--if not Terminal.CanUse[ply:Team()] then return end
	local reason = net.ReadString()
	local citizen = net.ReadEntity()
	if not reason or not IsValid(citizen) then return end

	citizen:SetNWString("BoL", reason)
end)