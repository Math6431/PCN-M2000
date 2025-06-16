BIOS.protocol.beginModule("M-2000C-PCN", 0x0001)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local lfs = require("lfs")

moduleBeingDefined.exportHooks[#moduleBeingDefined.exportHooks+1] = function()
    local file = io.open(lfs.writedir() .. "/Logs/pcn_debug.log", "a")
    if not file then return end

    local li = list_indication(9)
    if not li then
        file:write("PCN DEBUG: list_indication(9) is nil\n")
        file:close()
        return
    end

    file:write("PCN DEBUG: Dumping list_indication(9)\n")
    for k, v in pairs(li) do
        file:write(string.format("PCN DEBUG: %s = %s\n", tostring(k), tostring(v)))
    end
    file:close()
end

BIOS.protocol.endModule()