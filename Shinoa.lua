-- สคริปต์ GG | 2 ฟังก์ชัน (ตัวตี + ตัวดูด) + ปลดล็อคอีเว้นท์ + กันหลุด + Z-2
-- =============================================
-- 📝 วิธีแก้ไขค่า: เปลี่ยนตัวเลขใน SETTING ด้านล่าง
-- =============================================

-- =============================================
-- ⚔️ ตั้งค่าทั้งหมด (แก้ไขได้ที่นี่)
-- =============================================
local SETTING = {
    -- 🏠 จุดพัก: หลังจากวาปกลับมาจะอยู่ตรงนี้
    rest = {
        vap = "71862",      -- Mapinfo (แผนที่จุดพัก)
        vapX = "28500",     -- X (ตำแหน่ง X จุดพัก)
        vapY = "32000"      -- Y (ตำแหน่ง Y จุดพัก)
    },
    -- 🔵 บอส: จุดที่จะวาปไปตีบอส
    boss = {
        vap = "103297",      -- Mapinfo (แผนที่บอส)
        vapX = "45000",     -- X (ตำแหน่ง X บอส)
        vapY = "10000",     -- Y (ตำแหน่ง Y บอส)
        vapWap = "16777215" -- ค่าวนวาป (ใช้ 16777215)
    },
    -- 🔓 ปลดล็อคอีเว้นท์: ค้นหา 27018;2 → ลง 30 → เปลี่ยนเป็นค่านี้ + ตรึง
    eventUnlock = {
        value = "999999"    -- เปลี่ยนเป็นค่านี้ (ตรึงค้างไว้)
    },
    -- 🎯 เงื่อนไขกลับจุดพัก
    vapZ_check = "3276800", -- Z = ค่านี้ → กลับจุดพักทันที
    checkRoomOut = "30464",   -- Position2 = ค่านี้ → กลับจุดพักทันที
    escapeVap = "999999",      -- ค่าวาป = ค่านี้ → กลับจุดพักทันที (กันหลุด)
    vapZ2_check = "999999",       -- 🆕 Z-2 = ค่านี้ → กลับจุดพักทันที
    -- ⏱️ เวลา (ตัวตี)
    timerLoop1 = 8000,      -- ตัวตี: รอระหว่างวาป (ms) [8000 = 8 วิ]
    timerOut1 = 50,         -- ตัวตี: เช็คทุกกี่ ms [50 = เร็วมาก]
    -- ⏱️ เวลา (ตัวดูด)
    timerLoop2 = 5000,      -- ตัวดูด: รอระหว่างวาป (ms) [5000 = 5 วิ]
    timerOut2 = 50          -- ตัวดูด: เช็คทุกกี่ ms [50 = เร็วมาก]
}
-- =============================================
-- จบการตั้งค่า
-- =============================================

-- =============================================
-- 🔓 ฟังก์ชันปลดล็อคอีเว้นท์ (รันครั้งเดียว)
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

-- =============================================
-- ฟังก์ชันวนบอส (ใช้ร่วมกัน)
-- =============================================
function RunBoss(timerLoop, timerOut, modeName)
    local base = nil
    local firstRun = true
    
    -- 🔓 ปลดล็อคอีเว้นท์ก่อนเริ่ม
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
            local z2 = gg.getValues({{address = base + (13 * 0x4), flags = gg.TYPE_DWORD}})  -- 🆕 Z-2
            local p = gg.getValues({{address = base - (15 * 0x4), flags = gg.TYPE_DWORD}})
            
            -- 🆕 Z-2 = 14 → กลับจุดพัก
            if z2[1].value == SETTING.vapZ2_check then
                gg.toast(modeName .. " 🎯 Z-2 = " .. SETTING.vapZ2_check .. " → 🚀 จุดพัก!")
                gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
            end
            
            -- ค่าวาป = 70300 → กลับจุดพัก
            if v[1].value == SETTING.escapeVap then
                gg.toast(modeName .. " ⚠️ หลุด " .. SETTING.escapeVap .. " → 🚀 จุดพัก!")
                gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
            end
            
            -- Z หรือ Pos2 → กลับจุดพัก
            if z[1].value == SETTING.vapZ_check or p[1].value == SETTING.checkRoomOut then
                gg.toast(modeName .. " 🎯 กลับ!"); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "0", freeze = false},{address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap, freeze = false},{address = base - (15 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapX, freeze = false},{address = base - (17 * 0x4), flags = gg.TYPE_DWORD, value = SETTING.rest.vapY, freeze = false}})
                gg.sleep(50); gg.setValues({{address = base + (31 * 0x4), flags = gg.TYPE_DWORD, value = "16842752", freeze = false}})
                gg.toast(modeName .. " 🚀 ถึงจุดพัก!"); break
            end
        end
    end
end

-- =============================================
-- แก้ไขค่าทั้งหมด
-- =============================================
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

-- =============================================
-- เมนูหลัก
-- =============================================
function MainMenu()
    local menu = gg.choice({
        "⚔️ ตัวตี (รอ " .. (SETTING.timerLoop1/1000) .. " วิ)",
        "🧲 ตัวดูด (รอ " .. (SETTING.timerLoop2/1000) .. " วิ)",
        "✏️ แก้ไขค่าทั้งหมด",
        "🚪 ออก"
    }, nil, "เลือกฟังก์ชัน")
    
    if menu == 1 then
        RunBoss(SETTING.timerLoop1, SETTING.timerOut1, "⚔️")
    elseif menu == 2 then
        RunBoss(SETTING.timerLoop2, SETTING.timerOut2, "🧲")
    elseif menu == 3 then
        EditSettings()
        MainMenu()
    else
        os.exit()
    end
end

MainMenu()
