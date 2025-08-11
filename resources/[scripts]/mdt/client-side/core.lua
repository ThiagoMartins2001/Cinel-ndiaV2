-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("mdt",cRP)
vSERVER = Tunnel.getInterface("mdt")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local mdtOpen = false
local currentLocation = nil
local isLoggedIn = false
local userData = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mdt", function()
    if vSERVER.checkPermission() then
        openMDT()
    else
        TriggerEvent("Notify", "negado", "Você não tem permissão para acessar o MDT.")
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMDT
-----------------------------------------------------------------------------------------------------------------------------------------
function openMDT()
    if not mdtOpen then
        mdtOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "openMDT" })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSEMDT
-----------------------------------------------------------------------------------------------------------------------------------------
function closeMDT()
    if mdtOpen then
        mdtOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "closeMDT" })
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeMDT", function(data, cb)
    closeMDT()
    cb("ok")
end)

RegisterNUICallback("login", function(data, cb)
    local result = vSERVER.login(data.username, data.password)
    if result.success then
        isLoggedIn = true
        userData = result.data
        cb({ success = true, data = result.data })
    else
        cb({ success = false, message = result.message })
    end
end)

RegisterNUICallback("logout", function(data, cb)
    isLoggedIn = false
    userData = nil
    vSERVER.logout()
    cb("ok")
end)

RegisterNUICallback("toggleService", function(data, cb)
    local result = vSERVER.toggleService()
    cb({ success = true, inService = result.inService })
end)

RegisterNUICallback("getServiceStatus", function(data, cb)
    local result = vSERVER.getServiceStatus()
    cb({ success = true, inService = result.inService })
end)

RegisterNUICallback("getUserInfo", function(data, cb)
    local result = vSERVER.getUserInfo()
    cb({ success = true, user = result })
end)

RegisterNUICallback("authenticateUser", function(data, cb)
    print("^3[MDT CLIENT] authenticateUser callback chamado^7")
    print("^3[MDT CLIENT] data.passport: " .. tostring(data.passport) .. "^7")
    print("^3[MDT CLIENT] data.department: " .. tostring(data.department) .. "^7")
    
    local result = vSERVER.authenticateUser(data.passport, data.department)
    
    print("^3[MDT CLIENT] Resultado recebido do servidor:^7")
    print("^3[MDT CLIENT] success: " .. tostring(result.success) .. "^7")
    if result.message then
        print("^3[MDT CLIENT] message: " .. tostring(result.message) .. "^7")
    end
    
    cb(result)
end)

RegisterNUICallback("getCitizenPrisonRecords", function(data, cb)
    local result = vSERVER.getCitizenPrisonRecords(data.passport)
    cb(result)
end)

RegisterNUICallback("getCitizenFines", function(data, cb)
    print("^3[MDT CLIENT DEBUG]^7 getCitizenFines chamado com passport: " .. tostring(data.passport))
    local result = vSERVER.getCitizenFines(data.passport)
    print("^3[MDT CLIENT DEBUG]^7 Resultado: " .. tostring(result.success) .. ", Multas: " .. #(result.fines or {}))
    cb(result)
end)

RegisterNUICallback("getCitizenWarrants", function(data, cb)
    local result = vSERVER.getCitizenWarrants(data.passport)
    cb(result)
end)

RegisterNUICallback("searchUser", function(data, cb)
    local result = vSERVER.searchUser(parseInt(data.passport))
    cb({ result = result })
end)



RegisterNUICallback("initFine", function(data, cb)
    vSERVER.initFine(data.passport, data.fines, data.text, data.license, data.article, data.infraction, data.description)
    cb("ok")
end)

RegisterNUICallback("initPrisonFine", function(data, cb)
    vSERVER.initPrisonFine(data.passport, data.fines, data.text, data.license, data.article, data.infraction, data.description, data.prisonTime)
    cb("ok")
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    vSERVER.deleteWarrant(data.id)
    cb("ok")
end)

RegisterNUICallback("setWarrant", function(data, cb)
    vSERVER.setWarrant(parseInt(data.passport), data.text)
    cb("ok")
end)

RegisterNUICallback("givePort", function(data, cb)
    vSERVER.givePort(parseInt(data.passport), data.serial, data.status, data.exam)
    cb("ok")
end)

RegisterNUICallback("editPort", function(data, cb)
    vSERVER.editPort(parseInt(data.id), parseInt(data.passport), data.serial, data.status, data.exam)
    cb("ok")
end)

RegisterNUICallback("deletePort", function(data, cb)
    vSERVER.deletePort(data.id)
    cb("ok")
end)

RegisterNUICallback("getPortById", function(data, cb)
    cb({ result = vSERVER.getPortById(data.id) })
end)

RegisterNUICallback("searchPort", function(data, cb)
    if data.type == "consultar" then
        cb({ result = vSERVER.searchPort() })
    end
end)

RegisterNUICallback("getReports", function(data, cb)
    cb({ result = vSERVER.getReports() })
end)

RegisterNUICallback("getReportById", function(data, cb)
    local report = vSERVER.getReportById(data.id)
    cb({ result = report })
end)

RegisterNUICallback("setReportSolved", function(data, cb)
    vSERVER.setReportSolved(data.id)
    cb("ok")
end)

RegisterNUICallback("insertReport", function(data, cb)
    vSERVER.insertReport(data.victim_id, data.victim_name, data.victim_report, data.officer_name, data.department, data.rank)
    cb("ok")
end)

RegisterNUICallback("deleteReport", function(data, cb)
    vSERVER.deleteReport(data.id)
    cb("ok")
end)

RegisterNUICallback("getWarrants", function(data, cb)
    cb({ result = vSERVER.getWarrants() })
end)

RegisterNUICallback("getDashboardStats", function(data, cb)
    local stats = vSERVER.getDashboardStats()
    cb({ result = stats })
end)

RegisterNUICallback("getAnnouncements", function(data, cb)
    local announcements = vSERVER.getAnnouncements()
    cb({ result = announcements })
end)

RegisterNUICallback("addAnnouncement", function(data, cb)
    vSERVER.addAnnouncement(data.title, data.content)
    cb("ok")
end)

RegisterNUICallback("deleteAnnouncement", function(data, cb)
    vSERVER.deleteAnnouncement(data.id)
    cb("ok")
end)

RegisterNUICallback("impoundVehicle", function(data, cb)
    vSERVER.impoundVehicle(data.plate, data.reason)
    cb("ok")
end)

RegisterNUICallback("releaseVehicle", function(data, cb)
    vSERVER.releaseVehicle(data.plate)
    cb("ok")
end)

RegisterNUICallback("getImpoundedVehicles", function(data, cb)
    local vehicles = vSERVER.getImpoundedVehicles()
    cb({ result = vehicles })
end)

RegisterNUICallback("getFines", function(data, cb)
    local result = vSERVER.getFines(data.type)
    cb(result)
end) 