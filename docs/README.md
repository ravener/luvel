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
print(db:get("key"))
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
  * [DB:put(key, val, options?)](#dbputkey-val-options)
  * [DB:del(key, options?)](#dbdelkey-options)
  * [DB:close()](#dbclose)
* [Batch](#batch)
  * [Batch.new(db)](#batchnewdb)
  * [Batch:put(key, val)](#batchputkey-val)
  * [Batch:del(key)](#batchdelkey)
  * [Batch:exec(options?)](#batchexecoptions)
  * [Batch:destroy()](#batchdestroy)

<!-- vim-markdown-toc -->

## open(dirname, options?)
Opens a database in the given directory.

- **dirname** (`string`) - The directory for the leveldb database.
- **options** (`table`) - Database Options
  - **createIfMissing** (`boolean`) - Create the database if missing instead of raising an error.
  - **errorIfExists** (`boolean`) - Raise an error if an existing database exists.
  - **compression** (`boolean`) - Whether to enable snappy compression. Enabled by default.

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

### DB:put(key, val, options?)
Puts a key in the database.

- **key** (`string`) - Entry key.
- **val** (`string`) - Value to store.
- **options** (`table`) - Write options.

**Example**
```lua
db:put("key", "value")
db:put("name", "John")
```

### DB:del(key, options?)
Deletes a key from the database.

- **key** (`string`) - The key to delete.
- **options** (`table`) - Write options.

**Example**
```lua
db:del("key")
```

### DB:close()
Closes the database. The DB object must not be used after this call.

**Example**
```lua
db:close()
```

## Batch
Allows for multiple operations on the database in a batch.

### Batch.new(db)
Creates a new [Batch](#batch) for the given [DB](#db)

- **db** ([`DB`](#db)) - The database to operate on.

**Example**
```lua
local db = luvel.open("database")
local batch = luvel.Batch.new(db)
```

### Batch:put(key, val)
Put a key-value pair onto this batch.

- **key** (`string`) - The key.
- **val** (`string`) - The value.

**Example**
```lua
batch:put("name", "John")
batch:put("key", "value")
```

### Batch:del(key)
Queue a delete onto this batch.

- **key** (`string`) - The key.

**Example**
```lua
batch:del("key")
batch:del("name")
```

### Batch:exec(options?)
Executes this batch, applying all the added operations onto the database.

- **options** (`table`) - Write options.

**Example**
```lua
batch:put("key", "value")
batch:del("name")

-- Execute the batch.
batch:exec()
```

### Batch:destroy()
Destroys the batch, freeing the underlying C memory. The batch must not be used after this call.

**Example**
```lua
batch:destroy()
```
