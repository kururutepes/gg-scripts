-- บักจ่อย.lua - รายการฟังก์ชันทั้งหมด
return {
    {
        name = "🌀 วนบอส",
        type = "sub",
        menu = {
            { name = "🐉 SPโคดัล", file = "บักจ่อย2.lua", action = "sp_kodal" },
            { name = "🐉 วาปบอส 2", file = "บักจ่อย2.lua", action = "boss2" },
            { name = "🐉 วาปบอส 3", file = "บักจ่อย2.lua", action = "boss3" }
        }
    },
    {
        name = "🗺️ วาปนาวา",
        type = "sub",
        menu = {
            { name = "🐉 นาวาบอส", file = "บักจ่อย2.lua", action = "boss" },
            { name = "🗺️ นาวาแมพ", file = "บักจ่อย2.lua", action = "map" }
        }
    },
    {
        name = "👻 เดินทะลุ",
        file = "walk.lua"
    }
}
