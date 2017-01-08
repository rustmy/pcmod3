
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// sh_baseent.lua - SHARED - Loads base entity

local ENT = {}

if (CLIENT) then

	ENT.PrintName = "PCMod 3 Entity"
	ENT.Author = "thomasfn"

	ENT.RenderGroup = RENDERGROUP_OPAQUE

	function ENT:Initialize()
		self.Plugs = {}
	end

	function ENT:Think()
		local tr = LocalPlayer():GetEyeTrace()
		self.Hovered = (tr.Entity == self)
	end

	function ENT:Draw()
		self:DrawModel()
	end

	local vecOrigin = Vector( 0, 0, 0 )
	local angOrigin = Angle( 0, 0, 0 )
	function ENT:CreatePlug( id, offset, ang )
		if (self.Plugs[id]) then self.Plugs[id]:Remove() end
		local ent = ClientsideModel( "models/props_lab/tpplug.mdl" )
		local oldpos = self:GetPos()
		local oldang = self:GetAngles()
		self:SetPos( vecOrigin )
		self:SetAngles( angOrigin )
		ent:SetPos( offset )
		ent:SetAngles( ang )
		ent:SetParent( self )
		self:SetPos( oldpos )
		self:SetAngles( oldang )
		return ent
	end

end

if (SERVER) then

	ENT.Model = "models/error.mdl"

	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self.Processes = {}
		self.Wires = {}
	end

	function ENT:Think()
		for _, v in pairs( self.Processes ) do
			v:Think()
		end
	end

end

PCMod3.RegisterAnimEnt( "pcm3_base", ENT )
