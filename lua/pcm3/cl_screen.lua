
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// cl_screen.lua - CLIENTSIDE - Loads the screen object

local M = PCMod3.CreateModule( "Screen" )
local obj = PCMod3.CreateBase( "screen" )

M.Screens = {}

function M:CallOnAll( funcname, ... )
	for _, o in pairs( M.Screens ) do
		o:Call( funcname, ... )
	end
end

function obj:New()
	table.insert( M.Screens, self )
	self.m_pPanel = PCMod3.Create( "basepanel" )
	function self.m_pPanel:Paint( x, y, w, h )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( x, y, w, h )
	end
end

function obj:SetConfig( cfg )
	self.m_tConfig = cfg
	self:PerformLayout()
end

function obj:SetEntity( ent )
	self.m_eEntity = ent
end

function obj:GetConfig()
	return self.m_tConfig
end

function obj:GetDrawBounds()
	local cfg = self:GetConfig()
	if (!cfg) then return 0, 0, 0, 0 end
	return cfg.RX, cfg.RY, cfg.RW, cfg.RH
end

function obj:PerformLayout()
	local x, y, w, h = self:GetDrawBounds()
	self.m_pPanel:SetPos( x, y )
	self.m_pPanel:SetSize( w, h )
end

function obj:OnRemove()
	if (self.m_pPanel && self.m_pPanel:IsValid()) then
		self.m_pPanel:Remove()
		self.m_pPanel = nil
	end
end

local baserotate = Vector( -90, 90, 0 )
function obj:Render()
	local cfg = self.m_tConfig
	if (!cfg) then
		ErrPCM( "Screen failed to render! (No config)" )
		return
	end
	local ent = self.m_eEntity
	if (!ent) then
		ErrPCM( "Screen failed to render! (No entity)" )
		return
	end
	local origin, ang = ent:GetPos(), ent:GetAngles()
	local drawpos = origin + (ent:GetForward() * cfg.OffsetForward) + (ent:GetUp() * cfg.OffsetUp) + (ent:GetRight() * cfg.OffsetRight)
	local rot = baserotate + cfg.Rotation
	ang:RotateAroundAxis( ang:Right(), rot.x )
	ang:RotateAroundAxis( ang:Up(), rot.y )
	ang:RotateAroundAxis( ang:Forward(), rot.z )
	cam.Start3D2D( drawpos, ang, cfg.Resolution )
		self:Draw()
	cam.End3D2D()
end

function obj:Draw()
	local pn = self.m_pPanel
	if (!pn) then
		ErrPCM( "Screen failed to draw! (No panel)" )
		return
	end
	pn:CompletePaint()
end

function obj:InvalidateLayout()
	local pn = self.m_pPanel
	if (!pn) then
		ErrPCM( "Screen failed to layout! (No panel)" )
		return
	end
	pn:CompleteLayout()
end