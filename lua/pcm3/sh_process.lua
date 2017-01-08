
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// sh_process.lua - SHARED - Loads settings functionality

local obj = PCMod3.CreateBase( "process" )

function obj:New( ent )
	self.m_eEntity = ent
	table.insert( ent.Processes, self )
end

function obj:OnRemove()
	local ent = self.m_eEntity
	if (!ValidEntity( ent )) then return end
	table.Remove( ent.Processes, self )
end

function obj:Think()
	
end

if (SERVER) then

	function obj:Manifest()
		
	end

end

if (CLIENT) then

	function obj:Update( um )
		
	end

end