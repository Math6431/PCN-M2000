BIOS.protocol.beginModule("M-2000C-PCN", 0x0000)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString

local function decodePCNRight()
    local li = list_indication(9)
    if not li then return "      " end

    local raw = string.format("%6s%6s%6s%6s%6s%6s%6s",
        li["PCN_UR_SEG2"] or "",
        li["PCN_UR_SEG3"] or "",
        li["PCN_UR_SEG4"] or "",
        li["PCN_UR_SEG5"] or "",
        li["PCN_UR_SEG0"] or "",
        li["PCN_UR_SEG1"] or "",
        li["PCN_UR_SEG6"] or "")

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

-- Utilisation d'un identifiant fantôme pour provoquer l'écriture dans le buffer partagé 0x72f6
defineString("INJECT_PCN_DISP_R", decodePCNRight, 6, "PCN", "Inject Right Display via defineString")

BIOS.protocol.endModule()