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

store = Kiwi::FileStore(dir: "/tmp/kiwi")
```

### RedisStore

RedisStore requires you to have [redis shard](https://github.com/stefanwille/crystal-redis)

```crystal
require "redis"
require "kiwi/redis_store"

store = Kiwi::RedisStore(redis: Redis.new)
```

### MemcachedStore

MemcachedStore requires you to have [memcached shard](https://github.com/comandeo/crystal-memcached)

```crystal
require "memcached"
require "kiwi/memcached_store"

store = Kiwi::MemcachedStore(memcached: Memcached::Client.new)
```

## Performance porn

The following table shows operations per second for every particular store.

|                 | set     | get     | delete   |
| --------------- | -------:| -------:| --------:|
| **MemoryStore** | 4740000 | 8607000 | 35602000 |
| **FileStore**   |   19000 |   29000 |     7000 |
| **RedisStore**  |   44000 |   45000 |    23000 |

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
