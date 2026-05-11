-- warp.lua - ระบบวาปรวม
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)

-- ==================== ตั้งค่า ====================
-- นาวาบอส (action = "boss")
local BOSS_X     = 20244
local BOSS_Y     = 10240
local BOSS_MAP   = 80010
local BOSS_WANWA = 16777215

-- นาวาแมพ (action = "map")
local MAP_X      = 20224
local MAP_Y      = 10240
local MAP_MAP    = 80000
local MAP_WANWA  = 16777215

-- วนบอส 1 (action = "boss1") ← ใส่ค่าเอง!
local BOSS1_X     = 0
local BOSS1_Y     = 0
local BOSS1_MAP   = 0
local BOSS1_WANWA = 0

-- วนบอส 2 (action = "boss2") ← ใส่ค่าเอง!
local BOSS2_X     = 0
local BOSS2_Y     = 0
local BOSS2_MAP   = 0
local BOSS2_WANWA = 0

-- วนบอส 3 (action = "boss3") ← ใส่ค่าเอง!
local BOSS3_X     = 0
local BOSS3_Y     = 0
local BOSS3_MAP   = 0
local BOSS3_WANWA = 0

local OFF_WANWA = -74
local OFF_MAP   = -105
local OFF_X     = -120
local OFF_Y     = -122

local action = ... or "boss"
-- ==================================================

-- หา base จาก Saved List
local saved = gg.getListItems()
local base = nil
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

-- ถ้าไม่มี -> ค้นหาครั้งแรก
if base == nil then
    gg.searchNumber("256;256;58::9", gg.TYPE_DWORD)
    if gg.getResultsCount() == 0 then
        gg.alert("❌ ไม่พบฐานวาป\nกรุณาอยู่ในแผนที่ก่อนใช้")
        return
    end

    gg.refineNumber("256", gg.TYPE_DWORD)
    local r = gg.getResults(gg.getResultsCount())
    if #r == 0 then
        gg.alert("❌ ไม่พบ 256")
        return
    end

    for _, v in ipairs(r) do
        if v.value == 256 then
            base = v.address
            break
        end
    end

    if base == nil then
        gg.alert("❌ ไม่พบ 256 ตัวแรก")
        return
    end

    gg.clearResults()
    gg.addListItems({
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, name = "ค่าวนวาป"},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, name = "ค่าวาปแมพ"},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, name = "วาป X"},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, name = "วาป Y"},
    })
end

-- เลือกค่าตาม action
local apply = {}
local name = ""

if action == "boss" then
    name = "นาวาบอส"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS_Y},
    }
elseif action == "map" then
    name = "นาวาแมพ"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = MAP_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = MAP_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = MAP_Y},
    }
elseif action == "boss1" then
    name = "วนบอส 1"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS1_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS1_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS1_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS1_Y},
    }
elseif action == "boss2" then
    name = "วนบอส 2"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS2_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS2_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS2_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS2_Y},
    }
elseif action == "boss3" then
    name = "วนบอส 3"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS3_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS3_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS3_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS3_Y},
    }
end

gg.setValues(apply)
gg.toast("✅ วาป" .. name .. " สำเร็จ!")
gg.setVisible(false)local OFF_WANWA = -74
local OFF_MAP   = -105
local OFF_X     = -120
local OFF_Y     = -122

local action = ... or "boss"
-- ==================================================

-- หา base จาก Saved List
local saved = gg.getListItems()
local base = nil
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

-- ถ้าไม่มี -> ค้นหาครั้งแรก
if base == nil then
    gg.searchNumber("256;256;58::9", gg.TYPE_DWORD)
    if gg.getResultsCount() == 0 then
        gg.alert("❌ ไม่พบฐานวาป\nกรุณาอยู่ในแผนที่ก่อนใช้")
        return
    end

    gg.refineNumber("256", gg.TYPE_DWORD)
    local r = gg.getResults(gg.getResultsCount())
    if #r == 0 then
        gg.alert("❌ ไม่พบ 256")
        return
    end

    for _, v in ipairs(r) do
        if v.value == 256 then
            base = v.address
            break
        end
    end

    if base == nil then
        gg.alert("❌ ไม่พบ 256 ตัวแรก")
        return
    end

    gg.clearResults()
    gg.addListItems({
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, name = "ค่าวนวาป"},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, name = "ค่าวาปแมพ"},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, name = "วาป X"},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, name = "วาป Y"},
    })
end

-- เลือกค่าตาม action
local apply = {}
local name = ""

if action == "boss" then
    name = "นาวาบอส"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS_Y},
    }
elseif action == "map" then
    name = "นาวาแมพ"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = MAP_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = MAP_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = MAP_Y},
    }
elseif action == "boss1" then
    name = "ซนบอส 1"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS1_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS1_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS1_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS1_Y},
    }
elseif action == "boss2" then
    name = "ซนบอส 2"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS2_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS2_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS2_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS2_Y},
    }
elseif action == "boss3" then
    name = "ซนบอส 3"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS3_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS3_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS3_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS3_Y},
    }
end

gg.setValues(apply)
gg.toast("✅ วาป" .. name .. " สำเร็จ!")
gg.setVisible(false)
