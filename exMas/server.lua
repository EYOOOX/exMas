ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('exMas:TakeGift')
AddEventHandler('exMas:TakeGift', function(gift)
    local xPlayer = ESX.GetPlayerFromId(source)

    if gift.type == 'weapon' then
        xPlayer.addWeapon(gift.value, gift.amount)
        TriggerClientEvent("esx:showNotification", source, '~r~Joyeux Noël~s~~n~ Vous avez récupéré : ~b~'..gift.name)
    elseif gift.type == 'item' then
        xPlayer.addInventoryItem(gift.value, gift.amount)
        TriggerClientEvent("esx:showNotification", source, '~r~Joyeux Noël~s~~n~ Vous avez récupéré ~b~x'..gift.amount..' '..gift.name)
    elseif gift.type == 'money' then
        xPlayer.addMoney(gift.amount)
        TriggerClientEvent("esx:showNotification", source, '~r~Joyeux Noël~s~~n~ Vous avez récupéré ~g~$'..gift.amount)
    end
end)

for k, v in pairs(exMas.Vet) do
    ESX.RegisterUsableItem(v.item, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('exMas:Vet', source, v.type, v.value, v.type2, v.value2)
    end)
end