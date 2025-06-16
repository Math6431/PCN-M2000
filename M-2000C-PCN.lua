BIOS.protocol.beginModule("M-2000C-PCN", 0x72f6)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString

-- Extraction des 6 digits 7 segments (droite) depuis list_indication(9)
defineString("PCN_DISP_R", function()
    local li = list_indication(9)
    if not li then return "      " end

    -- Collecte brute des segments Helios (ordre spécifique)
    local raw = string.format("%6s%6s%6s%6s%6s%6s%6s",
        li["PCN_UR_SEG2"] or "",
        li["PCN_UR_SEG3"] or "",
        li["PCN_UR_SEG4"] or "",
        li["PCN_UR_SEG5"] or "",
        li["PCN_UR_SEG0"] or "",
        li["PCN_UR_SEG1"] or "",
        li["PCN_UR_SEG6"] or "")

    -- Décodage simple en remplaçant tous les caractères allumés par "*"
    raw = raw:gsub("[a-zA-Z]", "*"):gsub("[^*]", " ")

    -- Fonction de décodage très simplifiée
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
end, 6, "PCN Display", "PCN DISP R - Right 6 Digits")

BIOS.protocol.endModule()