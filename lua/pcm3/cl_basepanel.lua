
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// cl_basepanel.lua - CLIENTSIDE - Loads the base panel object

local obj = PCMod3.CreateBase( "basepanel" )

AccessorFunc( obj, "m_bVisible", "Visible", FORCE_BOOL )
AccessorFunc( obj, "m_pParent", "Parent" )

function obj:New()
	self.m_tChildren = {}
	self.m_pParent = nil
end

function obj:SetParent( p )
	local old = self:GetParent()
	if (old && old:IsValid()) then
		old:RemoveChild( self )
	end
	self.m_pParent = p
	if (p && p:IsValid()) then
		p:AddChild( self )
	end
end

function obj:AddChild( c )
	table.insert( self.m_tChildren, c )
end

function obj:RemoveChild( c )
	for id, pn in pairs( self.m_tChildren ) do
		if (pn == c) then
			table.remove( self.m_tChildren, c )
			return
		end
	end
end

function obj:CallOnChildren( func, ... )
	for i=1, #self.m_tChildren do
		local v = self.m_tChildren[ i ]
		if (v && v:IsValid()) then
			if (v[ func ]) then
				v[ func ]( v, ... )
			end
		end
	end
end

function obj:CallOnChildrenB( func, ... )
	for i=#self.m_tChildren, 1, -1 do
		local v = self.m_tChildren[ i ]
		if (v && v:IsValid()) then
			if (v[ func ]) then
				v[ func ]( v, ... )
			end
		end
	end
end

function obj:CallOnParent( func, ... )
	local p = self:GetParent()
	if (p && p:IsValid() && p[ func ]) then return p[ func ]( p, ... ) end
end

function obj:BringToFront()
	// Get our parent's child table
	local p = self:GetParent()
	if not (p && p:IsValid()) then return end
	local c = p.m_tChildren
	if (!c) then return end

	// Find our ID
	local j, f
	for i=1, #c do
		if (c[ i ] == self) then
			f = true
			j = i
			break
		end
	end
	if (!f) then return end

	// Remove us from the table and insert us at the front
	table.remove( c, j )
	table.insert( c, self, 1 )
end

function obj:SetPos( x, y )
	self._X = x
	self._Y = y
end

function obj:GetPos()
	return self._X, self._Y
end

function obj:SetSize( w, h )
	self._W = w
	self._H = h
end

function obj:GetSize()
	return self._W, self._H
end

AccessorFunc( obj, "_W", "Wide", FORCE_NUMBER )
AccessorFunc( obj, "_H", "Tall", FORCE_NUMBER )

function obj:GetBounds()
	return self._X, self._Y, self._W, self._H
end

function obj:Center()
	local w, h = self:GetSize()
	local pw, ph = self:CallOnParent( "GetSize" )
	self:SetPos( (pw*0.5)-(w*0.5), (ph*0.5)-(h*0.5) )
end

function obj:CompletePaint( ox, oy )
	ox = ox or 0
	oy = oy or 0
	local x, y, w, h = self:GetBounds()
	local gx, gy = self:GetGlobalPos()
	self:Paint( x+ox, y+oy, w, h )
	self:CallOnChildrenB( "CompletePaint", x+ox, y+oy )
end

function obj:Paint( x, y, w, h )
	surface.SetDrawColor( 255, 0, 0, 100 )
	surface.DrawRect( x, y, w, h )
end

function obj:GetGlobalPos()
	local x, y = self:GetPos()
	local px, py = self:CallOnParent( "GetGlobalPos" )
	return (px or 0)+x, (py or 0)+y
end
