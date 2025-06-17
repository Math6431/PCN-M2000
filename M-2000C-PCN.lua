BIOS.protocol.beginModule("M-2000C-PCN", 0x000B)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString
local lfs = require("lfs")

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

local segDecode = {
    ["****** "] = "0", [" **    "] = "1", ["** ** *"] = "2",
    ["****  *"] = "3", [" **  **"] = "4", ["* ** **"] = "5",
    ["* *****"] = "6", ["***    "] = "7", ["*******"] = "8",
    ["**** **"] = "9"
}

local function decode7Seg(raw)
    raw = raw:gsub("[a-zA-Z]", "*"):gsub("[^*]", " ")
    local result = ""
    for i = 0, 5 do
        local seg = raw:sub(i*6+1, i*6+6)
        result = result .. (segDecode[seg] or " ")
    end
    return result
end

local function getPcnDispR()
    local text = list_indication(9)
    if type(text) ~= "string" then return "      " end

    local li = parseIndication(text)

    local raw = string.format("%6s%6s%6s%6s%6s%6s",
        li["PCN_UR_SEG2"] or "",
        li["PCN_UR_SEG3"] or "",
        li["PCN_UR_SEG4"] or "",
        li["PCN_UR_SEG5"] or "",
        li["PCN_UR_SEG0"] or "",
        li["PCN_UR_SEG1"] or ""
    )

    local decoded = decode7Seg(raw)

    local file = io.open(lfs.writedir() .. "/Logs/pcn_debug_plugin.log", "a")
    if file then
        file:write("PCN_SEG_RAW = ", raw, "\n")
        file:write("PCN_DISP_R decoded = ", decoded, "\n")
        file:close()
    end

    return decoded
end

defineString("PCN_DISP_R", getPcnDispR, 6, "PCN", "PCN right display (segments)")

BIOS.protocol.endModule()