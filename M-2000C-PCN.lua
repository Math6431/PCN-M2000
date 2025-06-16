BIOS.protocol.beginModule("M-2000C-PCN", 0x0002)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local lfs = require("lfs")

moduleBeingDefined.exportHooks[#moduleBeingDefined.exportHooks+1] = function()
    for i = 0, 20 do
        local li = list_indication(i)
        local file = io.open(lfs.writedir() .. "/Logs/pcn_debug_index_" .. i .. ".log", "a")
        if not file then return end

        if li then
            local hasData = false
            for k, v in pairs(li) do
                if not hasData then
                    file:write(string.format("INDEX %d:
", i))
                    hasData = true
                end
                file:write(string.format("  %s = %s\n", tostring(k), tostring(v)))
            end
            if not hasData then
                file:write(string.format("INDEX %d: empty table\n", i))
            end
        else
            file:write(string.format("INDEX %d: nil\n", i))
        end
        file:close()
    end
end

BIOS.protocol.endModule()