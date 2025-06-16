BIOS.protocol.beginModule("M-2000C-PCN", 0x0004)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local lfs = require("lfs")

-- GLOBAL index (corrigé : déclaré en dehors de la fonction)
if not pcn_scan_index then
    pcn_scan_index = 0
end

local max_index = 20

moduleBeingDefined.exportHooks[#moduleBeingDefined.exportHooks+1] = function()
    if pcn_scan_index > max_index then return end

    local file = io.open(lfs.writedir() .. "/Logs/pcn_index_scan.log", "a")
    if not file then return end

    local li = list_indication(pcn_scan_index)
    if not li then
        file:write(string.format("INDEX %d: nil\n", pcn_scan_index))
    else
        file:write(string.format("INDEX %d:\n", pcn_scan_index))
        local found = false
        for k, v in pairs(li) do
            file:write(string.format("  %s = %s\n", tostring(k), tostring(v)))
            found = true
        end
        if not found then
            file:write("  (empty table)\n")
        end
    end

    file:write("\n")
    file:close()

    pcn_scan_index = pcn_scan_index + 1
end

BIOS.protocol.endModule()