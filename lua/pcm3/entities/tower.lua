
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// tower.lua - SHARED - Loads the tower entity

local ENT = {}

ENT.PrintName = "Tower"

if (CLIENT) then

	function ENT:Initialize()

	end

	function ENT:Draw()
		self:DrawModel()
	end

end

PCMod3.RegisterAnimEnt( "pcm3_tower", ENT, "pcm3_base" )
