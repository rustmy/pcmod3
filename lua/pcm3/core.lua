
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// core.lua - SHARED - Loads the core functionality

PCMod3 = {}
PCMod3.Version = "3.00a"
PCMod3.Brand = "Developer"

if (SERVER) then

	AddCSLuaFile( "pcm3/enum.lua" )
	AddCSLuaFile( "pcm3/glua_extend.lua" )
	AddCSLuaFile( "pcm3/util.lua" )
	AddCSLuaFile( "pcm3/logging.lua" )
	AddCSLuaFile( "pcm3/object.lua" )

end

include( "pcm3/enum.lua" )
include( "pcm3/glua_extend.lua" )
include( "pcm3/util.lua" )
include( "pcm3/logging.lua" )
include( "pcm3/object.lua" )

PCMod3.WriteToLog( "Addon is loading..." )

//MsgPCM( "Loading shared files..." )

PCMod3.IncludeInDirectory( "pcm3", "sh_" )
function PCMod3.LoadToolmodes()
	PCMod3.IncludeInDirectory( "pcm3/toolmodes" )
end

if (SERVER) then

	//MsgPCM( "Adding clientside files..." )

	PCMod3.AddInDirectory( "pcm3", "cl_" )
	PCMod3.AddInDirectory( "pcm3", "sh_" )
	PCMod3.AddInDirectory( "pcm3/toolmodes" )
	PCMod3.AddInDirectory( "pcm3/entities" )

	//MsgPCM( "Loading serverside files..." )

	PCMod3.IncludeInDirectory( "pcm3", "sv_" )

	local function cmdReload( ply, com, args )
		if (!ply:IsSuperAdmin()) then return end
		include( "pcm3/core.lua" )
	end
	concommand.Add( "pcm3_reload", cmdReload )

end

if (CLIENT) then

	//MsgPCM( "Loading clientside files..." )

	PCMod3.IncludeInDirectory( "pcm3", "cl_" )

	local function cmdReload( ply, com, args )
		if (!ply:IsSuperAdmin()) then return end
		include( "pcm3/core.lua" )
	end
	concommand.Add( "pcm3_reload_cl", cmdReload )

end

PCMod3.IncludeInDirectory( "pcm3/entities" )
