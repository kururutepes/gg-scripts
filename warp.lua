-- Wrap.lua - ระบบวาปรวม + วนบอส SPโคดัล
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

-- ==================================================
-- 🆕 ถ้า action = "sp_kodal" → รันสคริปต์วนบอส SPโคดัล
-- ==================================================
if action == "sp_kodal" then
    -- =============================================
    -- ⚔️ ตั้งค่าทั้งหมด (แก้ไขได้ที่นี่)
    -- =============================================
    local SETTING = {
        rest = {
            vap = "71862",
            vapX = "28500",
            vapY = "32000"
        },
        boss = {
            vap = "103297",
            vapX = "45000",
            vapY = "10000",
            vapWap = "16777215"
        },
        eventUnlock = {
            value = "999999"
        },
        vapZ_check = "3276800",
        checkRoomOut = "30464",
        escapeVap = "999999",
        vapZ2_check = "999999",
        timerLoop1 = 8000,
        timerOut1 = 50,
        timerLoop2 = 5000,
        timerOut2 = 50
    }
    -- =============================================
    -- จบการตั้งค่า
    -- =============================================

    local eventUnlocked = false
    local eventAddr = nil

    function UnlockEvent()
        if eventUnlocked then return end
        gg.clearResults()
        gg.setRanges(gg.REGION_JAVA_HEAP)
        gg.searchNumber("27018;2", gg.TYPE_DWORD)
        gg.refineNumber("27018", gg.TYPE_DWORD)
        local results = gg.getResults(99999)
        if #results == 0 then
            gg.toast("❌ ไม่พบ 27018")
            return
        end
        eventAddr = results[1].address - (30 * 0x4)
        gg.setValues({{
            address = eventAddr,
            flags = gg.TYPE_DWORD,
            value = SETTING.eventUnlock.value,
            freeze = true
        }})
        gg.addListItems({{
            address = eventAddr,
            flags = gg.TYPE_DWORD,
            value = SETTING.eventUnlock.value,
            freeze = true,
            name = "ปลดล็อคอีเว้นท์"
        }})
        gg.clearResults()
        eventUnlocked = true
        gg.toast("🔓 ปลดล็อคอีเว้นท์ → " .. SETTING.eventUnlock.value .. " ❄️ ตรึง")
    end

    function RunBoss(timerLoop, timerOut, modeName)
        local base = nil
        local firstRun = true
        UnlockEvent()
        while true do
            if base == nil then
                gg.clearResults(); gg.setRanges(gg.REGION_JAVA_HEAP)
                gg.searchNumber("26000;26000:5", gg.TYPE_DWORD)
                local r = gg.getResults(5)
                if #r < 2 then gg.alert("❌ ไม่พบ 26000;26000:5") return end
                base = r[2].address
            end
            if firstRun then
                gg.addListItems({
                    {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, freeze = false, name = "ค่าวาป"},
                    {address = base + (33 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false, name = "ค่าวาปZ"},
                    {address = base + (13 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false, name = "ค่าวาปZ-2"},
                    {address = base + (10 * 0x4), flags = gg.TYPE_DWORD, value = "1", freeze = true, name = "คุยอัตโนมัติ"},
                    {address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, freeze = false, name = "ค่าวาปX"},
                    {address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, freeze = false, name = "ค่าวาปY"},
                    {address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.boss.vapWap, freeze = false, name = "ค่าวนวาป"}
                }); firstRun = false
            end
            -- ① จุดพัก
            gg.setValues({{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
            gg.sleep(100); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
            gg.toast(modeName .. " ① จุดพัก → รอ " .. (timerLoop/1000) .. " วิ..."); gg.sleep(timerLoop)
            -- ② ไปบอส
            gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, freeze = true},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, freeze = true},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, freeze = true}})
            gg.sleep(100); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
            gg.toast(modeName .. " ② ไปบอส! เช็ค...")
            -- ③ เช็คทั้งหมด
            while true do
                gg.sleep(timerOut)
                local v = gg.getValues({{address = base, flags = gg.TYPE_DWORD}})
                local z = gg.getValues({{address = base + (33 * 0x4), flags = gg.TYPE_DWORD}})
                local z2 = gg.getValues({{address = base + (13 * 0x4), flags = gg.TYPE_DWORD}})
                local p = gg.getValues({{address = base - (15 * 0x4), flags = gg.TYPE_DWORD}})
                
                if z2[1].value == SETTING.vapZ2_check then
                    gg.toast(modeName .. " 🎯 Z-2 = " .. SETTING.vapZ2_check .. " → 🚀 จุดพัก!")
                    gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                    gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                    gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
                end
                
                if v[1].value == SETTING.escapeVap then
                    gg.toast(modeName .. " ⚠️ หลุด " .. SETTING.escapeVap .. " → 🚀 จุดพัก!")
                    gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                    gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                    gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
                end
                
                if z[1].value == SETTING.vapZ_check or p[1].value == SETTING.checkRoomOut then
                    gg.toast(modeName .. " 🎯 กลับ!"); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                    gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                    gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
                end
            end
        end
    end

    function EditSettings()
        local input = gg.prompt({
            "【🏠 จุดพัก】",
            "Map:", "X:", "Y:",
            "",
            "【🔵 บอส】",
            "Map:", "X:", "Y:",
            "",
            "【🔓 ปลดล็อคอีเว้นท์】",
            "ค่า:", "",
            "【🎯 เงื่อนไขกลับ】",
            "Z → กลับ:", "Pos2 → กลับ:", "⚠️ วาปหลุด → กลับ:", "🆕 Z-2 → กลับ:",
            "",
            "【⏱️ ตัวตี】",
            "รอวาป (ms):", "เช็คทุก (ms):",
            "",
            "【⏱️ ตัวดูด】",
            "รอวาป (ms):", "เช็คทุก (ms):"
        }, {
            SETTING.rest.vap, SETTING.rest.vapX, SETTING.rest.vapY,
            "",
            SETTING.boss.vap, SETTING.boss.vapX, SETTING.boss.vapY,
            "",
            SETTING.eventUnlock.value, "",
            SETTING.vapZ_check, SETTING.checkRoomOut, SETTING.escapeVap, SETTING.vapZ2_check,
            "",
            tostring(SETTING.timerLoop1), tostring(SETTING.timerOut1),
            "",
            tostring(SETTING.timerLoop2), tostring(SETTING.timerOut2)
        }, {
            "number","number","number","","number","number","number","","number","","number","number","number","number","","number","number","","number","number"
        })
        
        if input ~= nil then
            SETTING.rest.vap = input[1]; SETTING.rest.vapX = input[2]; SETTING.rest.vapY = input[3]
            SETTING.boss.vap = input[5]; SETTING.boss.vapX = input[6]; SETTING.boss.vapY = input[7]
            SETTING.eventUnlock.value = input[9]
            SETTING.vapZ_check = input[11]; SETTING.checkRoomOut = input[12]
            SETTING.escapeVap = input[13]; SETTING.vapZ2_check = input[14]
            SETTING.timerLoop1 = tonumber(input[16]); SETTING.timerOut1 = tonumber(input[17])
            SETTING.timerLoop2 = tonumber(input[19]); SETTING.timerOut2 = tonumber(input[20])
            gg.toast("✅ ตั้งค่าแล้ว!")
        end
    end

    function MainMenu()
        local menu = gg.choice({
            "⚔️ ตัวตี (รอ " .. (SETTING.timerLoop1/1000) .. " วิ)",
            "🧲 ตัวดูด (รอ " .. (SETTING.timerLoop2/1000) .. " วิ)",
            "✏️ แก้ไขค่าทั้งหมด",
            "🚪 ออก"
        }, nil, "🐉 SPโคดัล - เลือกฟังก์ชัน")
        
        if menu == 1 then
            RunBoss(SETTING.timerLoop1, SETTING.timerOut1, "⚔️")
        elseif menu == 2 then
            RunBoss(SETTING.timerLoop2, SETTING.timerOut2, "🧲")
        elseif menu == 3 then
            EditSettings()
            MainMenu()
        else
            gg.setVisible(false)
            return
        end
    end

    MainMenu()
    return
end

-- ==================================================
-- จบส่วน sp_kodal
-- ==================================================

-- หา base จาก Saved List (สำหรับวาปปกติ)
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
gg.setVisible(false)    if base == nil then
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
