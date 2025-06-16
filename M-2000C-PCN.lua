BIOS.protocol.beginModule("M-2000C-PCN", 0x0006)
BIOS.protocol.setExportModuleAircrafts({"M-2000C"})

local defineString = BIOS.util.defineString

-- Extrait la ligne PCN_UR_DIGITS du texte brut
local function extractPcnRightDigits()
    local text = list_indication(9)
    if type(text) ~= "string" then return "         " end

    for name, value in string.gmatch(text, "-----------------------------------------\n([^
]+)\n([^
]*)\n") do
        if name:sub(1, 13) == "PCN_UR_DIGITS" then
            value = "         " .. value
            return value:sub(-9)
        end
    end

    return "         "
end

-- Injecte la ligne complète dans le buffer utilisé par le plugin officiel
defineString("INJECT_PCN_DISP_R", extractPcnRightDigits, 9, "PCN", "Right line from PCN_UR_DIGITS")

BIOS.protocol.endModule()