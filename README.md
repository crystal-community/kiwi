# Kiwi

[![Build Status](https://travis-ci.org/crystal-community/kiwi.svg?branch=master)](https://travis-ci.org/crystal-community/kiwi)

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
    github: crystal-community/kiwi
    version: ~> 0.1.0
```

Temporarily, if you wan't the newest version from akitaonrails' fork:

```yaml
dependencies:
  kiwi:
    github: akitaonrails/kiwi
    branch: master
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

# fetch with a block:
store.fetch("key") do
  "value"
end
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

LevelDBStore requires you to have [levelDB shard](https://github.com/crystal-community/leveldb).

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

### Expires

Almost all stores, but the FileStore, can receive a "expires_in" argument to set a default expiring time span:

```crystal
store1 = Kiwi::MemcachedStore.new(Memcached::Client.new, expires_in: 5.minutes)
store2 = Kiwi::RedisStore.new(Redis::PooledClient.new, expires_in: 1.hour)
```

This is a cache library, so cached data is supposed to eventually expire without manual intervention.

## Benchmark

The following table shows **operations per second** for every particular store on my machine.

|                    | set     | get     | get(empty) | delete  |
| ------------------ | ------- | ------- | ---------- | ------- |
| **MemoryStore**    | 2096000 | 3023000 |    3171000 | 3453000 |
| **LevelDBStore**   |  690000 |  518000 |     627000 |  360000 |
| **RedisStore**     |   24000 |   30000 |      25000 |   13000 |
| **MemcachedStore** |   11000 |   10000 |      11000 |    5000 |
| **FileStore**      |   80000 |  118000 |     117000 |   90000 |

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
# you must have docker-compose installed
make test
```

Run spec for a particular store:

```
crystal spec ./spec/kiwi/file_store_spec.cr
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer.
- [mauricioabreu](https://github.com/mauricioabreu) Mauricio de Abreu Antunes - thanks for MemcachedStore.
- [akitaonrails](https://akitando.com) Fabio Akita - adding type checks and expiration feature
