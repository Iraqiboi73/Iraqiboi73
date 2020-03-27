
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel("models/weapons/w_c4.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetNetworkedString("Owner", "World")
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.timer = CurTime() + 3
end

local exp

function ENT:Think()
	if self.timer < CurTime() then

	self:Explosion()
	self.Entity:Remove()
	end
end

function ENT:HitEffect()
	for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 600)) do
		if v:IsValid() && v:IsPlayer() then
		end	
	end
end

function ENT:Explosion()

	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect("Explosion", effectdata)
	
	local explo = ents.Create("env_explosion")
		explo:SetOwner(self.GrenadeOwner)
		explo:SetPos(self.Entity:GetPos())
		explo:SetKeyValue("iMagnitude", "150")
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode", "", 0)
	
	
	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")
		shake:SetKeyValue("radius", "900")
		shake:SetKeyValue("duration", "2.5")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
	
	local ar2Explo = ents.Create("env_ar2explosion")
		ar2Explo:SetOwner(self.GrenadeOwner)
		ar2Explo:SetPos(self.Entity:GetPos())
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire("Explode", "", 0)

	for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 250)) do
		v:Fire("EnableMotion", "", math.random(0, 0.5))
	end
	
end

function ENT:OnTakeDamage(dmginfo)
end

function ENT:Use(activator, caller, type, value)
end

function ENT:StartTouch(entity)
end

function ENT:EndTouch(entity)
end

function ENT:Touch(entity)
end