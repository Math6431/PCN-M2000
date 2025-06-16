BIOS.protocol.beginModule("M-2000C-PCN", 0x0001)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local log = log or {}
log.info = log.info or function(msg) end

-- Hook d'export pour afficher toutes les données de list_indication(9)
moduleBeingDefined.exportHooks[#moduleBeingDefined.exportHooks+1] = function()
    local li = list_indication(9)
    if not li then
        log.info("PCN DEBUG: list_indication(9) is nil")
        return
    end
    log.info("PCN DEBUG: Dumping list_indication(9)")
    for k,v in pairs(li) do
        log.info("PCN DEBUG: " .. tostring(k) .. " = " .. tostring(v))
    end
end

BIOS.protocol.endModule()