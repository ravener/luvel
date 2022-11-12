Luvel is available on [Lit](https://luvit.io)
```sh
$ lit install ravener/luvel
```
If you are using pure LuaJIT or don't want to use lit, you may just copy the [luvel.lua](https://github.com/ravener/luvel/blob/main/luvel.lua) file into your project.

You will also need leveldb installed on your system where `ffi.load` can find it, if you are on Ubuntu you can just do:
```sh
$ sudo apt-get install libleveldb-dev
```
Similar packages may exist on other systems and you may also [build leveldb from source](https://github.com/google/leveldb#building)

Here's an example to get you quickly started:
```lua
local luvel = require("luvel")
local db = luvel.open("database", { createIfMissing = true })

db:put("key", "value")
db:put("another", "data")

print(db:get("key"))

for k, v in pairs(db) do
  print(k, v)
end

db:close()
```
Read on for more examples and the complete API documentation.

# API
<!-- vim-markdown-toc GFM -->

* [open(dirname, options?)](#opendirname-options)
* [repair(dirname)](#repairdirname)
* [destroy(dirname)](#destroydirname)
* [version()](#version)
* [DB](#db)
  * [DB:get(key, options?)](#dbgetkey-options)
  * [DB:put(key, val, sync?)](#dbputkey-val-sync)
  * [DB:del(key, sync?)](#dbdelkey-sync)
  * [DB:batch()](#dbbatch)
  * [DB:iterator(options?)](#dbiteratoroptions)
  * [DB:__pairs()](#db__pairs)
  * [DB:close()](#dbclose)
  * [DB:__gc()](#db__gc)
* [WriteBatch](#writebatch)
  * [WriteBatch:put(key, val)](#writebatchputkey-val)
  * [WriteBatch:del(key)](#writebatchdelkey)
  * [WriteBatch:write(sync?)](#writebatchwritesync)
  * [WriteBatch:close()](#writebatchclose)
  * [WriteBatch:__gc()](#writebatch__gc)
* [Iterator](#iterator)
  * [Iterator:first()](#iteratorfirst)
  * [Iterator:last()](#iteratorlast)
  * [Iterator:seek(key)](#iteratorseekkey)
  * [Iterator:prev()](#iteratorprev)
  * [Iterator:next()](#iteratornext)
  * [Iterator:read()](#iteratorread)
  * [Iterator:close()](#iteratorclose)
  * [Iterator:__gc()](#iterator__gc)

<!-- vim-markdown-toc -->

## open(dirname, options?)
Opens a database in the given directory.

- **dirname** (`string`) - The directory for the leveldb database.
- **options** (`table`) - Database Options
  - **createIfMissing** (`boolean`) - Create the database if missing instead of raising an error.
  - **errorIfExists** (`boolean`) - Raise an error if an existing database exists.
  - **compression** (`boolean`) - Whether to enable snappy compression. Enabled by default.
  - **paranoidChecks** (`boolean`) - Whether to enable paranoid checks. Disabled by default.

**Returns:** A [DB](#db) object representing the database.

**Example**
```lua
local luvel = require("luvel")

local db = luvel.open("database", {
  createIfMissing = true,
  errorIfExists = false,
  compression = true
})
```

## repair(dirname)
Try to repair the database in the given directory, recovering as much data as possible.

- **dirname** (`string`) - The directory for the leveldb database.

**Example**
```lua
local luvel = require("luvel")
luvel.repair("./my-database")
```

## destroy(dirname)
Destroys the database in the given directory, deleting everything.

- **dirname** (`string`) - The directory for the leveldb database.

**Example**
```lua
local luvel = require("luvel")
luvel.destroy("./my-database")
```

## version()
Returns the LevelDB version.

**Returns:**
- `major` (`number`) - The major version.
- `minor` (`number`) - The minor version.

**Example**
```lua
local luvel = require("luvel")
local major, minor = luvel.version()

print("LevelDB version: " .. string.format("%s.%s", major, minor))
```

## DB
This is the main type for interacting with the database.

### DB:get(key, options?)
Gets a value from the database by the given key, returns nil if not found.

- **key** (`string`) - The key to lookup.
- **options** (`table`) - Read options.

**Returns:** string, or nil if the key was not found.

**Example**
```lua
print(db:get("name"))
```

### DB:put(key, val, sync?)
Puts a key in the database.

- **key** (`string`) - Entry key.
- **val** (`string`) - Value to store.
- **sync** (`boolean`) - Whether to perform a synchronous write. Default is to perform an Asynchronous write.

**Example**
```lua
db:put("key", "value")
db:put("name", "John")
```

### DB:del(key, sync?)
Deletes a key from the database.

- **key** (`string`) - The key to delete.
- **sync** (`boolean`) - Whether to perform a synchronous write. Default is to perform an Asynchronous write.

**Example**
```lua
db:del("key")
```

### DB:batch()
Creates a [WriteBatch](#writebatch)

**Example**
```lua
local batch = db:batch()

batch:put("key", "value")
batch:put("another", "hello")

batch:write()
```

### DB:iterator(options?)
Creates an [Iterator](#iterator) for iterating through the database.

- **options** (`table`) - Read options.

**Returns:** [Iterator](#iterator)

### DB:__pairs()
Metamethod that allows for easy iteration over the database. You may use [DB:iterator()](#dbiteratoroptions) for more flexibility.

**Example**
```lua
for k, v in pairs(db) do
  print(k, v)
end
```

### DB:close()
Closes the database. The DB object must not be used after this call.

**Example**
```lua
db:close()
```

### DB:__gc()
This metamethod ensures the database is closed and the underlying C memory is freed if it gets garbage collected to prevent memory leaks.

This is just to document the behavior, you must not call this function.

You may use [DB:close()](#dbclose) if you want to close it before a garbage collection.

## WriteBatch
Allows for multiple operations on the database in a batch.

Do not instantiate directly, use [DB:batch()](#dbbatch) to create a batch.

### WriteBatch:put(key, val)
Put a key-value pair onto this batch.

- **key** (`string`) - The key.
- **val** (`string`) - The value.

**Example**
```lua
batch:put("name", "John")
batch:put("key", "value")
```

### WriteBatch:del(key)
Queue a delete onto this batch.

- **key** (`string`) - The key.

**Example**
```lua
batch:del("key")
batch:del("name")
```

### WriteBatch:write(sync?)
Executes this batch, applying all the added operations onto the database.

- **sync** (`boolean`) - Whether to perform a synchronous write. Default is to perform an Asynchronous write.

**Example**
```lua
batch:put("key", "value")
batch:del("name")

-- Execute the batch.
batch:write()
```

### WriteBatch:close()
Closes the batch, freeing the underlying C memory. The batch must not be used after this call.

**Example**
```lua
batch:close()
```

### WriteBatch:__gc()
This metamethod ensures the batch is destroyed and the underlying C memory is freed if it gets garbage collected to prevent memory leaks.

This is just to document the behavior, you must not call this function.

You may use [WriteBatch:close()](#writebatchclose) if you want to destroy it before a garbage collection.

## Iterator

### Iterator:first()
Sets iterator position to the first entry in the database.

### Iterator:last()
Sets iterator position to the last entry in the database.

### Iterator:seek(key)
Sets iterator position to the first key in the database that is on or past argument.

- **key** (`key`) - The key to search for.

### Iterator:prev()
Sets iterator position to the previous entry in the database. Returns entry from current iterator position.

**Returns:**
- `key` (`string`) - The key of the entry.
- `value` (`string`) - The value of the entry.
- or nil if entry not exists.

### Iterator:next()
Sets iterator position to the next entry in the database. Returns entry from current iterator position.

**Returns:**
- `key` (`string`) - The key of the entry.
- `value` (`string`) - The value of the entry.
- or nil if entry not exists.

### Iterator:read()
Read key and value from iterator position. Returns nil if entry not exists.

**Returns:**
- `key` (`string`) - The key of the entry.
- `value` (`string`) - The value of the entry.
- or nil if entry not exists.

### Iterator:close()
Closes the iterator, freeing the underlying C memory. The iterator must not be used after this call.

**Example**
```lua
iter:close()
```

### Iterator:__gc()
This metamethod ensures the iterator is destroyed and the underlying C memory is freed if it gets garbage collected to prevent memory leaks.

This is just to document the behavior, you must not call this function.

You may use [Iterator:close()](#iteratorclose) if you want to destroy it before a garbage collection.
