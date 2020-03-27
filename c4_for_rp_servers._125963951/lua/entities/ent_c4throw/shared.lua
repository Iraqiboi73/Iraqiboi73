ENT.Type		 	= "anim"
ENT.PrintName		= "C4"
ENT.Author			= "Team Cyan AKA I Like Cereal"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end
