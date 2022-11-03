# Luvel
`luvel` is a LuaJIT FFI wrapper for [leveldb](https://github.com/google/leveldb)

## Install
luvel only runs on LuaJIT and Luvit.

If you are using LuaJIT just copy the `luvel.lua` file into your project.

If you are using luvit then you may install the lit package:
```sh
$ lit install ravener/luvel
```

## Usage
```lua
local luvel = require("luvel")
local db = luvel.open("database", { createIfMissing = true })

db:put("key", value)
print(db:get("key"))

db:close()
```
See also the full [documentation](https://ravener.github.io/luvel)

## TODO
The library is usable, although I'm still cleaning it up and is bound to change.

Here's a list of things left to do:
- Snapshots support
- Support more options
- More documentation

## License
Released under [MIT License](LICENSE), original code has been adapted from [Codezerker/lua_leveldb](https://github.com/Codezerker/lua_leveldb)
