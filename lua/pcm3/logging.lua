
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// logging.lua - SHARED - Loads logging functions

function PCMod3.WriteToLog( str, id )
	id = id or "general"
	if (SERVER) then id = "sv_" .. id end
	local filename = "pcmod3/logs/" .. id .. ".txt"
	local content = file.Read( filename ) or ("Log created at " .. os.date())
	local line = "[" .. os.date() .. "] " .. str
	content = content .. "\n" .. line
	file.Write( filename, content )
end