
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// glua_extend.lua - SHARED - Extends glua functionality

function math.Mid( a, b, d )
	return (b-a)*d + a
end

function table.Remove( tbl, val )
	for id, obj in pairs( tbl ) do
		if (obj == val) then
			table.remove( tbl, id )
			return
		end
	end
end
