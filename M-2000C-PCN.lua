BIOS.protocol.beginModule("M-2000C-PCN", 0x000A)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString
local lfs = require("lfs")

-- Parser Helios-style
local function parseIndication(text)
    local result = {}
    for line in string.gmatch(text or "", "[^\n]+") do
        local key, val = line:match("^([%w_]+)%s*:%s*(.+)$")
        if key and val then
            result[key] = val
        end
    end
    return result
end

-- Fonction principale : logge chaque segment
local function logSegmentsOnly()
    local text = list_indication(9)
    if type(text) ~= "string" then return "      " end

    local li = parseIndication(text)

    local seg_keys = {
        "PCN_UR_SEG0", "PCN_UR_SEG1", "PCN_UR_SEG2",
        "PCN_UR_SEG3", "PCN_UR_SEG4", "PCN_UR_SEG5",
        "PCN_UR_SEG6"
    }

    local file = io.open(lfs.writedir() .. "/Logs/pcn_debug_segments.log", "a")
    if file then
        file:write("---- Frame ----\n")
        for _, key in ipairs(seg_keys) do
            file:write(string.format("%s = %s\n", key, tostring(li[key] or "nil")))
        end
        file:close()
    end

    return "      "
end

-- Injection factice pour déclencher l'exécution
defineString("DUMP_PCN_SEGMENTS", logSegmentsOnly, 6, "PCN", "Dump raw PCN segment data")

BIOS.protocol.endModule()