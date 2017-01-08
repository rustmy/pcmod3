
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// cl_screenconfig.lua - CLIENTSIDE - Loads screen configurations

local M = PCMod3.CreateModule( "ScreenConfig" )

function M.GetConfig( name )
	return M.ScreenConfigs[ name ]
end

function M.GetConfigByModel( mdl )
	mdl = string.lower( mdl )
	for name, cfg in pairs( M.ScreenConfigs ) do
		if (string.lower( cfg.ScreenModel ) == mdl) then
			return cfg
		end
	end
end

function M.ModifyConfig( id, name, var )
	if (!id) then
		MsgPCM( "Invalid config ID!" )
		return
	end
	if (!name) then
		MsgPCM( id .. ":" )
		PrintTable( M.GetConfig( id ) )
		return
	end
	if (!var) then
		MsgPCM( id .. "." .. name .. ": " .. tostring( M.GetConfig( id )[ var ] ) )
		return
	end
	local code = "PCMod3.GetConfig( \"" .. id .. "\" )[ \"" .. name .. "\" ] = " .. var
	RunString( code )
	MsgPCM( id .. "." .. name .. " changed to " .. tostring( M.GetConfig( id )[ var ] ) )
end
PCMod3.ConCommand( "ScreenConfig", "ModifyConfig" )

M.ScreenConfigs = {}

local sc

------------------------------------------------------------------------------
-- Lab Monitor (HL2)
------------------------------------------------------------------------------

	sc = {}
	sc.ScreenModel = "models/props_lab/monitor01a.mdl"
	M.ScreenConfigs[ "lab_monitor" ] = sc

	// For 3D 2D Drawing:
	sc.OffsetForward = 11.7
	sc.OffsetUp = 12
	sc.OffsetRight = 9.5
	sc.Resolution = 0.04
	sc.Rotation = Vector( 4.5, 0, 0 )

	// For Screen Drawing:
	sc.RX = 0
	sc.RY = 0
	sc.RW = 480
	sc.RH = 393

	// For Cursor Position Calculation:
	sc.x1 = -9
	sc.x2 = 9
	sc.y1 = 12.5
	sc.y2 = -4
	sc.z = 6.4
	sc.fov = 70

------------------------------------------------------------------------------