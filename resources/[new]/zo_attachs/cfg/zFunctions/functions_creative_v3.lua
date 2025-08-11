zof = {
    hasPermission = function(user_id, perm)
        return vRP.HasPermission(user_id, perm)
    end,

    giveWeapons = function(source, weapons)
        return vRPclient._giveWeapons(source, weapons)
    end,

    getUserId = function(source)
        return vRP.Passport(source)
    end,

    tryFullPayment = function(user_id, price)
        return vRP.PaymentFull(user_id, price)
    end,

    getInventoryItemAmount = function(user_id, Item)
        return vRP.InventoryItemAmount(user_id, Item)
    end,

    tryGetInventoryItem = function(user_id, Item, Amount)
        return vRP.TakeItem(user_id, Item, Amount)
    end,
    
    itemNameList = function(item)
        return itemName(item)
    end,

    giveInventoryItem = function(user_id, Item, Amount)
        return vRP.GenerateItem(user_id, Item, Amount)
    end,

    query = function(nameQuery, data)
        return vRP.Query(nameQuery, data)
    end,
    
    prepare = function(nameQuery, query)
        return vRP.Prepare(nameQuery, query)
    end,
    
    execute = function(nameQuery)
        return vRP.Query(nameQuery)
    end,
}