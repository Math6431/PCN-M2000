BIOS.protocol.beginModule("M-2000C-PCN", 0x0005)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString

-- Fonction qui parse une chaîne style Helios
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

-- Décodage des digits à partir du texte brut de list_indication(9)
local function decodePCNFromString()
    local raw_str = list_indication(9)
    if type(raw_str) ~= "string" then return "      " end

    local li = parseHeliosStringBlock(raw_str)

    local segs = {
        li["PCN_UR_SEG2"] or "",
        li["PCN_UR_SEG3"] or "",
        li["PCN_UR_SEG4"] or "",
        li["PCN_UR_SEG5"] or "",
        li["PCN_UR_SEG0"] or "",
        li["PCN_UR_SEG1"] or "",
        li["PCN_UR_SEG6"] or ""
    }

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

    return result
end

-- Déclenche l’écriture automatique dans le buffer mémoire partagé
defineString("INJECT_PCN_DISP_R", decodePCNFromString, 6, "PCN", "Inject PCN R via string decode")

BIOS.protocol.endModule()