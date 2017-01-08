
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// sv_wire.lua - SERVERSIDE - Loads the wire functionality

// Note: This file is not related to wiremod in any way

local obj = PCMod3.CreateBase( "connection" )

function obj:New( entA, entB, typ )
	table.insert( entA.Wires, self )
	table.insert( entB.Wires, self )
	self.entA = entA
	self.entB = entB
	self.WireType = typ
end
