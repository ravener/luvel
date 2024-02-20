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

-- Putting keys
db:put("key", "value")
db:put("another", "two")

-- Getting keys
print(db:get("key"))

-- Iterators
for k, v in pairs(db) do
  print(k, v)
end

-- Close the database.
db:close()
```

See also the full [documentation](https://ravener.github.io/luvel)

## TODO
The library is usable, although I'm still cleaning it up and things are bound to change a lot.

Here's a list of things left to do:
- Snapshots support
- Support more options
- More documentation
- Tests

And more, expect it to be stable after a `1.0.0` release. In the meantime sending feedback regarding the design will help a lot.

## License
Released under [MIT License](LICENSE)

The initial code started as a modification of [Codezerker/lua_leveldb](https://github.com/Codezerker/lua_leveldb) but has since evolved into a much higher level wrapper.
