-- บักจ่อย2.lua - ระบบวาปรวม + วนบอส SPโคดัล
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)

local action = ... or "boss"

-- ==================================================
-- 🆕 action = "sp_kodal" → รันสคริปต์วนบอส SPโคดัล
-- ==================================================
if action == "sp_kodal" then
    local SETTING = {
        rest = { vap = "71862", vapX = "28500", vapY = "32000" },
        boss = { vap = "103297", vapX = "45000", vapY = "10000", vapWap = "16777215" },
        eventUnlock = { value = "999999" },
        vapZ_check = "3276800", checkRoomOut = "30464", escapeVap = "999999", vapZ2_check = "999999",
        timerLoop1 = 8000, timerOut1 = 50, timerLoop2 = 5000, timerOut2 = 50
    }

    local eventUnlocked = false
    local eventAddr = nil

    local function UnlockEvent()
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

    local function RunBoss(timerLoop, timerOut, modeName)
        local base = nil
        local firstRun = true
        UnlockEvent()
        while true do
            if base == nil then
                gg.clearResults()
                gg.setRanges(gg.REGION_JAVA_HEAP)
                gg.searchNumber("26000;26000:5", gg.TYPE_DWORD)
                local r = gg.getResults(5)
                if #r < 2 then
                    gg.alert("❌ ไม่พบ 26000;26000:5")
                    return
                end
                base = r[2].address
            end
            if firstRun then
                gg.addListItems({
                    {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, name = "ค่าวาป"},
                    {address = base + 132, flags = gg.TYPE_DWORD, value = "0", name = "ค่าวาปZ"},
                    {address = base + 52, flags = gg.TYPE_DWORD, value = "0", name = "ค่าวาปZ-2"},
                    {address = base + 40, flags = gg.TYPE_DWORD, value = "1", freeze = true, name = "คุยอัตโนมัติ"},
                    {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, name = "ค่าวาปX"},
                    {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, name = "ค่าวาปY"},
                    {address = base + 124, flags = gg.TYPE_DWORD, value = SETTING.boss.vapWap, name = "ค่าวนวาป"}
                })
                firstRun = false
            end
            -- ① จุดพัก
            gg.setValues({
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(modeName .. " ① จุดพัก → รอ " .. (timerLoop/1000) .. " วิ...")
            gg.sleep(timerLoop)
            -- ② ไปบอส
            gg.setValues({
                {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, freeze = true},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, freeze = true},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, freeze = true}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(modeName .. " ② ไปบอส! เช็ค...")
            -- ③ เช็คทั้งหมด
            while true do
                gg.sleep(timerOut)
                local v = gg.getValues({{address = base, flags = gg.TYPE_DWORD}})
                local z = gg.getValues({{address = base + 132, flags = gg.TYPE_DWORD}})
                local z2 = gg.getValues({{address = base + 52, flags = gg.TYPE_DWORD}})
                local p = gg.getValues({{address = base - 60, flags = gg.TYPE_DWORD}})
                local goBack = false
                if z2[1].value == SETTING.vapZ2_check then
                    goBack = true
                elseif v[1].value == SETTING.escapeVap then
                    goBack = true
                elseif z[1].value == SETTING.vapZ_check or p[1].value == SETTING.checkRoomOut then
                    goBack = true
                end
                if goBack then
                    gg.setValues({
                        {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                        {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                        {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                        {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
                    })
                    gg.sleep(50)
                    gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
                    gg.toast(modeName .. " 🚀 ถึงจุดพัก!")
                    break
                end
            end
        end
    end

    local function EditSettings()
        local input = gg.prompt({
            "【🏠 จุดพัก】Map:", "X:", "Y:",
            "【🔵 บอส】Map:", "X:", "Y:",
            "【🔓 ปลดล็อค】ค่า:",
            "【🎯 กลับ】Z:", "Pos2:", "วาปหลุด:", "Z-2:",
            "【⏱️ ตัวตี】รอ(ms):", "เช็ค(ms):",
            "【⏱️ ตัวดูด】รอ(ms):", "เช็ค(ms):"
        }, {
            SETTING.rest.vap, SETTING.rest.vapX, SETTING.rest.vapY,
            SETTING.boss.vap, SETTING.boss.vapX, SETTING.boss.vapY,
            SETTING.eventUnlock.value,
            SETTING.vapZ_check, SETTING.checkRoomOut, SETTING.escapeVap, SETTING.vapZ2_check,
            tostring(SETTING.timerLoop1), tostring(SETTING.timerOut1),
            tostring(SETTING.timerLoop2), tostring(SETTING.timerOut2)
        }, {
            "number","number","number","number","number","number","number",
            "number","number","number","number","number","number","number","number"
        })
        if input then
            SETTING.rest.vap = input[1]
            SETTING.rest.vapX = input[2]
            SETTING.rest.vapY = input[3]
            SETTING.boss.vap = input[4]
            SETTING.boss.vapX = input[5]
            SETTING.boss.vapY = input[6]
            SETTING.eventUnlock.value = input[7]
            SETTING.vapZ_check = input[8]
            SETTING.checkRoomOut = input[9]
            SETTING.escapeVap = input[10]
            SETTING.vapZ2_check = input[11]
            SETTING.timerLoop1 = tonumber(input[12])
            SETTING.timerOut1 = tonumber(input[13])
            SETTING.timerLoop2 = tonumber(input[14])
            SETTING.timerOut2 = tonumber(input[15])
            gg.toast("✅ ตั้งค่าแล้ว!")
        end
    end

    local function MainMenu()
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

-- ตั้งค่าสำหรับวาปปกติ
local OFF_WANWA = -74
local OFF_MAP = -105
local OFF_X = -120
local OFF_Y = -122

local BOSS_X = 20244
local BOSS_Y = 10240
local BOSS_MAP = 80010
local BOSS_WANWA = 16777215

local MAP_X = 20224
local MAP_Y = 10240
local MAP_MAP = 80000
local MAP_WANWA = 16777215

local BOSS2_X = 0
local BOSS2_Y = 0
local BOSS2_MAP = 0
local BOSS2_WANWA = 0

local BOSS3_X = 0
local BOSS3_Y = 0
local BOSS3_MAP = 0
local BOSS3_WANWA = 0

-- หา base จาก Saved List
local saved = gg.getListItems()
local base = nil
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

-- ถ้าไม่มี → ค้นหาครั้งแรก
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
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, name = "ค่าวาปแมพ"},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, name = "วาป X"},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, name = "วาป Y"},
    })
end

-- เลือกค่าตาม action
local apply = {}
local name = ""

if action == "boss" then
    name = "นาวาบอส"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS_Y},
    }
elseif action == "map" then
    name = "นาวาแมพ"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = MAP_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = MAP_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = MAP_Y},
    }
elseif action == "boss2" then
    name = "วนบอส 2"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS2_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS2_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS2_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS2_Y},
    }
elseif action == "boss3" then
    name = "วนบอส 3"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS3_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS3_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS3_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS3_Y},
    }
end

gg.setValues(apply)
gg.toast("✅ วาป" .. name .. " สำเร็จ!")
gg.setVisible(false)                firstRun = false
            end
            -- ① จุดพัก
            gg.setValues({
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(modeName .. " ① จุดพัก → รอ " .. (timerLoop/1000) .. " วิ...")
            gg.sleep(timerLoop)
            -- ② ไปบอส
            gg.setValues({
                {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, freeze = true},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, freeze = true},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, freeze = true}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(modeName .. " ② ไปบอส! เช็ค...")
            -- ③ เช็คทั้งหมด
            while true do
                gg.sleep(timerOut)
                local v = gg.getValues({{address = base, flags = gg.TYPE_DWORD}})
                local z = gg.getValues({{address = base + 132, flags = gg.TYPE_DWORD}})
                local z2 = gg.getValues({{address = base + 52, flags = gg.TYPE_DWORD}})
                local p = gg.getValues({{address = base - 60, flags = gg.TYPE_DWORD}})
                local goBack = false
                if z2[1].value == SETTING.vapZ2_check then
                    goBack = true
                elseif v[1].value == SETTING.escapeVap then
                    goBack = true
                elseif z[1].value == SETTING.vapZ_check or p[1].value == SETTING.checkRoomOut then
                    goBack = true
                end
                if goBack then
                    gg.setValues({
                        {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                        {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                        {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                        {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
                    })
                    gg.sleep(50)
                    gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
                    gg.toast(modeName .. " 🚀 ถึงจุดพัก!")
                    break
                end
            end
        end
    end

    local function EditSettings()
        local input = gg.prompt({
            "【🏠 จุดพัก】Map:", "X:", "Y:",
            "【🔵 บอส】Map:", "X:", "Y:",
            "【🔓 ปลดล็อค】ค่า:",
            "【🎯 กลับ】Z:", "Pos2:", "วาปหลุด:", "Z-2:",
            "【⏱️ ตัวตี】รอ(ms):", "เช็ค(ms):",
            "【⏱️ ตัวดูด】รอ(ms):", "เช็ค(ms):"
        }, {
            SETTING.rest.vap, SETTING.rest.vapX, SETTING.rest.vapY,
            SETTING.boss.vap, SETTING.boss.vapX, SETTING.boss.vapY,
            SETTING.eventUnlock.value,
            SETTING.vapZ_check, SETTING.checkRoomOut, SETTING.escapeVap, SETTING.vapZ2_check,
            tostring(SETTING.timerLoop1), tostring(SETTING.timerOut1),
            tostring(SETTING.timerLoop2), tostring(SETTING.timerOut2)
        }, {
            "number","number","number","number","number","number","number",
            "number","number","number","number","number","number","number","number"
        })
        if input then
            SETTING.rest.vap = input[1]
            SETTING.rest.vapX = input[2]
            SETTING.rest.vapY = input[3]
            SETTING.boss.vap = input[4]
            SETTING.boss.vapX = input[5]
            SETTING.boss.vapY = input[6]
            SETTING.eventUnlock.value = input[7]
            SETTING.vapZ_check = input[8]
            SETTING.checkRoomOut = input[9]
            SETTING.escapeVap = input[10]
            SETTING.vapZ2_check = input[11]
            SETTING.timerLoop1 = tonumber(input[12])
            SETTING.timerOut1 = tonumber(input[13])
            SETTING.timerLoop2 = tonumber(input[14])
            SETTING.timerOut2 = tonumber(input[15])
            gg.toast("✅ ตั้งค่าแล้ว!")
        end
    end

    local function MainMenu()
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

-- ตั้งค่าสำหรับวาปปกติ
local OFF_WANWA = -74
local OFF_MAP = -105
local OFF_X = -120
local OFF_Y = -122

local BOSS_X = 20244
local BOSS_Y = 10240
local BOSS_MAP = 80010
local BOSS_WANWA = 16777215

local MAP_X = 20224
local MAP_Y = 10240
local MAP_MAP = 80000
local MAP_WANWA = 16777215

local BOSS2_X = 0
local BOSS2_Y = 0
local BOSS2_MAP = 0
local BOSS2_WANWA = 0

local BOSS3_X = 0
local BOSS3_Y = 0
local BOSS3_MAP = 0
local BOSS3_WANWA = 0

-- หา base จาก Saved List
local saved = gg.getListItems()
local base = nil
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

-- ถ้าไม่มี → ค้นหาครั้งแรก
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
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, name = "ค่าวาปแมพ"},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, name = "วาป X"},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, name = "วาป Y"},
    })
end

-- เลือกค่าตาม action
local apply = {}
local name = ""

if action == "boss" then
    name = "นาวาบอส"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS_Y},
    }
elseif action == "map" then
    name = "นาวาแมพ"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = MAP_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = MAP_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = MAP_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = MAP_Y},
    }
elseif action == "boss2" then
    name = "วนบอส 2"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS2_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS2_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS2_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS2_Y},
    }
elseif action == "boss3" then
    name = "วนบอส 3"
    apply = {
        {address = base + (OFF_WANWA * 4), flags = gg.TYPE_DWORD, value = BOSS3_WANWA},
        {address = base + (OFF_MAP * 4), flags = gg.TYPE_DWORD, value = BOSS3_MAP},
        {address = base + (OFF_X * 4), flags = gg.TYPE_DWORD, value = BOSS3_X},
        {address = base + (OFF_Y * 4), flags = gg.TYPE_DWORD, value = BOSS3_Y},
    }
end

gg.setValues(apply)
gg.toast("✅ วาป" .. name .. " สำเร็จ!")
gg.setVisible(false)        local menu = gg.choice({
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
