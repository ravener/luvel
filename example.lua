local luvel = require("luvel")
local db = luvel.open("testdb", { createIfMissing = true })

print(db:get("key"))
db:put("key", "Hello, World!")
print(db:get("key"))
db:close()
