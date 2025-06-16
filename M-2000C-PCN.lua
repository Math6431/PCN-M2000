BIOS.protocol.beginModule("M-2000C-PCN", 0x0008)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString
local lfs = require("lfs")

-- Fonction de parsing Helios-style
local function parseHeliosIndication(text)
    local result = {}
    for line in string.gmatch(text or "", "[^\n]+") do
        local key, val = line:match("^([%w_]+)%s*:%s*(.+)$")
        if key and val then
            result[key] = val
        end
    end
    return result
end

-- Décodage de segments 7 segments -> chiffres
local function decodePCNDigits()
    local text = list_indication(9)
    if type(text) ~= "string" then return "      " end

    local li = parseHeliosIndication(text)

    local segs = {
        li["PCN_UR_SEG2"] or "",
        li["PCN_UR_SEG3"] or "",
        li["PCN_UR_SEG4"] or "",
        li["PCN_UR_SEG5"] or "",
        li["PCN_UR_SEG0"] or "",
        li["PCN_UR_SEG1"] or ""
    }

    -- concatène les segments
    local raw = table.concat(segs)
    raw = raw:gsub("[a-zA-Z]", "*"):gsub("[^*]", " ")

    local segDecode = {
        ["****** "] = "0", [" **    "] = "1", ["** ** *"] = "2",
        ["****  *"] = "3", [" **  **"] = "4", ["* ** **"] = "5",
        ["* *****"] = "6", ["***    "] = "7", ["*******"] = "8",
        ["**** **"] = "9"
    }

    local result = ""
    for i = 0, 5 do
        local seg = raw:sub(i*6+1, i*6+6)
        result = result .. (segDecode[seg] or " ")
    end

    -- Log de debug
    local file = io.open(lfs.writedir() .. "/Logs/pcn_debug.log", "a")
    if file then
        file:write("PCN_DISP_R decoded = ", result, "\n")
        file:close()
    end

    return result
end

-- Écriture automatique dans buffer partagé
defineString("INJECT_PCN_DISP_R", decodePCNDigits, 6, "PCN", "Right PCN display decoded")

BIOS.protocol.endModule()