RegisterNetEvent("fn_idcard:sendStatus")
AddEventHandler("fn_idcard:sendStatus", function(name, group, job, cash, bank, dirty)
    SetDisplay(true, name, group, job, cash, bank, dirty)
end)

RegisterNUICallback("close", function()
    SetDisplay(false)
end)

function SetDisplay(bool, name, group, job, cash, bank, dirty)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        status = bool,
        name = name,
        group = group,
        job = job,
        cash = cash,
        bank = bank,
        dirty = dirty
})
end

RegisterCommand("idcard", function()
    TriggerServerEvent("fn_idcard:getStatus")
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/idcard', 'Check your status',  { {  } } )
end)