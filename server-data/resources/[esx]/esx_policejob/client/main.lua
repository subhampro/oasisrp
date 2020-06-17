local Keys = {
  ["ESC"] = 322,
  ["F1"] = 288,
  ["F2"] = 289,
  ["F3"] = 170,
  ["F5"] = 166,
  ["F6"] = 167,
  ["F7"] = 168,
  ["F8"] = 169,
  ["F9"] = 56,
  ["F10"] = 57,
  ["~"] = 243,
  ["1"] = 157,
  ["2"] = 158,
  ["3"] = 160,
  ["4"] = 164,
  ["5"] = 165,
  ["6"] = 159,
  ["7"] = 161,
  ["8"] = 162,
  ["9"] = 163,
  ["-"] = 84,
  ["="] = 83,
  ["BACKSPACE"] = 177,
  ["TAB"] = 37,
  ["Q"] = 44,
  ["W"] = 32,
  ["E"] = 38,
  ["R"] = 45,
  ["T"] = 245,
  ["Y"] = 246,
  ["U"] = 303,
  ["P"] = 199,
  ["["] = 39,
  ["]"] = 40,
  ["ENTER"] = 18,
  ["CAPS"] = 137,
  ["A"] = 34,
  ["S"] = 8,
  ["D"] = 9,
  ["F"] = 23,
  ["G"] = 47,
  ["H"] = 74,
  ["K"] = 311,
  ["L"] = 182,
  ["LEFTSHIFT"] = 21,
  ["Z"] = 20,
  ["X"] = 73,
  ["C"] = 26,
  ["V"] = 0,
  ["B"] = 29,
  ["N"] = 249,
  ["M"] = 244,
  [","] = 82,
  ["."] = 81,
  ["LEFTCTRL"] = 36,
  ["LEFTALT"] = 19,
  ["SPACE"] = 22,
  ["RIGHTCTRL"] = 70,
  ["HOME"] = 213,
  ["PAGEUP"] = 10,
  ["PAGEDOWN"] = 11,
  ["DELETE"] = 178,
  ["LEFT"] = 174,
  ["RIGHT"] = 175,
  ["TOP"] = 27,
  ["DOWN"] = 173,
  ["NENTER"] = 201,
  ["N4"] = 108,
  ["N5"] = 60,
  ["N6"] = 107,
  ["N+"] = 96,
  ["N-"] = 97,
  ["N7"] = 117,
  ["N8"] = 61,
  ["N9"] = 118
}

local PlayerData = {}
local GUI = {}
local HasAlreadyEnteredMarker = false
local LastStation = nil
local LastPart = nil
local LastPartNum = nil
local LastEntity = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local IsHandcuffed = false
local HandcuffTimer = {}
local DragStatus = {}
DragStatus.IsDragged = false
DragStatus.draganim = false
local IsShackles = false
local CopPed = 0

ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine = 2,
    modBrakes = 2,
    modTransmission = 2,
    modSuspension = 3,
    modTurbo = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenCloakroomMenu()

  local elements = {
    { label = _U('citizen_wear'), value = 'citizen_wear' }
  }

  if PlayerData.job.grade_name == 'recruit' then
    table.insert(elements, { label = _U('kortnorm_wear'), value = 'kortnorm_wear' })
	table.insert(elements, { label = _U('motor_wear'), value = 'motor_wear' })
	table.insert(elements, { label = _U('langnorm_wear'), value = 'langnorm_wear' })
	table.insert(elements, { label = _U('unmkort_wear'), value = 'unmkort_wear' })
	table.insert(elements, { label = _U('unmlang_wear'), value = 'unmlang_wear' })
  end

  if PlayerData.job.grade_name == 'officer' then
    table.insert(elements, { label = _U('kortnorm_wear'), value = 'kortnorm_wear' })
	table.insert(elements, { label = _U('motor_wear'), value = 'motor_wear' })
	table.insert(elements, { label = _U('langnorm_wear'), value = 'langnorm_wear' })
	table.insert(elements, { label = _U('unmkort_wear'), value = 'unmkort_wear' })
	table.insert(elements, { label = _U('unmlang_wear'), value = 'unmlang_wear' })
  end

  if PlayerData.job.grade_name == 'sergeant' then
    table.insert(elements, { label = _U('kortnorm_wear'), value = 'kortnorm_wear' })
	table.insert(elements, { label = _U('motor_wear'), value = 'motor_wear' })
	table.insert(elements, { label = _U('langnorm_wear'), value = 'langnorm_wear' })
	table.insert(elements, { label = _U('unmkort_wear'), value = 'unmkort_wear' })
	table.insert(elements, { label = _U('unmlang_wear'), value = 'unmlang_wear' })
  end

  if PlayerData.job.grade_name == 'lieutenant' then
    table.insert(elements, { label = _U('kortnorm_wear'), value = 'kortnorm_wear' })
	table.insert(elements, { label = _U('motor_wear'), value = 'motor_wear' })
	table.insert(elements, { label = _U('langnorm_wear'), value = 'langnorm_wear' })
	table.insert(elements, { label = _U('unmkort_wear'), value = 'unmkort_wear' })
	table.insert(elements, { label = _U('unmlang_wear'), value = 'unmlang_wear' })
  end

  if PlayerData.job.grade_name == 'boss' then
    table.insert(elements, { label = _U('kortnorm_wear'), value = 'kortnorm_wear' })
	table.insert(elements, { label = _U('motor_wear'), value = 'motor_wear' })
	table.insert(elements, { label = _U('langnorm_wear'), value = 'langnorm_wear' })
	table.insert(elements, { label = _U('unmkort_wear'), value = 'unmkort_wear' })
	table.insert(elements, { label = _U('unmlang_wear'), value = 'unmlang_wear' })

  end

  if Config.EnableNonFreemodePeds then
    table.insert(elements, { label = _U('sheriff_wear'), value = 'sheriff_wear_freemode' })
  end

  table.insert(elements, { label = _U('bullet_wear'), value = 'bullet_wear' })
  table.insert(elements, { label = _U('gilet_wear'), value = 'gilet_wear' })
  table.insert(elements, { label = _U('pbadge_wear'), value = 'pbadge_wear' })
  table.insert(elements, { label = _U('tev_wear'), value = 'tev_wear' })
  table.insert(elements, { label = _U('tevg_wear'), value = 'tevg_wear' })
  table.insert(elements, { label = _U('pet_wear'), value = 'pet_wear' })
  table.insert(elements, { label = _U('helm_wear'), value = 'helm_wear' })

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
    {
      title = _U('cloakroom'),
      align = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = GetHashKey("mp_m_freemode_01")
          else
            model = GetHashKey("mp_f_freemode_01")
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'cadet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 58,
              ['tshirt_2'] = 0,
              ['torso_1'] = 55,
              ['torso_2'] = 0,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 42,
              ['pants_1'] = 25,
              ['pants_2'] = 2,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 44,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'kortnorm_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
            ['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms_1'] = 0,	    ['arms_2'] = 0,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 6,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 41,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 50)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
	  if data.current.value == 'motor_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 122,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms_1'] = 0,	    ['arms_2'] = 0,
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 41,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 75)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'langnorm_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 122,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 30,	
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 7,
              ['decals_2'] = 1,
              ['arms'] = 44,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'unmkort_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 30,
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 7,
              ['decals_2'] = 2,
              ['arms'] = 44,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 50)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'unmlang_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 19,
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 57,  ['tshirt_2'] = 0,
			['torso_1'] = 94,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 10,  ['helmet_2'] = 0,
			['chain_1'] = 6,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
	  if data.current.value == 'pet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
             ['helmet_1'] = 58,  ['helmet_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['helmet_1'] = 58,  ['helmet_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
	  if data.current.value == 'helm_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
             ['helmet_1'] = 17,  ['helmet_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['bproof_1'] = 11,  ['bproof_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'pbadge_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
             ['bproof_1'] = 4,  ['bproof_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['bproof_1'] = 11,  ['bproof_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
	  if data.current.value == 'tev_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
             ['bproof_1'] = 6,  ['bproof_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['bproof_1'] = 11,  ['bproof_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
	  if data.current.value == 'tevg_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
             ['bproof_1'] = 6,  ['bproof_2'] = 3
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['bproof_1'] = 11,  ['bproof_2'] = 2
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end
	  
      if data.current.value == 'bullet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 19,
        ['bproof_1'] = 11,  ['bproof_2'] = 1,
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 7,
              ['decals_2'] = 1,
              ['arms'] = 44,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'gilet_wear' then
        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
        ['torso_1'] = 55,   ['torso_2'] = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms'] = 19,
        ['helmet_1'] = 46,  ['helmet_2'] = 0,
        ['bproof_1'] = 11,  ['bproof_2'] = 1,
        ['pants_1'] = 35,   ['pants_2'] = 0,
        ['shoes_1'] = 12,   ['shoes_2'] = 6,
        ['chain_1'] = 0,    ['chain_2'] = 0,
        ['ears_1'] = 0,     ['ears_2'] = 0
              }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 35,
              ['tshirt_2'] = 0,
              ['torso_1'] = 48,
              ['torso_2'] = 0,
              ['decals_1'] = 7,
              ['decals_2'] = 1,
              ['arms'] = 44,
              ['pants_1'] = 34,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['chain_1'] = 0,
              ['chain_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 100)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      if data.current.value == 'sheriff_wear_freemode' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          if skin.sex == 0 then

            local model = GetHashKey("s_m_y_sheriff_01")

            RequestModel(model)
            while not HasModelLoaded(model) do
              RequestModel(model)
              Citizen.Wait(0)
            end

            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
          else
            local model = GetHashKey("s_f_y_sheriff_01")

            RequestModel(model)
            while not HasModelLoaded(model) do
              RequestModel(model)
              Citizen.Wait(0)
            end

            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
          end
        end)
      end

      if data.current.value == 'lieutenant_wear_freemode' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

          if skin.sex == 0 then
            local model = GetHashKey("s_m_y_swat_01")

            RequestModel(model)
            while not HasModelLoaded(model) do
              RequestModel(model)
              Citizen.Wait(0)
            end

            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
          else
            local model = GetHashKey("s_m_y_swat_01")

            RequestModel(model)
            while not HasModelLoaded(model) do
              RequestModel(model)
              Citizen.Wait(0)
            end

            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
          end
        end)
      end

      if data.current.value == 'commandant_wear_freemode' then

        TriggerEvent('skinchanger:getSkin', function(skin)

          if skin.sex == 0 then

            local clothesSkin = {
              ['tshirt_1'] = 130,
              ['tshirt_2'] = 0,
              ['torso_1'] = 95,
              ['torso_2'] = 1,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 48,
              ['pants_1'] = 25,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

          else

            local clothesSkin = {
              ['tshirt_1'] = 160,
              ['tshirt_2'] = 0,
              ['torso_1'] = 9,
              ['torso_2'] = 0,
              ['decals_1'] = 0,
              ['decals_2'] = 0,
              ['arms'] = 44,
              ['pants_1'] = 37,
              ['pants_2'] = 0,
              ['helmet_1'] = -1,
              ['helmet_2'] = 0,
              ['ears_1'] = 2,
              ['ears_2'] = 0
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
          end

          local playerPed = GetPlayerPed(-1)
          SetPedArmour(playerPed, 0)
          ClearPedBloodDamage(playerPed)
          ResetPedVisibleDamage(playerPed)
          ClearPedLastWeaponDamage(playerPed)
        end)
      end

      CurrentAction = 'menu_cloakroom'
      CurrentActionMsg = _U('open_cloackroom')
      CurrentActionData = {}
    end,
    function(data, menu)

      menu.close()

      CurrentAction = 'menu_cloakroom'
      CurrentActionMsg = _U('open_cloackroom')
      CurrentActionData = {}
    end)
end

function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

    local elements = {
      { label = _U('get_weapon'), value = 'get_weapon' },
      { label = _U('put_weapon'), value = 'put_weapon' },
      { label = 'Prendre Objet', value = 'get_stock' },
      { label = 'Déposer objet', value = 'put_stock' }
    }

    if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'captain' then
      table.insert(elements, { label = _U('buy_weapons'), value = 'buy_weapons' })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
      {
        title = _U('armory'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
        end

        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction = 'menu_armory'
        CurrentActionMsg = _U('open_armory')
        CurrentActionData = { station = station }
      end)

  else

    local elements = {}

    for i = 1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do
      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      table.insert(elements, { label = ESX.GetWeaponLabel(weapon.name), value = weapon.name })
    end

    table.insert(elements, { label = "Combat Pistol Flashlight", value = "cPistolFlashlight" })
    table.insert(elements, { label = "Carbine Rifle Flashlight Extended Magazine Grip Scope", value = "CRFEMGS" })
    table.insert(elements, { label = "Assault SMG Flashlight Extended Magazine Suppressor Scope", value = "ASMGFEMSS" })
    table.insert(elements, { label = "Pump Shotgun Flashlight", value = "PSF" })
    table.insert(elements, { label = "Sniper Rifle Advanced Scope", value = "SRAS" })
    table.insert(elements, { label = "SMG Mk II Extended Magazine Scope", value = "SMGMkIIEMS" })
    table.insert(elements, { label = "Special Carbine Extended Magazine Flashlight Grip Scope", value = "SCEMFGS" })

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
      {
        title = _U('armory'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)
        local weapon = data.current.value
        if (weapon == "cPistolFlashlight") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 1593441988, 899381934)
        elseif (weapon == "CRFEMGS") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 2076495324)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 2433783441)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 202788691)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 2698550338)
        elseif (weapon == "ASMGFEMSS") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 4024951519, 2076495324)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 4024951519, 3141985303)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 4024951519, 2805810788)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 4024951519, 2637152041)
        elseif (weapon == "PSF") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 487013001, 2076495324)
        elseif (weapon == "SRAS") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 100416529, 3159677559)
        elseif (weapon == "SMGMkIIEMS") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2024373456, 3112393518)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2024373456, 2076495324)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 2024373456, 3842157419)
        elseif (weapon == "SCEMFGS") then
          GiveWeaponComponentToPed(GetPlayerPed(-1), 3231910285, 2089537806)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 3231910285, 2076495324)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 3231910285, 202788691)
          GiveWeaponComponentToPed(GetPlayerPed(-1), 3231910285, 2698550338)
        else
          TriggerServerEvent('esx_policejob:giveWeapon', weapon, 1000)
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction = 'menu_armory'
        CurrentActionMsg = _U('open_armory')
        CurrentActionData = { station = station }
      end)
  end
end


function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i = 1, #garageVehicles, 1 do
        table.insert(elements, { label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i] })
      end

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title = _U('vehicle_menu'),
          align = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value

          if (PlayerData.job.grade >= vehicles[partNum].rank) then
            ESX.Game.SpawnVehicle(vehicleProps.model, vehicles[partNum].SpawnPoint, 270.0, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local playerPed = GetPlayerPed(-1)
              TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
              TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
            end)

            TriggerServerEvent('esx_society:removeVehicleFromGarage', 'police', vehicleProps)
          else
            -- ERROR
            ESX.ShowNotification('Je kan deze auto niet pakken.')
          end
        end,
        function(data, menu)

          menu.close()

          CurrentAction = 'menu_vehicle_spawner'
          CurrentActionMsg = _U('vehicle_spawner')
          CurrentActionData = { station = station, partNum = partNum }
        end)
    end, 'police')

  else

    local elements = {}

    for i = 1, #Config.PoliceStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.PoliceStations[station].AuthorizedVehicles[i]
      table.insert(elements, { label = vehicle.label, value = vehicle.name, rank = vehicle.rank })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title = _U('vehicle_menu'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)
        menu.close()

        local model = data.current
        local vehicle = GetClosestVehicle(
          vehicles[partNum].SpawnPoint.x,
          vehicles[partNum].SpawnPoint.y,
          vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)

        if not DoesEntityExist(vehicle) then
          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then
            if (PlayerData.job.grade >= data.current.rank) then
              ESX.Game.SpawnVehicle(model.value, {
                x = vehicles[partNum].SpawnPoint.x,
                y = vehicles[partNum].SpawnPoint.y,
                z = vehicles[partNum].SpawnPoint.z
              }, vehicles[partNum].Heading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
                SetVehicleMaxMods(vehicle)
              end)
            else
              -- ERROR
              ESX.ShowNotification('Je kan deze auto niet pakken.')
            end
          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                print( "OUTPUT ::::: " .. PlayerData.job.grade .. " " .. model.rank .. " " .. model.value)

                if (PlayerData.job.grade >= model.rank) then
                  ESX.Game.SpawnVehicle(model.value, {
                    x = vehicles[partNum].SpawnPoint.x,
                    y = vehicles[partNum].SpawnPoint.y,
                    z = vehicles[partNum].SpawnPoint.z
                  }, vehicles[partNum].Heading, function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                    SetVehicleMaxMods(vehicle)
                    TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
                  end)
                else
                  -- ERROR
                  ESX.ShowNotification('Je kan deze auto niet pakken.')
                end

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end
            end, 'police')
          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end
      end,
      function(data, menu)

        menu.close()

        CurrentAction = 'menu_vehicle_spawner'
        CurrentActionMsg = _U('vehicle_spawner')
        CurrentActionData = { station = station, partNum = partNum }
      end)
  end
end

function OpenPoliceActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
    {
      title = 'POLITIE',
      align = 'top-left',
      elements = {
        { label = _U('citizen_interaction'), value = 'citizen_interaction' },
        { label = _U('vehicle_interaction'), value = 'vehicle_interaction' },
        { label = _U('object_spawner'), value = 'object_spawner' },
		{label = _U('eupmenu'),				value = 'eupmenu'},
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title = _U('citizen_interaction'),
            align = 'top-left',
            elements = {
              { label = _U('id_card'), value = 'identity_card' },
              { label = _U('search'), value = 'body_search' },
			  {label = _U('softcuff'), value = 'softcuff'},
			  {label = _U('hardcuff'), value = 'hardcuff'},
			  {label = _U('uncuff'), value = 'uncuff'},
              { label = _U('drag'), value = 'drag' },
              { label = _U('put_in_vehicle'), value = 'put_in_vehicle' },
              { label = _U('out_the_vehicle'), value = 'out_the_vehicle' },
              { label = _U('fine'), value = 'fine' }
            },
          },
          function(data2, menu2)

            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              end

              if data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              end

              if data2.current.value == 'softcuff' then
                local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
						TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
					 end
				
				if data2.current.value == 'hardcuff' then
                local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
						TriggerServerEvent('esx_policejob:requesthard', target_id, playerheading, playerCoords, playerlocation)
					end
					
				if data2.current.value == 'uncuff' then
				local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
						TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						Citizen.Wait(1200)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'uncuff', 0.5)
				end

              if data2.current.value == 'drag' then
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					Citizen.Wait(800)
					if DragStatus.draganim then
						StopAnimTask(GetPlayerPed(-1), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
						DragStatus.draganim = false
					else
						LoadAnimDict('switch@trevor@escorted_out')
						TaskPlayAnim(GetPlayerPed(-1), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
						DragStatus.draganim = true
					end
              end

              if data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'out_the_vehicle' then
                TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
              end

              if data2.current.value == 'fine' then
                OpenFineMenu(player)
              end
            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end
          end,
          function(data2, menu2)
            menu2.close()
          end)
      end

      if data.current.value == 'vehicle_interaction' then

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
          {
            title = _U('vehicle_interaction'),
            align = 'top-left',
            elements = {
              { label = _U('vehicle_info'), value = 'vehicle_infos' },
              { label = _U('pick_lock'), value = 'hijack_vehicle' },
            },
          },
          function(data2, menu2)

            local playerPed = GetPlayerPed(-1)
            local coords = GetEntityCoords(playerPed)
            local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)

            if DoesEntityExist(vehicle) then

              local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

              if data2.current.value == 'vehicle_infos' then
                OpenVehicleInfosMenu(vehicleData)
              end

              if data2.current.value == 'hijack_vehicle' then

                local playerPed = GetPlayerPed(-1)
                local coords = GetEntityCoords(playerPed)

                if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                  local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)

                  if DoesEntityExist(vehicle) then

                    Citizen.CreateThread(function()

                      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

                      Wait(20000)

                      ClearPedTasksImmediately(playerPed)

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)

                      TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))
                    end)
                  end
                end
              end

            else
              ESX.ShowNotification(_U('no_vehicles_nearby'))
            end
          end,
          function(data2, menu2)
            menu2.close()
          end)
      end
	if data.current.value == 'eupmenu' then
				TriggerEvent('eupmenu')
				ESX.UI.Menu.CloseAll()
				end

      if data.current.value == 'object_spawner' then

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title = _U('traffic_interaction'),
            align = 'top-left',
            elements = {
              { label = _U('cone'), value = 'prop_roadcone02a' },
              { label = _U('barrier'), value = 'prop_barrier_work06a' },
              { label = _U('spikestrips'), value = 'p_ld_stinger_s' },
              --{ label = _U('box'), value = 'prop_boxpile_07d' },
              -- {label = _U('cash'),   value = 'hei_prop_cash_crate_half_full'}
            },
          },
          function(data2, menu2)


            local model = data2.current.value
            local playerPed = GetPlayerPed(-1)
            local coords = GetEntityCoords(playerPed)
            local forward = GetEntityForwardVector(playerPed)
            local x, y, z = table.unpack(coords + forward * 1.0)

            if model == 'prop_roadcone02a' then
              z = z - 2.0
            end

            ESX.Game.SpawnObject(model, {
              x = x,
              y = y,
              z = z
            }, function(obj)
              SetEntityHeading(obj, GetEntityHeading(playerPed))
              PlaceObjectOnGroundProperly(obj)
            end)
          end,
          function(data2, menu2)
            menu2.close()
          end)
      end
    end,
    function(data, menu)

      menu.close()
    end)
end

function openPolice()
  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
    OpenPoliceActionsMenu()
    GUI.Time = GetGameTimer()
  end
end

function getJob()
  if PlayerData.job ~= nil then
    return PlayerData.job.name
  end
end

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel = nil
      local sexLabel = nil
      local sex = nil
      local dobLabel = nil
      local heightLabel = nil
      local idLabel = nil

      if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
        jobLabel = 'Werk : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Werk : ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Man'
        else
          sex = 'Vrouw'
        end
        sexLabel = 'Geslacht : ' .. sex
      else
        sexLabel = 'Geslacht : Onbekend'
      end

      if data.dob ~= nil then
        dobLabel = 'Geb. : ' .. data.dob
      else
        dobLabel = 'Geb. : Onbekend'
      end

      if data.height ~= nil then
        heightLabel = 'Grootte : ' .. data.height
      else
        heightLabel = 'Grootte : Onbekend'
      end

      if data.name ~= nil then
        idLabel = 'ID : ' .. data.name
      else
        idLabel = 'ID : Onbekend'
      end

      local elements = {
        { label = _U('name') .. data.firstname .. " " .. data.lastname, value = nil },
        { label = sexLabel, value = nil },
        { label = dobLabel, value = nil },
        { label = heightLabel, value = nil },
        { label = jobLabel, value = nil },
        { label = idLabel, value = nil },
      }

      if data.drunk ~= nil then
        table.insert(elements, { label = _U('bac') .. data.drunk .. '%', value = nil })
      end

      if data.licenses ~= nil then

        table.insert(elements, { label = '--- Licenties ---', value = nil })

        for i = 1, #data.licenses, 1 do
          table.insert(elements, { label = data.licenses[i].label, value = nil })
        end
      end

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title = _U('citizen_interaction'),
          align = 'top-left',
          elements = elements,
        },
        function(data, menu)
        end,
        function(data, menu)
          menu.close()
        end)
    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

      local elements = {
        { label = _U('name') .. data.name, value = nil },
        { label = jobLabel, value = nil },
      }

      if data.drunk ~= nil then
        table.insert(elements, { label = _U('bac') .. data.drunk .. '%', value = nil })
      end

      if data.licenses ~= nil then

        table.insert(elements, { label = '--- Licenties ---', value = nil })

        for i = 1, #data.licenses, 1 do
          table.insert(elements, { label = data.licenses[i].label, value = nil })
        end
      end

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title = _U('citizen_interaction'),
          align = 'top-left',
          elements = elements,
        },
        function(data, menu)
        end,
        function(data, menu)
          menu.close()
        end)
    end, GetPlayerServerId(player))
  end
end

function OpenBodySearchMenu(player)

  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

    local elements = {}

    local blackMoney = 0

    for i = 1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label = _U('confiscate_dirty') .. blackMoney,
      value = 'black_money',
      itemType = 'item_account',
      amount = blackMoney
    })

    table.insert(elements, { label = '--- Wapens ---', value = nil })

    for i = 1, #data.weapons, 1 do
      table.insert(elements, {
        label = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
        value = data.weapons[i].name,
        itemType = 'item_weapon',
        amount = data.ammo,
      })
    end

    table.insert(elements, { label = _U('inventory_label'), value = nil })

    for i = 1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value = data.inventory[i].name,
          itemType = 'item_standard',
          amount = data.inventory[i].count,
        })
      end
    end


    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
      {
        title = _U('search'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)
        end
      end,
      function(data, menu)
        menu.close()
      end)
  end, GetPlayerServerId(player))
end

function OpenFineMenu(player)

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
    {
      title = _U('fine'),
      align = 'top-left',
      elements = {
        { label = 'Verkeersdelicten', value = 0 },
        { label = 'Verkeersdelicten +', value = 1 },
        { label = 'Criminaliteiten', value = 2 },
        { label = 'Wapendelicten', value = 3 },
      },
    },
    function(data, menu)

      OpenFineCategoryMenu(player, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end)
end

function OpenFineCategoryMenu(player, category)

  ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)

    local elements = {}

    for i = 1, #fines, 1 do
      table.insert(elements, {
        label = fines[i].label .. ' $' .. fines[i].amount,
        value = fines[i].id,
        amount = fines[i].amount,
        fineLabel = fines[i].label
      })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
      {
        title = _U('fine'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local label = data.current.fineLabel
        local amount = data.current.amount

        menu.close()

        if Config.EnablePlayerManagement then
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)
        else
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total') .. label, amount)
        end

        ESX.SetTimeout(300, function()
          OpenFineCategoryMenu(player, category)
        end)
      end,
      function(data, menu)
        menu.close()
      end)
  end, category)
end

function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, { label = _U('plate') .. infos.plate, value = nil })

    if infos.owner == nil then
      table.insert(elements, { label = _U('owner_unknown'), value = nil })
    else
      table.insert(elements, { label = _U('owner') .. infos.owner, value = nil })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title = _U('vehicle_info'),
        align = 'top-left',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end)
  end, vehicleData.plate)
end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i = 1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, { label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title = _U('get_weapon_menu'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)
      end,
      function(data, menu)
        menu.close()
      end)
  end)
end

function OpenPutWeaponMenu()

  local elements = {}
  local playerPed = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i = 1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, { label = weaponList[i].label, value = weaponList[i].name })
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title = _U('put_weapon_menu'),
      align = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)
    end,
    function(data, menu)
      menu.close()
    end)
end

function OpenBuyWeaponsMenu(station)

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i = 1, #Config.PoliceStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.PoliceStations[station].AuthorizedWeapons[i]
      local count = 0

      for i = 1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, { label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title = _U('buy_weapon_menu'),
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value)
          else
            ESX.ShowNotification(_U('not_enough_money'))
          end
        end, data.current.price)
      end,
      function(data, menu)
        menu.close()
      end)
  end)
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i = 1, #items, 1 do
      table.insert(elements, { label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
      {
        title = _U('police_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
            end
          end,
          function(data2, menu2)
            menu2.close()
          end)
      end,
      function(data, menu)
        menu.close()
      end)
  end)
end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i = 1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, { label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
      {
        title = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil or count < 1 then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
            end
          end,
          function(data2, menu2)
            menu2.close()
          end)
      end,
      function(data, menu)
        menu.close()
      end)
  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name = 'Polizei',
    number = 'police',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction = 'menu_cloakroom'
    CurrentActionMsg = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction = 'menu_armory'
    CurrentActionMsg = _U('open_armory')
    CurrentActionData = { station = station }
  end

  if part == 'VehicleSpawner' then
    CurrentAction = 'menu_vehicle_spawner'
    CurrentActionMsg = _U('vehicle_spawner')
    CurrentActionData = { station = station, partNum = partNum }
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z, 3.0) then

      ESX.Game.SpawnVehicle('polmav', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
        TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
      end)
    end
  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed, false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction = 'delete_vehicle'
        CurrentActionMsg = _U('store_vehicle')
        CurrentActionData = { vehicle = vehicle }
      end
    end
  end

  if part == 'BossActions' then
    CurrentAction = 'menu_boss_actions'
    CurrentActionMsg = _U('open_bossmenu')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction = 'remove_entity'
    CurrentActionMsg = _U('remove_object')
    CurrentActionData = { entity = entity }
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') and PlayerData.job.name ~= 'police' then

    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed, false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i = 0, 7, 1 do
        SetVehicleTyreBurst(vehicle, i, true, 1000)
      end
    end
  end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end
end)
--[[
RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()

  IsHandcuffed = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(50)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed, true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed, true)
      FreezeEntityPosition(playerPed, false)
    end
  end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)
--]]
RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		if IsHandcuffed then
			if Config.EnableHandcuffTimer then
				if HandcuffTimer.active then
					ESX.ClearTimeout(HandcuffTimer.task)
				end
				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and HandcuffTimer.active then
				ESX.ClearTimeout(HandcuffTimer.task)
			end
		end
	end)
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('esx_policejob:hardcuff')
AddEventHandler('esx_policejob:hardcuff', function()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		if IsShackles then
			if Config.EnableHandcuffTimer then
				if HandcuffTimer.active then
					ESX.ClearTimeout(HandcuffTimer.task)
				end
				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and HandcuffTimer.active then
				ESX.ClearTimeout(HandcuffTimer.task)
			end
		end
	end)
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID)
	if not IsHandcuffed then
		return
	end
	
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
	
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
			
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i = maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle, i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
      end
    end
  end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1), true)
  local xnew = plyPos.x + 2
  local ynew = plyPos.y + 2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

--[[ Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 24, true) -- Input Attack
      DisableControlAction(0, 140, true) -- Melee Attack Alternate
      DisableControlAction(0, 141, true) -- Melee Attack Alternate
      DisableControlAction(0, 142, true) -- Melee Attack Alternate
      DisableControlAction(0, 257, true) -- Input Attack 2
      DisableControlAction(0, 263, true) -- Input Melee Attack
      DisableControlAction(0, 264, true) -- Input Melee Attack 2

      DisableControlAction(0, 30, true) -- MoveLeftRight
      DisableControlAction(0, 31, true) -- MoveUpDown
    end
  end
end) --]]

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)


RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 


RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)


RegisterNetEvent('esx_policejob:loose')
AddEventHandler('esx_policejob:loose', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = true
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, Keys['W'], true) -- W
			--DisableControlAction(0, Keys['A'], true) -- A
			--DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			--DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsShackles then
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('esx_policejob:getarrestedhard')
AddEventHandler('esx_policejob:getarrestedhard', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	IsShackles = true
	TriggerEvent('esx_policejob:hardcuff')
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

-- Create blips
Citizen.CreateThread(function()

  for k, v in pairs(Config.PoliceStations) do

    local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

    SetBlipSprite(blip, v.Blip.Sprite)
    SetBlipDisplay(blip, v.Blip.Display)
    SetBlipScale(blip, v.Blip.Scale)
    SetBlipColour(blip, v.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blip)
  end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed = GetPlayerPed(-1)
      local coords = GetEntityCoords(playerPed)

      for k, v in pairs(Config.PoliceStations) do

        for i = 1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i = 1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i = 1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        -- for i=1, #v.Helicopters, 1 do
        -- if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config.DrawDistance then
        -- DrawMarker(Config.MarkerType, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
        -- end
        -- end

        for i = 1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.DrawDistance then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i = 1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config.DrawDistance then
              DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
            end
          end
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed = GetPlayerPed(-1)
      local coords = GetEntityCoords(playerPed)
      local isInMarker = false
      local currentStation = nil
      local currentPart = nil
      local currentPartNum = nil

      for k, v in pairs(Config.PoliceStations) do

        for i = 1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i = 1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'Armory'
            currentPartNum = i
          end
        end

        for i = 1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords, v.Vehicles[i].SpawnPoint.x, v.Vehicles[i].SpawnPoint.y, v.Vehicles[i].SpawnPoint.z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'VehicleSpawnPoint'
            currentPartNum = i
          end
        end

        for i = 1, #v.Helicopters, 1 do

          if GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'HelicopterSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords, v.Helicopters[i].SpawnPoint.x, v.Helicopters[i].SpawnPoint.y, v.Helicopters[i].SpawnPoint.z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'HelicopterSpawnPoint'
            currentPartNum = i
          end
        end

        for i = 1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.MarkerSize.x then
            isInMarker = true
            currentStation = k
            currentPart = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

          for i = 1, #v.BossActions, 1 do
            if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config.MarkerSize.x then
              isInMarker = true
              currentStation = k
              currentPart = 'BossActions'
              currentPartNum = i
            end
          end
        end
      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

        if (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation = currentStation
        LastPart = currentPart
        LastPartNum = currentPartNum

        TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end
    end
  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
    'prop_boxpile_07d',
    'hei_prop_cash_crate_half_full'
  }

  while true do

    Citizen.Wait(0)

    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity = nil

    for i = 1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, objCoords.x, objCoords.y, objCoords.z, true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity = object
        end
      end
    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)

          else

            if GetEntityModel(vehicle) == GetHashKey('police') or
              GetEntityModel(vehicle) == GetHashKey('police2') or
              GetEntityModel(vehicle) == GetHashKey('police3') or
              GetEntityModel(vehicle) == GetHashKey('police4') or
              GetEntityModel(vehicle) == GetHashKey('policeb') or
              GetEntityModel(vehicle) == GetHashKey('policet') then
              TriggerServerEvent('esx_service:disableService', 'police')
            end
          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)

            menu.close()

            CurrentAction = 'menu_boss_actions'
            CurrentActionMsg = _U('open_bossmenu')
            CurrentActionData = {}
          end)
        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time = GetGameTimer()
      end
    end

    if IsControlPressed(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenPoliceActionsMenu()
      GUI.Time = GetGameTimer()
    end
  end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
		HandcuffTimer.Active = false
	end)
end