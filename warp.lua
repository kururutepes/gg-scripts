-- warp.lua - เพิ่มส่วนนี้

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

-- ซนบอส 1 (action = "boss1") ← ใส่ค่าเอง!
local BOSS1_X     = 0
local BOSS1_Y     = 0
local BOSS1_MAP   = 0
local BOSS1_WANWA = 0

-- ซนบอส 2 (action = "boss2") ← ใส่ค่าเอง!
local BOSS2_X     = 0
local BOSS2_Y     = 0
local BOSS2_MAP   = 0
local BOSS2_WANWA = 0

-- ซนบอส 3 (action = "boss3") ← ใส่ค่าเอง!
local BOSS3_X     = 0
local BOSS3_Y     = 0
local BOSS3_MAP   = 0
local BOSS3_WANWA = 0
-- ==================================================

-- ... (ส่วนค้นหา base เหมือนเดิม) ...

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
-- ถ้ายังไม่มีเซฟ → ค้นหาครั้งแรก
if base == nil then
    gg.searchNumber("256;256;58::9", gg.TYPE_DWORD)
    if gg.getResultsCount() == 0 then
        gg.alert("ไม่พบผลลัพธ์")
        return
    end

    gg.refineNumber("256", gg.TYPE_DWORD)
    local r = gg.getResults(gg.getResultsCount())
    if #r == 0 then
        gg.alert("ไม่พบ 256")
        return
    end

    for i, v in ipairs(r) do
        if v.value == 256 then
            base = v.address
            break
        end
    end

    if base == nil then
        gg.alert("ไม่พบ 256 ตัวแรก")
        return
    end

    -- เซฟครั้งแรกลง Saved List
    gg.clearResults()
    gg.addListItems({
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, name = "ค่าวนวาป"},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, name = "ค่าวาปแมพ"},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, name = "วาป X"},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, name = "วาป Y"},
    })
end

-- ==================== ฟังก์ชันวาป (เร็ว ไม่มี toast) ====================
local function warp(choice)
    local apply = {}
    if choice == 1 then
        apply = {
            {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS_WANWA},
            {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = BOSS_MAP},
            {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS_X},
            {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS_Y},
        }
    else
        apply = {
            {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
            {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = MAP_MAP},
            {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = MAP_X},
            {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = MAP_Y},
        }
    end

    gg.setValues(apply)
    gg.setVisible(false) -- วาปเสร็จ → พับ GG ทันที (ไม่ต้อง toast)
end

-- ==================== วนลูปหลัก ====================
while true do
    -- รอจนกว่าจะแตะไอคอน GG
    while not gg.isVisible() do
        gg.sleep(100) -- เช็คถี่ขึ้น = ไวขึ้น
    end

    -- แสดงเมนูวาป
    local menu = gg.choice({
        "🐉 นาวาบอส",
        "🗺️ นาวาแมพ",
        "❌ ออก",
    })

    if menu == nil or menu == 3 then
        gg.setVisible(false)
        break
    else
        warp(menu)
    end
end        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = BOSS_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = BOSS_Y},
    }
else
    name = "แมพ"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
        {address = base + (OFF_MAP * 4),   flags = gg.TYPE_DWORD, value = MAP_MAP},
        {address = base + (OFF_X * 4),     flags = gg.TYPE_DWORD, value = MAP_X},
        {address = base + (OFF_Y * 4),     flags = gg.TYPE_DWORD, value = MAP_Y},
    }
end

gg.setValues(apply)
gg.toast("✅ วาป" .. name .. " สำเร็จ!")
gg.setVisible(false)
