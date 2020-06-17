RegisterServerEvent("fn_idcard:getStatus")
AddEventHandler("fn_idcard:getStatus", function()
    local identifier = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})
    local get = MySQL.Sync.fetchAll("SELECT * FROM user_accounts WHERE identifier = @identifier", {["@identifier"] = identifier})

    local user = result[1]
    local stat = get[1] 

    local name = user['firstname'] .. " " .. user['lastname']

   TriggerClientEvent("fn_idcard:sendStatus", source, name, user.group, user.job, user.money, user.bank, stat.money)
end)