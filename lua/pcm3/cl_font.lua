
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// cl_font.lua - CLIENTSIDE - Loads fonts system

local M = PCMod3.CreateModule( "Font" )

M.Fonts = {}

local function StringUp( ... )
	return string.lower( "font_" .. table.concat( { ... }, "_" ) )
end

function M.CacheFont( fontname, size, weight, aa, it )
	fontname = fontname or "Verdana"
	size = size or 16
	weight = weight or 400
	aa = aa or false
	it = it or false
	local name = StringUp( fontname, tostring( size ), tostring( weight ), tostring( aa ), tostring( it ) )
	if (M.Fonts[ name ]) then return name end
	surface.CreateFont( fontname, size, weight, aa, it, name )
	M.Fonts[ name ] = true
	return name
end

function M.Get( fontname, size, weight, aa, it )
	return M.CacheFont( fontname, size, weight, aa, it )
end