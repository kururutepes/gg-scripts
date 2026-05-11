gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)

local action = ... or "boss"

if action == "sp" then
    gg.toast("🐉 กำลังโหลด SPโคดัล...")
    gg.sleep(500)
    
    local SETTING = {
        rest = { vap = "71862", vapX = "28500", vapY = "32000" },
        boss = { vap = "103297", vapX = "45000", vapY = "10000", vapWap = "16777215" },
        eventUnlock = { value = "999999" },
        vapZ_check = "3276800",
        checkRoomOut = "30464",
        escapeVap = "999999",
        vapZ2_check = "999999",
        timerLoop1 = 8000,
        timerOut1 = 50,
        timerLoop2 = 5000,
        timerOut2 = 50
    }

    local eventUnlocked = false

    local function unlockEvent()
        if eventUnlocked then return end
        gg.setRanges(gg.REGION_JAVA_HEAP)
        gg.searchNumber("27018;2", gg.TYPE_DWORD)
        gg.refineNumber("27018", gg.TYPE_DWORD)
        local r = gg.getResults(99999)
        if #r == 0 then
            gg.toast("❌ ไม่พบอีเว้นท์")
            return
        end
        local addr = r[1].address - 120
        gg.setValues({{
            address = addr,
            flags = gg.TYPE_DWORD,
            value = SETTING.eventUnlock.value,
            freeze = true
        }})
        gg.addListItems({{
            address = addr,
            flags = gg.TYPE_DWORD,
            value = SETTING.eventUnlock.value,
            freeze = true,
            name = "ปลดล็อคอีเว้นท์"
        }})
        gg.clearResults()
        eventUnlocked = true
        gg.toast("🔓 ปลดล็อคแล้ว!")
    end

    local function runLoop(timerLoop, timerOut, name)
        unlockEvent()
        local base = nil
        local ok = false
        
        gg.setRanges(gg.REGION_JAVA_HEAP)
        gg.searchNumber("26000;26000:5", gg.TYPE_DWORD)
        local r = gg.getResults(5)
        if #r >= 2 then
            base = r[2].address
            ok = true
        end
        
        if not ok then
            gg.alert("❌ ไม่พบฐาน กรุณาอยู่ในแผนที่")
            return
        end
        
        gg.addListItems({
            {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, name = "ค่าวาป"},
            {address = base + 132, flags = gg.TYPE_DWORD, value = "0", name = "ค่าวาปZ"},
            {address = base + 52, flags = gg.TYPE_DWORD, value = "0", name = "ค่าวาปZ-2"},
            {address = base + 40, flags = gg.TYPE_DWORD, value = "1", freeze = true, name = "คุยอัตโนมัติ"},
            {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, name = "ค่าวาปX"},
            {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, name = "ค่าวาปY"},
            {address = base + 124, flags = gg.TYPE_DWORD, value = SETTING.boss.vapWap, name = "ค่าวนวาป"}
        })
        
        while true do
            gg.setValues({
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(name .. " จุดพัก รอ " .. (timerLoop/1000) .. " วิ")
            gg.sleep(timerLoop)
            
            gg.setValues({
                {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                {address = base, flags = gg.TYPE_DWORD, value = SETTING.boss.vap, freeze = true},
                {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.boss.vapX, freeze = true},
                {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.boss.vapY, freeze = true}
            })
            gg.sleep(100)
            gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
            gg.toast(name .. " ไปบอส!")
            
            while true do
                gg.sleep(timerOut)
                local v = gg.getValues({
                    {address = base, flags = gg.TYPE_DWORD},
                    {address = base + 132, flags = gg.TYPE_DWORD},
                    {address = base + 52, flags = gg.TYPE_DWORD},
                    {address = base - 60, flags = gg.TYPE_DWORD}
                })
                local goBack = false
                if v[3].value == SETTING.vapZ2_check then goBack = true end
                if v[1].value == SETTING.escapeVap then goBack = true end
                if v[2].value == SETTING.vapZ_check then goBack = true end
                if v[4].value == SETTING.checkRoomOut then goBack = true end
                
                if goBack then
                    gg.setValues({
                        {address = base + 124, flags = gg.TYPE_DWORD, value = "0"},
                        {address = base, flags = gg.TYPE_DWORD, value = SETTING.rest.vap},
                        {address = base - 60, flags = gg.TYPE_DWORD, value = SETTING.rest.vapX},
                        {address = base - 68, flags = gg.TYPE_DWORD, value = SETTING.rest.vapY}
                    })
                    gg.sleep(50)
                    gg.setValues({{address = base + 124, flags = gg.TYPE_DWORD, value = "16842752"}})
                    gg.toast(name .. " กลับจุดพัก!")
                    break
                end
            end
        end
    end

    local menu = gg.choice({
        "⚔️ ตัวตี (รอ " .. (SETTING.timerLoop1/1000) .. " วิ)",
        "🧲 ตัวดูด (รอ " .. (SETTING.timerLoop2/1000) .. " วิ)",
        "🚪 ออก"
    }, nil, "🐉 SPโคดัล")
    
    if menu == 1 then
        runLoop(SETTING.timerLoop1, SETTING.timerOut1, "⚔️")
    elseif menu == 2 then
        runLoop(SETTING.timerLoop2, SETTING.timerOut2, "🧲")
    end
    
    gg.setVisible(false)
    return
end

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

local saved = gg.getListItems()
local base = nil
for _, item in ipairs(saved) do
    if item.name == "ค่าวนวาป" then
        base = item.address + (74 * 4)
        break
    end
end

if base == nil then
    gg.searchNumber("256;256;58::9", gg.TYPE_DWORD)
    if gg.getResultsCount() == 0 then
        gg.alert("❌ ไม่พบฐานวาป")
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
gg.setVisible(false)
