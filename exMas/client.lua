 ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local created_object = nil

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000)
      if exMas.Weather then
        SetWeatherTypePersist("XMAS")
        SetWeatherTypeNowPersist("XMAS")
        SetWeatherTypeNow("XMAS")
        SetOverrideWeather("XMAS")
      end 
    end
end)

-----------------------------------< GIFT >-----------------------------------

if exMas.Gift then
  CreateThread(function()
    while true do
      wait = exMas.GiftTime
      Citizen.Wait(wait)
      ESX.ShowNotification('Cadeau DROP')
      DeleteObject(created_object)
      SetProps()
    end
  end)
end

local object_model = 'prop_drop_armscrate_01b'
SetProps = function()
  Citizen.CreateThread(function()
        RequestModel(object_model)
    	local iter_for_request = 1
    	while not HasModelLoaded(object_model) and iter_for_request < 5 do
    		Citizen.Wait(500)				
            iter_for_request = iter_for_request + 1
        end
    	if not HasModelLoaded(object_model) then
    		SetModelAsNoLongerNeeded(object_model)
    	else
        local pos = exMas.GiftPos[math.random(#exMas.GiftPos)]
          created_object = CreateObjectNoOffset(object_model, pos.x, pos.y, pos.z-1, 1, 0, 1)
          PlaceObjectOnGroundProperly(created_object)
          FreezeEntityPosition(created_object,true)
          SetModelAsNoLongerNeeded(object_model)
      end
  end)
end

OpenGift = function()
  DeleteObject(created_object)
  local gift = exMas.GiftItem[math.random(#exMas.GiftItem)]
  TriggerServerEvent('exMas:TakeGift', gift)
  local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
	ESX.Streaming.RequestAnimDict(dict)
	TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
end

Keys.Register("E", "E", "Cadeaux Noël", function()
  for index, objects in ipairs (exMas.Object) do
      local c = GetEntityCoords(PlayerPedId())
      local getClosestObjects = GetClosestObjectOfType(c.x, c.y, c.z, 0.7, GetHashKey(objects), true, true, true)
      if getClosestObjects ~= 0 then
          OpenGift()
      end
  end
end)


-----------------------------------< SNOWBALL >-----------------------------------

if exMas.Snowball then
  Keys.Register("R", "R", "Boule de Neige", function()
    RequestAnimDict('anim@mp_snowball') -- pre-load the animation
      if not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then -- check if the snowball should be picked up
          TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0) -- pickup the snowball
          Citizen.Wait(1950) -- wait 1.95 seconds to prevent spam clicking and getting a lot of snowballs without waiting for animatin to finish.
          GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true) -- get 2 snowballs each time.
      end
  end)
end

-----------------------------------< VET >-----------------------------------

RegisterNetEvent('exMas:Vet')
AddEventHandler('exMas:Vet', function(type, value, type2, value2)
  TriggerEvent("skinchanger:change", type, value)
  TriggerEvent("skinchanger:change", type2, value2)
end)
