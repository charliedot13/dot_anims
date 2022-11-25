Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)

        -- -- Pianoooos ===============================================================================================
        -- for k, v in pairs(Pianos) do
        --     if (IsPlayerNearCoords(v.coords) < 1.5) then
        --         if not play then 
        --             TriggerEvent("vorp:Tip", "Pulsa G para tocar el piano.", 100)
        --         end 
        --         if IsControlJustPressed(0, 0x760A9C6F) then
        --             play = true
        --             if IsPedMale(PlayerPedId()) then
        --                 TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_PIANO'), v.animCoords.x, v.animCoords.y, v.animCoords.z, v.animHeading, 0, true, true, 0, true)
        --             else
        --                 TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_ABIGAIL_PIANO'), v.animCoords.x, v.animCoords.y, v.animCoords.z, v.animHeading, 0, true, true, 0, true)
        --             end
        --         end
        --     end
        -- end

        -- if play then
        --     TriggerEvent("vorp:TipBottom", "Pulsa W para dejar de tocar.", 100)
        --     if IsControlJustPressed(0, 0x8FD015D8) then
        --         play = false
        --         ClearPedTasks(GetPlayerPed())
        --         --SetCurrentPedWeapon(GetPlayerPed(), -1569615261, true)
        --     end    
        -- end

        -- Animaciones ===============================================================================================
        if IsControlPressed(0, 0xCEE12B50) then -- Bloq mayus
            WarMenu.OpenMenu('Anim')
        elseif IsControlJustPressed(0, 0xA65EBAB4) then
			ClearPedTasks(PlayerPedId())
        end

        --------------------------------------------------------------------------------------------------------------
        -- Handsup
        if (IsControlJustPressed(0, 0x8CC9CD42)) then -- X
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
                RequestAnimDict( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" )
                while ( not HasAnimDictLoaded( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" ) ) do 
                    Citizen.Wait( 100 )
                end
                if IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
                    ClearPedSecondaryTask(ped)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), false) -- des unarm player
                else
                    TaskPlayAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3.0, -3.0, 120000, 31, 0, true, 0, false, 0, false)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true) -- unarm player
                end
            end
        end

        -- Sign
        if (IsControlJustPressed(0, 0x760A9C6F)) then -- G
            local ped = PlayerPedId()
            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
                RequestAnimDict( "mech_loco_m@generic@reaction@pointing@unarmed@stand" )
                while ( not HasAnimDictLoaded( "mech_loco_m@generic@reaction@pointing@unarmed@stand" ) ) do 
                    Citizen.Wait( 100 )
                end
                if IsEntityPlayingAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 3) then
                    ClearPedSecondaryTask(ped)
                else
                    TaskPlayAnim(ped, "mech_loco_m@generic@reaction@pointing@unarmed@stand", "point_fwd_0", 1.0, 8.0, 1500, 31, 0, true, 0, false, 0, false)
                end
            end
        end
    end
end)


RegisterNetEvent('dot_anims:openMenu')
AddEventHandler('dot_anims:openMenu', function()
    WarMenu.OpenMenu('Anim')
end)


function IsPlayerNearCoords(x, y, z)
    local pCoords = GetEntityCoords(PlayerPedId())
    return Vdist(pCoords, x, y, z)
end


Citizen.CreateThread(function()

	local sexe =  IsPedMale(PlayerPedId())

	WarMenu.CreateMenu('Anim', 'Acciones')
	WarMenu.CreateSubMenu('Choix', 'Anim', 'Expresiones')
	WarMenu.CreateSubMenu('Select', 'Anim', 'Animaciones')
	WarMenu.CreateSubMenu('Faire', 'Anim', 'Animationfille')
	WarMenu.CreateSubMenu('Brosse', 'Anim', 'Limpieza')

	while true do
		Citizen.Wait(0)
		if WarMenu.IsMenuOpened('Anim') then
			if WarMenu.MenuButton('Emote', 'Choix') then end
			if sexe == 1 then WarMenu.MenuButton('Animaciones', 'Select') 
			else WarMenu.MenuButton('Animationfille', 'Faire') end
			if WarMenu.MenuButton('Limpieza', 'Brosse') then end
			
			WarMenu.Display()

			elseif WarMenu.IsMenuOpened('Choix') then
				for i = 1, #Emote do
					if WarMenu.Button(Emote[i]['Text']) then
						Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 0,Emote[i]['HashEmote'], 1, 1, 0, 0)
					end					
				end
			WarMenu.Display()
			
			elseif WarMenu.IsMenuOpened('Select') then
				if WarMenu.Button('Parar animación') then
					ClearPedTasks(PlayerPedId())
				end
				for j = 1, #Animation do
					if WarMenu.Button(Animation[j]['Text']) then
						TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(Animation[j]['hashAnim']), -1, true, false, false, false)
					end
				end
			WarMenu.Display()
			
		elseif WarMenu.IsMenuOpened('Faire') then
			if WarMenu.Button('Stop') then
				ClearPedTasks(PlayerPedId())
			end
			for j = 1, #Animationfille do
				if WarMenu.Button(Animationfille[j]['Text']) then
					TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(Animation[j]['hashAnim']), -1, true, false, false, false)
				end
			end
			WarMenu.Display()
		-- WarMenu.Display()
		
        elseif WarMenu.IsMenuOpened('Brosse') then
            -- if WarMenu.Button('Cepillar el caballo') then
            --     local player = PlayerPedId()
            --     local currenthorse = GetMount(player)
            --     ClearPedEnvDirt(currenthorse)
            --     TaskDismountAnimal(player, 1, 0, 0, 0, 0)
            --     Wait(3000)
            --     local dict = "amb_work@world_human_horse_tend_brush_link@paired@male_a@idle_c"
            --     RequestAnimDict(dict)
            --     TaskPlayAnim(PlayerPedId(), dict, "idle_h", 1.0, 8.0, -1, 1, 0, false, false, false)
            --     Wait(10000)
            --     ClearPedTasks(PlayerPedId())

        if WarMenu.Button('Lavarse') then
            local player = PlayerPedId()
            local player2 = PlayerPedId()
            local player3 = PlayerPedId()
            local player4 = PlayerPedId()
            ClearPedEnvDirt(player)
            ClearPedBloodDamage(player2)
            ClearPedWetness(player3)
            ClearPedDamageDecalByZone(player4)
            Wait(3000)
            ClearPedTasks(PlayerPedId())        
        end
        WarMenu.Display()

        end	
	end
end)


RegisterCommand('cancel', function()
    ClearPedTasks(PlayerPedId())
end)

RegisterCommand('fcancel', function()
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterCommand('e', function(src, args)
    if args[1] ~= nil then
        args = table.concat(args, ' ')
        args = string.lower(args)
        for k, v in pairs(Animation) do
            if string.lower(v['Text']) == args then
                TaskStartScenarioInPlace(PlayerPedId(), GetHashKey(Animation[k]['hashAnim']), -1, true, false, false, false)
            end
        end
    end
end)


function GetDistance3D(coords, coords2)
	return #(coords - coords2)
end

GetClosestPlayer = function(coords)
    local players         = GetPlayers()
    local closestDistance = 5
    local closestPlayer   = -1
    local coords          = coords
    local usePlayerPed    = false
    local playerPed       = PlayerPedId()
    local playerId        = PlayerId()


    if coords == nil then
        usePlayerPed = true
        coords       = GetEntityCoords(playerPed)
    end

    for i=1, #players, 1 do
        local target = GetPlayerPed(players[i])
    --  print(target)

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
            local targetCoords = GetEntityCoords(target)
            local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

            if closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
        --  print(i)
            table.insert(players, i)
        end
    end

    return players
end

-- Citizen.CreateThread(function() -- Hands up emote
--     while true do
--         Citizen.Wait(0)
--         if (IsControlJustPressed(0, 0x8CC9CD42))  then
--             local ped = PlayerPedId()
--             if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
    
--                 RequestAnimDict( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" )
    
--                 while ( not HasAnimDictLoaded( "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs" ) ) do 
--                     Citizen.Wait( 100 )
--                 end
    
--                 if IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
--                     ClearPedSecondaryTask(ped)
--                 else
--                     TaskPlayAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 8.0, -8.0, 120000, 31, 0, true, 0, false, 0, false)
--                 end
--             end
--         end
--     end
-- end)


-- TaskStartScenarioAtPosition(GetPlayerPed(), GetHashKey('PROP_HUMAN_PIANO'), -312.22 - 0.08, 799.01, 118.43 + 0.03, 102.37, 0, true, true, 0, true) (PIANO)
