
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// sh_settings.lua - SHARED - Loads settings functionality

local M = PCMod3.CreateModule( "Settings" )

function M.DecompileTable( tbl )
	local tmp = {}
	for k, v in pairs( tbl ) do
		if (v == "true") then
			tmp[k] = true
		elseif (v == "false") then
			tmp[k] = false
		else
			local fchar = string.Left( v, 1 )
			local lchar = string.Right( v, 1 )
			if (fchar == "\"") && (lchar == "\"") then
				tmp[k] = string.sub( v, 2, string.len( v ) - 1 )
			else
				local val = tonumber( v )
				if (val) then
					tmp[k] = val
				else
					ErrPCM( "Unable to decompile key '" .. k .. "' (" .. k .. " = " .. v .. ")" )
				end
			end
		end
	end
	return tmp
end

function M.CompileTable( tbl )
	local tmp = {}
	for k, v in pairs( tbl ) do
		local t = type( v )
		if (t == "string") then
			tmp[k] = "\"" .. v .. "\""
		elseif (t == "number") then
			tmp[k] = tostring( v )
		elseif (t == "boolean") then
			tmp[k] = (v and "true") or "false"
		else
			ErrPCM( "Unable to compile key '" .. key .. "' (" .. k .. " = " .. tostring( v ) .. ") (" .. t .. ")" )
		end
	end
	return tmp
end


function M.Load()
	local filename = "pcmod3/settings.txt"
	local data = file.Read( filename ) or ""
	local rows = string.Explode( "\n", data )
	local tbl = {}
	for i=1, #rows do
		local row = rows[i]
		local split = string.Explode( "=", row )
		local key = split[1]
		local value = split[2]
		if (!key) || (!value) then
			ErrPCM( "Settings file is corrupt! (line " .. i .. " reads '" .. row .. "')" )
		else
			tbl[ key ] = value
		end
	end
	M.Data = M.DecompileTable( tbl )
	MsgPCM( "Settings file loaded!" )
	M.Updated = false
end

function M.Save()
	if (!M.Data) then
		ErrPCM( "No settings data to save!" )
		return
	end
	local filename = "pcmod3/settings.txt"
	local tbl = M.CompileTable( M.Data )
	local rows = {}
	for k, v in pairs( tbl ) do
		table.insert( rows, k .. "=" .. v )
	end
	file.Write( filename, table.concat( rows, "\n" ) )
	MsgPCM( "Settings file saved!" )
	M.Updated = false
end

function M.Get( key )
	if (!M.Data) then M.Load() end
	return M.Data[ key ]
end

function M.Set( key, val )
	if (!M.Data) then M.Load() end
	M.Data[ key ] = val
	M.Updated = true
end

function M.MergeData( dat, overwrite )
	if (!M.Data) then M.Load() end
	for key, value in pairs( dat ) do
		if (!M.Data[ key ]) || overwrite then
			M.Data[ key ] = value
		end
	end
	M.Updated = true
end

function M.ThreeSeconds()
	if (M.Updated) then M.Save() end
end

PCMod3.Timer( "Settings", "ThreeSeconds", 3 )