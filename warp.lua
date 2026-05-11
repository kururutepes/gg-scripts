-- Iruna Online TH
-- ครั้งแรกค้นหา 256;256;58::9 Dword → เซฟ → ครั้งต่อไปใช้เซฟได้เลย
-- ใช้ต่อเนื่อง: แตะไอคอน GG → เมนูโผล่ → กดวาป → วาป + พับทันที (ไม่ต้องรอ)
-- อยากวาปอีก: แตะไอคอน GG อีก → เมนูโผล่เลย

gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)

-- ==================== ตั้งค่าแก้ไขเองได้ตรงนี้ ====================
local BOSS_X     = 20244    -- นาวาบอส X
local BOSS_Y     = 10240    -- นาวาบอส Y
local BOSS_MAP   = 80010    -- นาวาบอส แมพ
local BOSS_WANWA = 16777215 -- นาวาบอส วนวาป

local MAP_X      = 20224    -- นาวาแมพ X
local MAP_Y      = 10240    -- นาวาแมพ Y
local MAP_MAP    = 80000    -- นาวาแมพ แมพ
local MAP_WANWA  = 16777215 -- นาวาแมพ วนวาป
-- ================================================================

local OFF_WANWA = -74
local OFF_MAP   = -105
local OFF_X     = -120
local OFF_Y     = -122

local base = nil

-- ลองดึง base จากค่าที่เซฟไว้ใน Saved List
local saved = gg.getListItems()
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

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
