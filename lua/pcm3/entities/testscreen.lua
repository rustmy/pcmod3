
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// testscreen.lua - SHARED - Loads the test screen entity

local ENT = {}

ENT.PrintName = "Test Screen"

if (CLIENT) then

	function ENT:Initialize()
		local screen = PCMod3.Create( "screen" )
		screen:SetEntity( self )

		screen.m_pPanel = PCMod3.Create( "basepanel" )
		function screen.m_pPanel:Paint( x, y, w, h )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( x, y, w, h )

			surface.SetDrawColor( 255, 0, 0, 255 )
			surface.DrawRect( 0, 0, 20, 20 )

			surface.SetTextPos( 0, 0 )
			surface.SetFont( "Default" )
			surface.SetTextColor( 255, 255, 255, 255)
			surface.DrawText( "Hello Mr Bobbah" )
		end


		local cfg = PCMod3.ScreenConfig.GetConfigByModel( self:GetModel() )
		if (cfg) then
			screen:SetConfig( cfg )
			self.Screen = screen
		else
			ErrPCM( "Failed to locate config for test screen!" )
		end
	end

	function ENT:Draw()
		self:DrawModel()
		if (self.Screen) then self.Screen:Render() end
	end

end

PCMod3.RegisterAnimEnt( "pcm3_testscreen", ENT, "pcm3_base" )
