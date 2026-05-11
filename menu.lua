-- menu.lua - รายการฟังก์ชันทั้งหมด
return {
    {
        name = "🌀 วนบอส",
        type = "sub",
        menu = {
            { name = "🐉 วาปบอส 1", file = "warp.lua", action = "boss1" },
            { name = "🐉 วาปบอส 2", file = "warp.lua", action = "boss2" },
            { name = "🐉 วาปบอส 3", file = "warp.lua", action = "boss3" }
        }
    },
    {
        name = "🗺️ วาปนาวา",
        type = "sub",
        menu = {
            { name = "🐉 นาวาบอส", file = "warp.lua", action = "boss" },
            { name = "🗺️ นาวาแมพ", file = "warp.lua", action = "map" }
        }
    },
    {
        name = "👻 เดินทะลุ",
        file = "walk.lua"
    }
}
