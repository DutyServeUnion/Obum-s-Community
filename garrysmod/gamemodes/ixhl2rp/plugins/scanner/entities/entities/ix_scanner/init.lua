include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("ixScannerFlash")

ENT.scanSounds = {
    "cbot/cbot_scan1.wav",
    "cbot/cbot_scan2.wav",
    "cbot/cbot_alert1.wav",
    "cbot/cbot_blip1.wav",
}
ENT.painSounds = {
    "cbot/cbot_battletalk1.wav",
    "cbot/cbot_battletalk2.wav",
    "cbot/cbot_battletalk3.wav",
    "cbot/cbot_battletalk4.wav",
}
ENT.sirenSound = "cbot/cbot_servosuprise.wav"

function ENT:EjectPilot(no)
    local pilot = self:GetPilot()
    if (not IsValid(pilot)) then return end

    pilot:SetMoveType(MOVETYPE_WALK)
    pilot:UnSpectate()

    if (not self.noRespawn and pilot:Alive()) then
        pilot:Spawn()
    end

    pilot:SetPos(self.spawn or self:GetPos())
    pilot:DrawViewModel(true)
    pilot:CrosshairEnable()

    if (self.health <= 0) then
        pilot:KillSilent()
    end

    self:SetPilot(NULL)
end

function ENT:SetPilotEntity(client)
    self:EjectPilot()
    self:SetPilot(client)

    client:Spectate(OBS_MODE_CHASE)
    client:SpectateEntity(self)
    client:StripWeapons()
    client:DrawViewModel(false)
    client:CrosshairDisable()
    client:Flashlight(false)
end

function ENT:CreateFlashSprite()
    if (IsValid(self.spotlight)) then return end

    local SCANNER_ATTACHMENT_LIGHT = "light"

    self.flashSprite = ents.Create("env_sprite")
    self.flashSprite:SetAttachment(
        self,
        self:LookupAttachment(SCANNER_ATTACHMENT_LIGHT)
    )
    self.flashSprite:SetKeyValue("model", "sprites/blueflare1.vmt")
    self.flashSprite:SetKeyValue("scale", 1.4)
    self.flashSprite:SetKeyValue("rendermode", 3)
    self.flashSprite:SetRenderFX(kRenderFxNoDissipation)
    self.flashSprite:Spawn()
    self.flashSprite:Activate()
    self.flashSprite:SetColor(Color(255, 255, 255, 0))
end

function ENT:EnableSpotlight()
    if (IsValid(self.spotlight)) then return end

    local SCANNER_ATTACHMENT_LIGHT = "light"
    local attachment = self:LookupAttachment(SCANNER_ATTACHMENT_LIGHT)
    local position = self:GetAttachment(attachment)

    if (not position) then return end

    -- The volumetric light effect.
    self.spotlight = ents.Create("point_spotlight")
    self.spotlight:SetPos(position.Pos)
    self.spotlight:SetAngles(self:GetAngles())
    self.spotlight:SetParent(self)
    self.spotlight:Fire("SetParentAttachment", SCANNER_ATTACHMENT_LIGHT)
    self.spotlight:SetLocalAngles(self:GetForward():Angle())
    self.spotlight:SetKeyValue("spotlightwidth", self.spotlightWidth)
    self.spotlight:SetKeyValue("spotlightlength", self.spotlightLength)
    self.spotlight:SetKeyValue("HDRColorScale", self.spotlightHDRColorScale)
    self.spotlight:SetKeyValue("color", "255 255 255")
    -- On by default and disable dynamic light.
    self.spotlight:SetKeyValue("spawnflags", 3)
    self.spotlight:Spawn()
    self.spotlight:Activate()

    -- The actual dynamic light.
    self.flashlight = ents.Create("env_projectedtexture")
    self.flashlight:SetPos(position.Pos)
    self.flashlight:SetParent(self)
    self.flashlight:SetLocalAngles(self.spotlightLocalAngles)
    self.flashlight:SetKeyValue(
        "enableshadows",
        self.spotlightEnableShadows and 1 or 0
    )
    self.flashlight:SetKeyValue("nearz", self.spotlightNear)
    self.flashlight:SetKeyValue("lightfov", self.spotlightFOV)
    self.flashlight:SetKeyValue("farz", self.spotlightFar)
    self.flashlight:SetKeyValue("lightcolor", "255 255 255")
    self.flashlight:Spawn()
    self.flashlight:Input(
        "SpotlightTexture", NULL, NULL, "effects/flashlight/soft"
    )
end

function ENT:DisableSpotlight()
    if (IsValid(self.spotlight)) then
        self.spotlight:SetParent(NULL)
        self.spotlight:Input("LightOff")
        self.spotlight:Fire("Kill", "", 0.25)
    end

    if (IsValid(self.flashlight)) then
        self.flashlight:Remove()
    end
end

function ENT:IsSpotlightOn()
    return IsValid(self.spotlight)
end

function ENT:Initialize()
    self:SetModel("models/Combine_Scanner.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:AddSolidFlags(FSOLID_NOT_STANDABLE)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:GetPhysicsObject():EnableMotion(true)
    self:GetPhysicsObject():Wake()
    self:GetPhysicsObject():EnableGravity(false)
    self:ResetSequence("idle")
    self:SetPlaybackRate(1.0)
    self:AddFlags(FL_FLY)
    self:PrecacheGibs()

    if (SERVER) then
        self:CreateFlashSprite()
    end

    self.targetDir = vector_origin
    self.health = self.maxHealth
end

function ENT:SetClawScanner()
    self:SetModel("models/shield_scanner.mdl")
    self:PrecacheGibs()
    self:ResetSequence("hoverclosed")
end

function ENT:Flash()
    local max = 30
    local value = max
    local timerID = "ScannerFlash"..self:EntIndex()

    self.flashSprite:SetColor(color_white)
    self:EmitSound("npc/scanner/scanner_photo1.wav")

    net.Start("ixScannerFlash")
        net.WriteEntity(self)
    net.SendPVS(self:GetPos())

    timer.Create("ScannerFlash"..self:EntIndex(), 0, max, function()
        if (IsValid(self) and IsValid(self.flashSprite)) then
            self.flashSprite:SetColor(
                Color(255, 255, 255, (value / max) * 255)
            )
            value = value - 1
        else
            timer.Remove(timerID)
        end
    end)

    self:EmitDelayedSound(table.Random(self.scanSounds), 1)
end

function ENT:EmitDelayedSound(source, delay, volume, pitch)
    timer.Simple(delay or 0, function()
        if (IsValid(self)) then
            self:EmitSound(source, volume, pitch)
        end
    end)
end

function ENT:HandlePilotMove()
    local still = true
    local pilot = self:GetPilot()

    if (pilot:KeyDown(IN_FORWARD)) then
        self.accelXY = Lerp(0.1, self.accelXY, 10)
        self.targetDir = self.targetDir + pilot:GetAimVector()
        still = false
    end
    if (pilot:KeyDown(IN_JUMP)) then
        self.accelXY = Lerp(0.25, self.accelXY, 10)
        self.targetDir = self.targetDir + Vector(0, 0, 1)
        still = false
    end
    if (pilot:KeyDown(IN_SPEED)) then
        self.accelXY = Lerp(0.25, self.accelXY, 10)
        self.targetDir = self.targetDir - Vector(0, 0, 1)
        still = false
    end
    if (still) then
        self.accelXY = Lerp(0.5, self.accelXY, 0)
        self.accelZ = Lerp(0.5, self.accelZ, 0)
    end

    pilot:SetPos(self:GetPos())

    if (pilot:GetMoveType() ~= MOVETYPE_NONE) then
        pilot:SetMoveType(MOVETYPE_NONE)
    end
end

function ENT:DiscourageHitGround()
    local trace = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() - self.minHoverHeight,
        filter = {self, self:GetPilot()}
    })
    if (trace.Hit) then
        self.targetDir.z = self.minHoverPush.z
    end
end

function ENT:Think()
    self.targetDir.x = 0
    self.targetDir.y = 0
    self.targetDir.z = 0
    self:UpdateDirection()

    if (IsValid(self:GetPilot())) then
        self:HandlePilotMove()
    end

    self:DiscourageHitGround()
    self.targetDir:Normalize()

end

function ENT:UpdateNoiseVelocity()
    self.noise.z = math.sin(CurTime() * 2) * 75 * (1 - self.accelZ)
end

function ENT:FacePilotDirection()
    self.faceAngles = self:GetPilot():EyeAngles()
    self.faceAngles.p = math.Clamp(self.faceAngles.p, -30, 25)
end

function ENT:UpdateDirection()
    if (IsValid(self:GetPilot())) then
        self:FacePilotDirection()
    end
end

local angDiff = math.AngleDifference

function ENT:PhysicsUpdate(phys)
    local dt = FrameTime()

    local velocity = phys:GetVelocity()
    local decay = self.velocityDecay
    local maxSpeed = self.maxSpeed * dt
    local targetDir = self.targetDir

    velocity.x = decay.x * velocity.x + self.accelXY * maxSpeed * targetDir.x
    velocity.y = decay.y * velocity.y + self.accelXY * maxSpeed * targetDir.y
    velocity.z = decay.z * velocity.z
        + self.accelXY * self.maxSpeedZ * targetDir.z * dt
    self:UpdateNoiseVelocity()
    velocity = velocity + self.noise * dt

    if (velocity:LengthSqr() > self.maxSpeedSqr) then
        velocity:Normalize()
        velocity:Mul(self.maxSpeed)
    end
    phys:SetVelocity(velocity)

    local angles = self:GetAngles()
    self.accelAnglular.x =
        angDiff(self.faceAngles.r, angles.r) * self.turnSpeed * dt
    self.accelAnglular.y =
        angDiff(self.faceAngles.p, angles.p) * self.turnSpeed * dt
    self.accelAnglular.z =
        angDiff(self.faceAngles.y, angles.y) * self.turnSpeed * dt
    phys:AddAngleVelocity(
        self.accelAnglular - phys:GetAngleVelocity() * self.angleDecay
    )

    -- Makes the spotlight motion more smooth.
    if (IsValid(self.spotlight)) then
        self.spotlight:SetAngles(self:GetAngles())
    end

    self.lastPhys = CurTime()
end

function ENT:Die(dmgInfo)
    local force = dmgInfo and dmgInfo:GetDamageForce() or Vector(0, 0, 50)
    self:GibBreakClient(force)

    local effect = EffectData()
        effect:SetStart(self:GetPos())
        effect:SetOrigin(self:GetPos())
        effect:SetMagnitude(0)
        effect:SetScale(0.5)
        effect:SetColor(25)
        effect:SetEntity(self)
    util.Effect("Explosion", effect, true, true)

    self:EmitSound("NPC_SScanner.Die")
    self:Remove()
end

function ENT:CreateDamageSmoke()
    if (IsValid(self.smoke)) then return end

    self.smoke = ents.Create("env_smoketrail")
    self.smoke:SetParent(self)
    self.smoke:SetLocalPos(vector_origin)
    self.smoke:SetKeyValue("spawnrate", 5)
    self.smoke:SetKeyValue("opacity", 1)
    self.smoke:SetKeyValue("lifetime", 1)
    self.smoke:SetKeyValue("startcolor", "200 200 200")
    self.smoke:SetKeyValue("startsize", 5)
    self.smoke:SetKeyValue("endsize", 20)
    self.smoke:SetKeyValue("spawnradius", 10)
    self.smoke:SetKeyValue("minspeed", 5)
    self.smoke:SetKeyValue("maxspeed", 10)
    self.smoke:Spawn()
    self.smoke:Activate()
end

function ENT:RemoveDamageSmoke()
    if (IsValid(self.smoke)) then
        self.smoke:Remove()
    end
end

function ENT:DoDamageSound()
    -- smoke trail when damaged (env_smoketrail)
    local critical = self.maxHealth * 0.25
    if (self.lastHealth >= critical and self.health <= critical) then
        self:createDamageSmoke()
        self:EmitSound(self.sirenSound)
    elseif ((self.nextPainSound or 0) < CurTime()) then
        self.nextPainSound = CurTime() + 0.5

        local painSound = table.Random(self.painSounds)
        self:EmitSound(painSound)
    end
end

function ENT:OnTakeDamage(dmgInfo)
    self.lastHealth = self.health
    self.health = self.health - dmgInfo:GetDamage()

    if (self.health <= 0) then
        self:die(dmgInfo)
    else
        local pilot = self:GetPilot()
        if (IsValid(pilot)) then
            pilot:SetHealth(self.health)
        end
        self:DoDamageSound()
    end
end

function ENT:OnRemove()
    self:DisableSpotlight()
    self:RemoveDamageSmoke()
    self:EjectPilot()
end
