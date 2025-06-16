BIOS.protocol.beginModule("M-2000C-PCN", 0x0007)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString
local lfs = require("lfs")

-- Parse Helios-style clé: valeur
local function parseHeliosStringBlock(block)
    local result = {}
    for line in string.gmatch(block or "", "[^\n]+") do
        local key, val = line:match("^([%w_]+)%s*:%s*(.+)$")
        if key and val then
            result[key] = val
        end
    end
    return result
end

-- Extraction de PCN_UR_DIGITS et log
local function extractPcnRightDigits()
    local text = list_indication(9)
    if type(text) ~= "string" then return "         " end

    local li = parseHeliosStringBlock(text)
    local value = li["PCN_UR_DIGITS"]

    -- Log pour débogage
    local file = io.open(lfs.writedir() .. "/Logs/pcn_debug.log", "a")
    if file then
        file:write("PCN_UR_DIGITS raw = ", tostring(value), "\n")
        file:close()
    end

    if not value then return "         " end

    value = "         " .. value
    return value:sub(-9)
end

defineString("INJECT_PCN_DISP_R", extractPcnRightDigits, 9, "PCN", "Right line from PCN_UR_DIGITS (parsed)")

BIOS.protocol.endModule()