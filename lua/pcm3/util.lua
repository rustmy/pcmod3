
// ************************************ \\
// * PCMod 3 - thomasfn & bobbahbrown * \\
// ************************************ \\
// util.lua - SHARED - Loads utility functions

function MsgPCM( str )
	MsgN( "[PCMOD3] " .. str )
end

function ErrPCM( str )
	ErrorNoHalt( "[PCMOD3] " .. str .. "\n" )
	PCMod3.WriteToLog( str, "error" )
end

function PCMod3.IncludeInDirectory( dir, prefix, delayed )
	if (delayed) then
		timer.Simple( 0, PCMod3.IncludeInDirectory, dir, prefix )
		return
	end
	local filter = dir .. "/" .. (prefix or "") .. "*"
	local files = file.Find( filter, "LUA" )
	for _, name in pairs( files ) do
		if (name != "..") && (name != ".") then
			//print( "INCLUDING FILE: " .. dir .. "/" .. name )
			local b, err = pcall( include, dir .. "/" .. name )
			if (!b) then
				ErrPCM( "Failed to load file '" .. dir .. "/" .. name .. "' (" .. err .. ")" )
			end
		end
	end
end

function PCMod3.AddInDirectory( dir, prefix )
	if (CLIENT) then return ErrPCM( "Tried to call AddInDirectory on client!" ) end
	local filter = dir .. "/" .. (prefix or "") .. "*"
	local files = file.Find( filter, "LUA" )
	for _, name in pairs( files ) do
		if (name != "..") && (name != ".") then
			AddCSLuaFile( dir .. "/" .. name )
		end
	end
end

function PCMod3.CreateModule( name )
	local mod = {}
	mod._name = name
	mod._class = mod
	mod._hooks = {}
	PCMod3[ name ] = mod
	return mod
end

PCMod3.Hooks = {}

function PCMod3.Hook( modname, hookname )
	local mod = PCMod3[ modname ]
	if (!PCMod3.Hooks[ hookname ]) then
		local o = {}
		o._funcs = {}
		o._func = function( ... )
			for k, v in pairs( o._funcs ) do
				local b, res = pcall( v, ... )
				if (!b) then
					ErrPCM( "Hook '" .. hookname .. "' failed, and was removed." )
					ErrPCM( "Module name: " .. modname )
					ErrPCM( "Error: " .. res )
					o._funcs[ k ] = nil
					return
				end
				if (res != nil) then return res end
			end
		end
		hook.Add( hookname, "PCMod3." .. hookname, o._func )
		PCMod3.Hooks[ hookname ] = o
	end
	local o = PCMod3.Hooks[ hookname ]
	table.insert( o._funcs, mod[ hookname ] )
end

function PCMod3.Timer( modname, timername, delay )
	local func = PCMod3[ modname ][ timername ]
	timer.Create( "PCMod3." .. modname .. "." .. timername, delay, 0, func )
end

function PCMod3.ConCommand( modname, cmdname )
	local func = PCMod3[ modname ][ cmdname ]
	local id = "pcm3_" .. string.lower( cmdname )
	local function CMD( ply, com, args )
		if (CLIENT) then
			local b, res = pcall( func, unpack( args ) )
			if (!b) then
				ErrPCM( "Concommand '" .. cmdname .. "' failed." )
				ErrPCM( "Module name: " .. modname )
				ErrPCM( "Concommand name: " .. id )
				ErrPCM( "Error: " .. res )
			end
		end
		if (SERVER) then
			local b, res = pcall( func, ply, unpack( args ) )
			if (!b) then
				ErrPCM( "Concommand '" .. cmdname .. "' failed." )
				ErrPCM( "Module name: " .. modname )
				ErrPCM( "Concommand name: " .. id )
				ErrPCM( "Error: " .. res )
			end
		end
	end
	concommand.Add( id, CMD )
end

if (CLIENT) then

	function PCMod3.AddEntLanguage( ent )
		local class = ent.Classname
		local name = ent.PrintName
		language.Add( "#Undone." .. class, "Undone " .. name .. "!" )
	end

end

function PCMod3.RegisterAnimEnt( name, tbl, basename )
	local o = {}
	table.Merge( o, tbl )
	o.Classname = name
	o.Base = basename or "base_anim"
	o.Type = "anim"
	scripted_ents.Register( o, name, true )
	MsgPCM( "Registered anim entity '" .. name .. "'" )
	if (CLIENT) then
		PCMod3.AddEntLanguage( o )
	end
end

PCMod3.Stools = {}

function PCMod3.CreateSTool( name )
	name = "pcm3_" .. name
	local sweps = weapons.GetList()
	for _, obj in pairs( sweps ) do
		if (obj.ClassName == "gmod_tool") then
			local toolobj
			for _, tool in pairs( obj.Tool ) do
				toolobj = getmetatable( tool )
			end
			if (!toolobj) then
				ErrPCM( "Failed to locate ToolObj meta table!" )
				return
			end
			local o = toolobj:Create()
			o.Mode = name
			o.Tab = "PCMod 3"
			o.AddToMenu = true
			o.Command = nil
			o.ConfigName = ""
			if (CLIENT) then
				function o:SetInfo( property, value )
					RunConsoleCommand( name .. "_" .. property, value )
				end
				function o:GetInfo( property )
					return GetConVarString( name .. "_" .. property )
				end
			end
			function o:Finialize()
				self:CreateConVars()
				if (CLIENT) then
					local pf = "Tool." .. name .. "."
					language.Add( pf .. "name", self.Name )
					language.Add( pf .. "desc", self.Desc )

					if (self.Inst) then
						for k, v in pairs( self.Inst ) do
							local s = ""
							if (v[1]) then s = s .. "Primary: " .. v[1] end
							if (v[2]) then s = s .. "   Secondary: " .. v[2] end
							if (v[3]) then s = s .. "   Reload: " .. v[3] end
							language.Add( pf .. tostring( k-1 ), s )
						end
					end

				end
			end
			obj.Tool[ name ] = o
			PCMod3.Stools[ name ] = o
			MsgPCM( "Created STool '" .. name .. "'" )
			return o
		end
	end
	ErrPCM( "Failed to locate toolgun swep!" )
end

function PCMod3.ImplementSToolGhost( TOOL )
	function TOOL:Think()
		local mdl = self:GetClientInfo( "model" )
		if (!mdl) then return end
		if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
			self:MakeGhostEntity( mdl, Vector(0,0,0), Angle(0,0,0) )
		end
		self:UpdateGhost( self.GhostEntity, self:GetOwner() )
	end

	function TOOL:UpdateGhost( ent, ply )

		if ( !ent || !ent:IsValid() ) then return end

		local tr 	= util.GetPlayerTrace( ply, ply:GetAimVector() )
		local trace 	= util.TraceLine( tr )

		if (!trace.Hit || trace.Entity:IsPlayer() || trace.Entity:GetClass() == self.EntClass ) then
			ent:SetNoDraw( true )
			return
		end

		local Ang = trace.HitNormal:Angle()
		Ang.pitch = Ang.pitch + 90
		ent:SetAngles( Ang )

		local min = ent:OBBMins()
		ent:SetPos( trace.HitPos - trace.HitNormal * min.z )

		ent:SetNoDraw( false )

	end
end

PCMod3.SpawnableEnts = {}

function PCMod3.RegisterSpawnableEnt( ent )
	table.insert( PCMod3.SpawnableEnts, ent )
end

function PCMod3.GetPlayerMetaTable()
	return FindMetaTable( "Player" )
end

weapons.OldRegister = weapons.OldRegister or weapons.Register

function weapons.Register( tbl, name, b )
	weapons.OldRegister( tbl, name, b )
	if (name == "gmod_tool") then PCMod3.LoadToolmodes() end
end
