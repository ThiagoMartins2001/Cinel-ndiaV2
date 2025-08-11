local Tunnel = module("vrp", "lib/Tunnel")
psStaff = Tunnel.getInterface("ps_staff")

RegisterNUICallback("getAllStaffMembers", function(data, cb)
    psStaff.getAllStaffMembers({}, function(staffList)
        cb(staffList or {})
    end)
end) 