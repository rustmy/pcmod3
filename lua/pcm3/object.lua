
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// object.lua - SHARED - Loads the object functionality

PCMod3.Factories = {}

local Object = {}
local metaBase = { __index = Object }

PCMod3.NextOID = 1

function Object:IsValid()
	return self._valid
end

function Object:_New( ... )
	self._valid = true
	if (self.New) then self:New( ... ) end
end

function Object:Remove()
	self._valid = false
	if (self.OnRemove) then self:OnRemove() end
end

function Object:AssignUniqueID()
	local id = PCMod3.NextOID
	PCMod3.NextOID = PCMod3.NextOID + 1
	self.UniqueID = id
	return id
end

function Object:Call( name, ... )
	local func = self[ name ]
	if (!func) then
		ErrPCM( "Failed to call function '" .. name .. "' on '" .. self.Classname .. "' (does not exist)" )
		return
	end
	local b, err = pcall( func, self, ... )
	if (!b) then
		ErrPCM( "Failed to call function '" .. name .. "' on '" .. self.Classname .. "' (" .. err .. ")" )
		return
	end
end

function Object:IsWeapon() return false end
function Object:IsPlayer() return false end
function Object:IsVehicle() return false end

function PCMod3.CreateBase( classname, basename )
	local obj = {}
	if (!basename) then
		setmetatable( obj, metaBase )
	else
		local base = PCMod3.Factories[ basename ]
		if (!base) then
			ErrPCM( "Failed to locate base '" .. basename .. "' for factory '" .. classname .. "'" )
			return
		end
		setmetatable( obj, base[1]
	end
	obj.Classname = classname
	obj.BaseClass = base
	local meta = {}
	meta.__index = obj
	local info = { meta, obj }
	PCMod3.Factories[ classname ] = info
	return obj
end

function PCMod3.Create( name, ... )
	local factory = PCMod3.Factories[ name ]
	if (!factory) then
		ErrPCM( "Failed to locate factory by name '" .. name .. "'" )
		return
	end
	local o = {}
	setmetatable( o, factory[1] )
	o:_New( ... )
	return o
end
