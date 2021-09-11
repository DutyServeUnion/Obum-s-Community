AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "CP Rank Vendor"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH



if SERVER then
    function ENT:Initialize()
        self:SetModel("models/dpfilms/metropolice/police_bt.mdl")
        self:SetMoveType(MOVETYPE_NONE)
	    self:DrawShadow(true)
	    self:SetSolid(SOLID_BBOX)
	    self:PhysicsInit(SOLID_BBOX)

        if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
    end

    function ENT:Use(act)
        self:SetUseType(SIMPLE_USE)
        self:EmitSound("npc/metropolice/vo/unitis10-8standingby.wav")

        netstream.Start(act, "ixCPRankUse", {act})
    end

    timer.Simple(1, function()
		if (IsValid(self)) then
			self:SetAnim()
		end
	end)

end

    

if CLIENT then

  function ENT:Draw()
    self:DrawModel()
  end

end
