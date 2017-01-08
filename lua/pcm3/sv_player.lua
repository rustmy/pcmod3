
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// sv_player.lua - SERVERSIDE - Loads the serverside player functionality

local meta = PCMod3.GetPlayerMetaTable()

function PCMod3.GetEntityLimit( name )
	return PCMod3.Settings.Get( "limit_" .. name )
end

function meta:pcmGetEntCount( name )
	if (!self.pcmECNT) then self.pcmECNT = {} end
	return self.pcmECNT[ name ] or 0
end

function meta:pcmHitLimit( name )
	return self:pcmGetEntCount( name ) >= PCMod3.GetEntityLimit( name )
end

function meta:pcmAddEnt( name )
	if (!self.pcmECNT) then self.pcmECNT = {} end
	self.pcmECNT[ name ] = (self.pcmECNT[ name ] or 0) + 1
end

function meta:pcmRemoveEnt( name )
	if (!self.pcmECNT) then self.pcmECNT = {} end
	self.pcmECNT[ name ] = (self.pcmECNT[ name ] or 0) - 1
end
