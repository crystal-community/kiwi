# Kiwi

A unified interface for key/value stores. Implemented in Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kiwi:
    github: greyblake/crystal-kiwi
```

## Usage

### MemoryStore

```crystal
require "kiwi/memory_store"

store = Kiwi::MemoryStore.new

store.set("key", "value")
store.get("key")  # => "value"
store.delete("key")
store.clear
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

RedisStore requires you to have [leveldb shard](https://github.com/greyblake/crystal-leveldb).

```crystal
require "redis"
require "kiwi/leveldb_store"

leveldb = LevelDB::DB.new("./db")
store = Kiwi::LevelDBStore(leveldb)
```

### MemcachedStore

MemcachedStore requires you to have [memcached shard](https://github.com/comandeo/crystal-memcached)

```crystal
require "memcached"
require "kiwi/memcached_store"

store = Kiwi::MemcachedStore.new(Memcached::Client.new)
```

## Performance porn

The following table shows **operations per second** for every particular store.

|                  | set     | get     | delete   |
| ---------------- | -------:| -------:| --------:|
| **MemoryStore**  | 1707000 | 4715000 |  6778000 |
| **LevelDBStore** |   67000 |  155000 |    66000 |
| **RedisStore**   |   41000 |   41000 |    21000 |
| **FileStore**    |   6000  |   17000 |    13000 |

Data information:
* Key size: 5-100 bytes.
* Value size: 10-1000 bytes.
* Number of items: 200,000


Environment information:
* CPU: Intel(R) Core(TM) i7-3632QM CPU @ 2.20GHz
* File System: ext4, SSD
* RAM: DDR3, 1600 MHz
* Operating system: 3.16.0-4-amd64 x86_64 GNU/Linux

Results can vary on different systems depending on hardware(CPU, RAM, HDD/SSD) and software(OS, file system, etc).

## Running benchmark

```
make benchmark
```

## Running tests

```
make test
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
