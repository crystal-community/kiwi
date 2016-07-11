# Crystal Kiwi <img src="http://publicdomainvectors.org/photos/1301230997.png" alt="Crystal Kiwi - interface of key-value storages" width="64">

A simple unified Crystal interface for key-value stores.

* [Installation](#installation)
* [Usage](#usage)
  * [MemoryStore](#memorystore)
  * [FileStore](#filestore)
  * [RedisStore](#redisstore)
  * [LevelDBStore](#leveldbstore)
  * [MemcachedStore](#memcachedstore)
* [Benchmark](#benchmark)
* [Tests](#tests)
* [Contributors](#contributors)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kiwi:
    github: greyblake/crystal-kiwi
```

## Usage

All the stores have the same simple interface defined by
[Kiwi::Store](https://github.com/greyblake/crystal-kiwi/blob/master/src/kiwi/store.cr):
* `set(key : String, value : String) : String`
* `get(key : String) : String|Nil`
* `delete(key : String) : String|Nil`
* `clear`
* `[]=(key : String, value) : String` - alias for `set`
* `[](key : String) : String` - alias for `get`

### MemoryStore

```crystal
require "kiwi/memory_store"

store = Kiwi::MemoryStore.new

store.set("key", "value")
store.get("key")  # => "value"
store.delete("key")
store.clear

# Or your can use Hash-like methods:
store["key"] = "new value"
store["key"]  # => "new "value"
```

### FileStore

```crystal
require "kiwi/file_store"

store = Kiwi::FileStore("/tmp/kiwi")
```

### RedisStore

RedisStore requires you to have [redis shard](https://github.com/stefanwille/crystal-redis).

```crystal
require "redis"
require "kiwi/redis_store"

store = Kiwi::RedisStore(Redis.new)
```

### LevelDBStore

RedisStore requires you to have [levelDB shard](https://github.com/greyblake/crystal-leveldb).

```crystal
require "leveldb"
require "kiwi/leveldb_store"

leveldb = LevelDB::DB.new("./db")
store = Kiwi::LevelDBStore(leveldb)
```

### MemcachedStore

MemcachedStore requires you to have [memcached shard](https://github.com/comandeo/crystal-memcached).

```crystal
require "memcached"
require "kiwi/memcached_store"

store = Kiwi::MemcachedStore.new(Memcached::Client.new)
```

## Benchmark

The following table shows **operations per second** for every particular store on my machine.

|                    | set     | get     | get(empty) | delete   |
| ------------------:| -------:| -------:| ----------:| --------:|
| **MemoryStore**    | 3056000 | 4166000 |    4074000 | 10473000 |
| **LevelDBStore**   |  120000 |  193000 |     253000 |    37000 |
| **RedisStore**     |   41000 |   42000 |      42000 |    21000 |
| **MemcachedStore** |   38000 |   41000 |      40000 |    21000 |
| **FileStore**      |   27000 |   66000 |      73000 |     8000 |

Data information:
* Key size: 5-100 bytes.
* Value size: 10-1000 bytes.
* Number of items: 100,000


Environment information:
* CPU: Intel(R) Core(TM) i7-3632QM CPU @ 2.20GHz
* File System: ext4, SSD
* RAM: DDR3, 1600 MHz
* Operating system: 3.16.0-4-amd64 x86_64 GNU/Linux

Results can vary on different systems depending on hardware(CPU, RAM, HDD/SSD) and software(OS, file system, etc).

### Running benchmark

```
make benchmark
```

## Tests

Run specs for all stores:
```
make test
```

Run spec for a particular store:

```
crystal spec ./spec/kiwi/file_store_spec.cr
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer.
- [mauricioabreu](https://github.com/mauricioabreu) Mauricio de Abreu Antunes - thanks for MemcachedStore.
