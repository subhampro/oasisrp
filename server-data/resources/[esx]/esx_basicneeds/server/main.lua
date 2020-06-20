ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_water'))
end)


ESX.RegisterUsableItem('joint', function(source) -- İTEM_İSMİ kısmına item ismini yazın (sigara) // replace your item with İTEM_İSMİ
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('joint', 1) -- kullanınca bir tane envanterden siler // removes 1 when used
	Citizen.Wait(8000) -- Birazcık bekliyoruzki kullandığı gibi stress değişmesin, animasyon oynasın // wait a bit so stress won't change instantly and animation can be played
	TriggerClientEvent('esx_status:remove', source, 'stress', 50000) -- MİKTAR kısmına miktar, OLAY kısmına ekleme ise "add", azaltama ise "remove" yazın // replace MİKTAR with the amount you want, and replace OLAY with "add" or "remove"
	TriggerClientEvent('esx_basicneeds:ANIM', source) -- eğer item kullanımında animasyon ya da farklı bir client event istiyorsanız burada triggerlayın // if you want animation or something else on item usage trigger it here
	TriggerClientEvent('esx:showNotification', source, "You have used One Joint") -- BİLDİRİM yerine eğer bildirim gitmesini istiyorsanız bir şey yazın // replace BİLDİRİM with the notification you want
end)

-- ÖRNEK: SİGARA // EXAMPLE: CIGARETTES

ESX.RegisterUsableItem('cigarette', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

    	xPlayer.removeInventoryItem('cigarette', 1)
	TriggerClientEvent('esx_basicneeds:cigarette', source) -- ilk önce animasyon oynatıyoruz // first we play animation
    	Citizen.Wait(8000) -- Birazcık bekliyoruzki kullandığı gibi stress değişmesin, animasyon oynasın // wait a bit so stress won't change instantly and animation can be played
	TriggerClientEvent('esx_status:remove', source, 'stress', 250000) -- stres düşüyor // loWer stress
end) -- Bildirim eklemek istemedim // I didn't want to add a notification

-- ESX.RegisterUsableItem('beer', function(source)
	-- local xPlayer = ESX.GetPlayerFromId(source)
	-- xPlayer.removeInventoryItem('beer', 1)
-- 	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
-- 	TriggerClientEvent('esx_basicneeds:onDrink', source)
	-- xPlayer.showNotification('You just drunk one bottle of Bear !')
-- end)


-- ESX.RegisterUsableItem('cigarette', function(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)
    -- xPlayer.removeInventoryItem('cigarette', 1)
    -- xPlayer.showNotification('That was cool which will reduce Stres.. right?')
-- end)

-- ESX.RegisterUsableItem('joint', function(source)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	xPlayer.removeInventoryItem('joint', 1)
-- 	xPlayer.showNotification('You just used one Joint!')
-- end)



ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 20000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification('You have eatten one Packet of Chips !')
end)


ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cocacola', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification('You just drunk one can of CocoCola !')
end)

ESX.RegisterUsableItem('coffe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coffe', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification('You just drunk one can of Coffe !')
end)

ESX.RegisterUsableItem('cupcake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cupcake', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 20000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification('You just eatten one cupcake !')
end)

ESX.RegisterUsableItem('hamburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hamburger', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 20000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification('You just eatten one Hamburger !')
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('icetea', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification('You just drunk one cup of Icetea !')
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 20000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification('You just eatten one Sandwich !')
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chocolate', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 20000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	xPlayer.showNotification('You just eatten one Chocolate !')
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification('You just drunk one bottle of Vodka !')
end)


ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whisky', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 20000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification('You just drunk one bottle of Whisky !')
end)



TriggerEvent('es:addGroupCommand', 'heal', 'admin', function(source, args, user)
	-- heal another player - don't heal source
	if args[1] then
		local playerId = tonumber(args[1])

		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
				print(('esx_basicneeds: %s healed %s'):format(GetPlayerIdentifier(source, 0), GetPlayerIdentifier(playerId, 0)))
				TriggerClientEvent('esx_basicneeds:healPlayer', playerId)
				TriggerClientEvent('chat:addMessage', source, { args = { '^5HEAL', 'You have been healed.' } })
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player id.' } })
		end
	else
		print(('esx_basicneeds: %s healed self'):format(GetPlayerIdentifier(source, 0)))
		TriggerClientEvent('esx_basicneeds:healPlayer', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', params = {{name = 'playerId', help = '(optional) player id'}}})