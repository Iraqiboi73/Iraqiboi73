if (SERVER) then
  
	AddCSLuaFile ("shared.lua")
	SWEP.Weight 			= 10
	SWEP.AutoSwitchTo 		= false
	SWEP.AutoSwitchFrom 	= false
end

if (CLIENT) then

	SWEP.PrintName 			= "C4"
	SWEP.Slot 				= 4
	SWEP.SlotPos 			= 1
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV		= 65
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
	SWEP.Category			= "I Like Cereal/Team Cyan SWeps"

	SWEP.IconLetter 		= "O"
	killicon.AddFont("weapon_cs_throwable_c4", "CSKillIcons", SWEP.IconLetter, Color(255, 0, 0, 255))
end

SWEP.Instructions 			= "Throw at something, it goes boom."

SWEP.Author 				= "Team Cyan"
SWEP.Contact 				= ""
SWEP.Purpose 				= ""

SWEP.Spawnable 				= true
SWEP.AdminSpawnable 			= true

SWEP.ViewModel 				= "models/weapons/v_c4.mdl"
SWEP.WorldModel 				= "models/weapons/w_c4.mdl"

SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 1
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= "grenade"

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= -1
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= "none"

SWEP.Primed 				= 0
SWEP.Throw 					= CurTime()
SWEP.PrimaryThrow				= true

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("grenade")
	end
end

function SWEP:Holster()
	self.Primed = 0
	self.Throw = CurTime()

return true
end

function SWEP:Reload()
end

function SWEP:Think()
	if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) and self.PrimaryThrow then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1.15

			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple( 0.35, function()
				self:ThrowFar()
			end)
		end
		
	elseif self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK2) and not self.PrimaryThrow then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1.5

			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple( 0.35, function()
				self:ThrowShort()
			end)
		end
	end
end

function SWEP:ThrowFar()

	if self.Primed != 2 then return end

	local tr = self.Owner:GetEyeTrace()

	if (!SERVER) then return end

	local ent = ents.Create ("ent_c4throw")

			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 1
				v = v + self.Owner:GetRight() * 3
				v = v + self.Owner:GetUp() * 1
			ent:SetPos( v )

	ent.GrenadeOwner = self.Owner
	ent:Spawn()

	local phys = ent:GetPhysicsObject()

	if self.Owner:KeyDown( IN_FORWARD ) then
		self.Force = 3200
	elseif self.Owner:KeyDown( IN_BACK ) then
		self.Force = 2100
	elseif self.Owner:KeyDown( IN_MOVELEFT ) then
		self.Force = 2500
	elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
		self.Force = 2500
	else
		self.Force = 2500
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() *self.Force *1.2 + Vector(0,0,200) )
	phys:AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	timer.Simple(0.6,
	function()

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		else
			self.Primed = 0
			self.Weapon:Remove()
			self.Owner:ConCommand("lastinv")
		end
	end)
end

function SWEP:ThrowShort()

	if self.Primed != 2 then return end

	local tr = self.Owner:GetEyeTrace()

	if (!SERVER) then return end

	local ent = ents.Create ("ent_c4throw")

			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 2
				v = v + self.Owner:GetRight() * 3
				v = v + self.Owner:GetUp() * -3
			ent:SetPos( v )

	ent:SetAngles (Vector(math.random(1,100),math.random(1,100),math.random(1,100)))
	ent.GrenadeOwner = self.Owner
	ent:Spawn()

	local phys = ent:GetPhysicsObject()

	if self.Owner:KeyDown( IN_FORWARD ) then
		self.Force = 1100
	elseif self.Owner:KeyDown( IN_BACK ) then
		self.Force = 300
	elseif self.Owner:KeyDown( IN_MOVELEFT ) then
		self.Force = 700
	elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
		self.Force = 700
	else
		self.Force = 700
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 2 + Vector(0, 0, 0))
	phys:AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	timer.Simple(0.6,
	function()

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		else
			self.Primed = 0
			self.Weapon:Remove()
			self.Owner:ConCommand("lastinv")
		end
	end)
end

function SWEP:PrimaryAttack()

	if self.Throw < CurTime() and self.Primed == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		self.Throw = CurTime() + 1
		self.PrimaryThrow = true
	end
end

function SWEP:SecondaryAttack()

	if self.Throw < CurTime() and self.Primed == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		self.Throw = CurTime() + 1
		self.PrimaryThrow = false
	end
end

function SWEP:Deploy()

	self.Throw = CurTime() + 0.75
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	return true
end


function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)

	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
end