
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// pcm3.lua - SHARED - Loads the addon

PCMOD3_LOADING = true

MsgN( "------------" )
MsgN( "PCMod 3 loading..." )

if (SERVER) then

	AddCSLuaFile( "autorun/pcm3.lua" )
	AddCSLuaFile( "pcm3/core.lua" )

	include( "pcm3/core.lua" )

end

if (CLIENT) then

	include( "pcm3/core.lua" )

end

MsgN( "------------" )

PCMOD3_LOADING = false
