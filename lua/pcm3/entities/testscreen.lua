
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// testscreen.lua - SHARED - Loads the test screen entity

local ENT = {}

ENT.PrintName = "Test Screen"

if (CLIENT) then

	function ENT:Initialize()
		local screen = PCMod3.Create( "screen" )
		screen:SetEntity( self )
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
	
	PCMod3.AddEntLanguage( ENT )

end

PCMod3.RegisterAnimEnt( "pcm3_testscreen", ENT, "pcm3_base" )