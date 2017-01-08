
// ******************** \\
// * PCMod 3 - thomasfn * \\
// ******************** \\
// entspawn.lua - SHARED - Loads entity spawner STool

local TOOL = PCMod3.CreateSTool( "entspawn" )

PCMod3.ImplementSToolGhost( TOOL )

TOOL.Category = "Hardware"
TOOL.Name = "Object Spawner"
TOOL.Desc = "Spawns computer hardware"

TOOL.ClientConVar.entclass = "testscreen"
TOOL.ClientConVar.model = "models/props_lab/monitor01a.mdl"

TOOL.Inst = {
	{ "Spawn the object" }
}

local tblCParts = {
	{ 	Name = "Test Screen",
		Class = "testscreen",
		Models = { "models/props_lab/monitor01a.mdl" }
	},
	{ 	Name = "Computer Tower",
		Class = "tower",
		Models = { "models/props_lab/harddrive02.mdl" }
	}
}

function TOOL:LeftClick( tr )
	if (CLIENT) then return end
	
	local class = self:GetClientInfo( "entclass" )
	
	if (!tr.Hit || tr.Entity:IsPlayer() || tr.Entity:GetClass() == class ) then return false end
	
	local ply = self:GetOwner()
	local ang =  tr.HitNormal:Angle()
	local norm = tr.HitNormal
	ang.pitch = ang.pitch + 90
	local pos =  tr.HitPos
	local model = self:GetClientInfo( "model" )
	
	if (ply:pcmHitLimit( class )) then
		ply:ChatPrint( "You have reached the limit!" )
		return false
	end
	
	local ent = ents.Create( "pcm3_" .. class )
	if (!ValidEntity( ent )) then
		ErrPCM( "Failed to create entity by class 'pcm_" .. class .. "'" )
		return false
	end
	
	ent:SetAngles( ang )	
	ent:SetPos( pos )
	ent:SetModel( model )
	ent:Spawn()
	
	local min = ent:OBBMins()
	ent:SetPos( pos - (norm * min.z) )
	
	ply:pcmAddEnt( class )
	
	local function Remove()
		if (!ValidEntity( ply )) then return end
		ply:pcmRemoveEnt( class )
	end
	ent:CallOnRemove( "pcmHandleLimit", Remove )
	
	undo.Create( "pcm3_" .. class )
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
	return true
	
end

function TOOL:RightClick( tr )
	
end

if (CLIENT) then

	local function BuildEntityPanel( name, data, mdlselect )
		local pn = vgui.Create( "DCollapsibleCategory" )
		//pn:SetExpanded( 0 )
		pn:SetLabel( name )
		
		local pnE = vgui.Create( "DPanelList" )
		pnE:SetAutoSize( true )
		pnE:SetSpacing( 1 )
		pnE:SetPadding( 3 )
		pnE:EnableHorizontal( false )
		pnE:EnableVerticalScrollbar( false )
		
		pn:SetContents( pnE )
		
		for _, item in pairs( data ) do
			local item = item
			local btn = vgui.Create( "DButton" )
			btn:SetText( item.Name )
			function btn:DoClick()
				TOOL:SetInfo( "entclass", item.Class )
				mdlselect:Update( item, 1 )
			end
			pnE:AddItem( btn )
		end
		
		return pn
	end

	local function BuildModelPanel()
		local pn = vgui.Create( "DCollapsibleCategory" )
		//pn:SetExpanded( 0 )
		pn:SetLabel( "Model" )
		
		local pnE = vgui.Create( "DPanelList" )
		pnE:SetAutoSize( true )
		pnE:SetSpacing( 1 )
		pnE:SetPadding( 3 )
		pnE:EnableHorizontal( false )
		pnE:EnableVerticalScrollbar( false )
		
		pn:SetContents( pnE )
		
		function pn:Update( data, default )
			pn:SetLabel( "Model - " .. data.Name )
			pnE:Clear()
			for _, item in pairs( data.Models ) do
				local item = item
				local btn = vgui.Create( "SpawnIcon" )
				btn:SetModel( item )
				function btn:DoClick()
					TOOL:SetInfo( "model", item )
				end
				pnE:AddItem( btn )
			end
			self:GetParent():InvalidateLayout( true )
			if (default) then TOOL:SetInfo( "model", data.Models[ default ] ) end
		end
		
		return pn
	end

	function TOOL.BuildCPanel( panel )
		local pnModelSelect = BuildModelPanel()

		panel:AddItem( BuildEntityPanel( "Computer Parts", tblCParts, pnModelSelect ) )
		
		panel:AddItem( pnModelSelect )
		
		for _, item in pairs( tblCParts ) do
			if (item.Class == TOOL:GetInfo( "entclass" )) then
				pnModelSelect:Update( item )
				break
			end
		end
	end
	
end

TOOL:Finialize()