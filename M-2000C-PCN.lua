BIOS.protocol.beginModule("M-2000C-PCN", 0x0003)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local lfs = require("lfs")
local index = 0
local max_index = 20

moduleBeingDefined.exportHooks[#moduleBeingDefined.exportHooks+1] = function()
    if index > max_index then return end

    local file = io.open(lfs.writedir() .. "/Logs/pcn_index_scan.log", "a")
    if not file then return end

    local li = list_indication(index)
    if not li then
        file:write(string.format("INDEX %d: nil\n", index))
    else
        file:write(string.format("INDEX %d:\n", index))
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

    index = index + 1
end

BIOS.protocol.endModule()