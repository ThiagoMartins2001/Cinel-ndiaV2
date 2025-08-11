local config = {}

config.Token      = "94gttuR0hC4cXhb3xBlE9uLBT0PnudsDoyUav4vfcZad9Gd0fCGd1Gehd9oz"
config.LicenseKey = "TQG4-Z3ZP-QBIN-TDT1"
config.IPItems    = "http://201.7.213.132/inventory/"
config.IPVehicles = "http://201.7.213.132/Vehicles/"
config.UserImage  = "https://files.mastodon.social/media_attachments/files/113/550/046/084/784/712/original/bf888cb2e5aa9e9a.png"

config.permissions = {
    ["Admin"] = {
        ["players"]       = true,
        ["groups"]        = true,
        ["punishments"]   = true,
        ["deleteban"]     = true,
        ["messages"]      = true,
        ["spawnitems"]    = true,
        ["spawnvehicles"] = true,
        ["addvehicles"]   = true,
    }
     -- ["manager.permissao"] = { 
    --     ["players"]       = true,
    --     ["groups"]        = true,
    --     ["punishments"]   = true,
    --     ["messages"]      = true,
    --     ["spawnitems"]    = true,
    --     ["spawnvehicles"] = true,
    --     ["addvehicles"]   = true
    -- },
    -- ["coordenador.permissao"] = {
    --     ["players"]       = true,
    --     ["groups"]        = true,
    --     ["punishments"]   = true,
    --     ["messages"]      = true,
    --     ["spawnitems"]    = true,
    --     ["spawnvehicles"] = true,
    --     ["addvehicles"]   = true
    -- },
    -- ["administrador.permissao"] = {
    --     ["players"]       = true,
    --     ["groups"]        = true,
    --     ["punishments"]   = true,
    --     ["messages"]      = true,
    --     ["spawnitems"]    = false,
    --     ["spawnvehicles"] = true,
    --     ["addvehicles"]   = false
    -- },
    -- ["moderador.permissao"] = {
    --     ["players"]       = true,
    --     ["groups"]        = true,
    --     ["punishments"]   = true,
    --     ["messages"]      = true,
    --     ["spawnitems"]    = false,
    --     ["spawnvehicles"] = false,
    --     ["addvehicles"]   = false
    -- },
    -- ["suporte.permissao"] = {
    --     ["players"]       = true,
    --     ["groups"]        = false,
    --     ["punishments"]   = true,
    --     ["messages"]      = true,
    --     ["spawnitems"]    = false,
    --     ["spawnvehicles"] = false,
    --     ["addvehicles"]   = false
    -- },
}

config.commands = {
    opentablet = "admin",
    openchat   = "chatstaff"
}

config.webhooks = {
    addgroup          = "https://discord.com/api/webhooks/1384390793359261746/GmaLwaH2XUNDsFr3xVpYijTq4x-8j3CccHpc41ueCdvBETB99GOb1Q9AZL7XLlAxXvyv",
    remgroup          = "https://discord.com/api/webhooks/1384391010653573161/RyztG2cl70nhtOdQrIe9G4kjjOz8PmnkRDf9fHpAN16Qp_MUNd0Vb7MHuWw19RROHuHN",
    addban            = "https://discord.com/api/webhooks/1384391259329662997/WY5zqIf1lPHMQKmiX19Ep3gwvyPRm4M0iiAklEQDImtXQjxnCFqLa0fuAJwhoApitijH",
    deleteban         = "https://discord.com/api/webhooks/1384392640933400657/4EFnMqtcHKPObN2KTqzHx0cgCBn1WGzMrZMBbfo04xGPQEQKx8ODQRbeTPYXMd-Hx-QR",
    editban           = "https://discord.com/api/webhooks/1384392340558315663/-WeqmRPxVlOrs0thR9Li6Xx1jYvhkaBxHtI05klXJUj_44nttB4wMufnlsd9OVkHIVoe",
    spawnitem         = "https://discord.com/api/webhooks/1384393955491451000/ISo97snySAbh1NKVWrKZF6VJdBKJxuGZh0JCSHpEk2r6j0ykHBX9SLk_oiDgypOUx95B",
    spawnvehicle      = "https://discord.com/api/webhooks/1384394190536048660/zyyMz-zdm2DLdmgUw1CXAPcPqkM-f_JXFUxTG-OxyrgLR1zKRu52CWIjpwaJQ3k_rUIJ",
    addvehicle        = "https://discord.com/api/webhooks/1384394455213412383/3vyewgoFkLaLxJKNsyUzy6QYXIKEJtbzmIegkTAUGHZDNAK58meDnbdsyBrV2jYmcFa0",
    removevehicle     = "https://discord.com/api/webhooks/1389450964762628116/1EyNcLLmmpDNjH9uvxr9Y1wxO40ieszBQ-S9AmRNWOZJt81TfoM4cCu6eKpmn1k228MR",
    webhookimage      = "https://discord.com/api/webhooks/1384394697652305960/psjH50Ygctiq60yzsypxb_aQZXvLLhZbZvf5BN3dO4_Hk0zWHpl3Sa01Rcrh9vzHHKpI",
    webhooktext       = "https://discord.com/api/webhooks/1384394993480761446/_5WLVc7jkW4DvaKkF_RHyV1vKDFZ7RnqWQc4pWGtPX9XHFMtJ1_WOSEqeXIeJJZXF8r8",
    webhookcolor      = 16431885
}

config.starttablet = function()
    vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
end

config.stoptablet = function()
	vRP.Destroy()
end

return config