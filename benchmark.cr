require "./src/kiwi/memory_store"
require "./src/kiwi/file_store"
require "./src/kiwi/redis_store"
require "./src/kiwi/leveldb_store"
require "./src/kiwi/memcached_store"
require "benchmark"
X = 50000
N =  5
LIMITER = Time::Span.new(seconds: 5)

def benchmark(name, &block)
  r = Time::Span.new
  i = 0
  loop do
    puts "N=%i / %i" % [i, N]
    r += Benchmark.realtime do
      X.times do
        block.call
      end
    end
    i += X
    break if r >  LIMITER
  end
  (i.to_f/r.seconds.to_f).round.to_i
end

def gen_data
  data = Hash(String, String).new
  N.times do |i|
    # from 5 up to ~100 chars
    key = "0123456789" * rand(10) + "-key#{i}"

    # up to ~ 1Kb
    value = "0123456789" * rand(100)

    data[key] = value
  end
  data
end

def measure(stores)
  puts "Genrating data..."
  data = gen_data
  empty_keys = (0..N).map { |i| "empty-key-#{i}" }

  result = Hash(String, Hash(String, Int32)).new

  puts "Starting...\n\n"

  stores.each do |store|
    store.clear
    puts store.class
    store_metrics = Hash(String, Int32).new

    store_metrics["set"] = benchmark("set") do
      data.each do |key, val|
        store.set(key, val)
      end
    end

    store_metrics["get"] = benchmark("get") do
      data.each do |key, val|
        store.get(key)
      end
    end

    store_metrics["get_empty"] = benchmark("get (empty)") do
      data.each do |key, val|
        store.get(key)
      end
    end

    store_metrics["delete"] = benchmark("delete") do
      data.each do |key, val|
        store.delete(key)
      end
    end

    store.clear
    store_name = store.class.to_s.split("::").last
    result["**#{store_name}**"] = store_metrics
  end
  result
end

def print_table(result)
  store_col_size = result.keys.map(&.size).max
  set_col_size = result.values.map { |metrics| metrics["set"].to_s.size }.max
  get_col_size = result.values.map { |metrics| metrics["get"].to_s.size }.max
  get_empty_col_size = "get(empty)".size
  delete_col_size = result.values.map { |metrics| metrics["delete"].to_s.size }.max

  # header
  puts "| " + " " * store_col_size +
       " | " + "set".ljust(set_col_size) +
       " | " + "get".ljust(get_col_size) +
       " | " + "get(empty)".ljust(get_empty_col_size) +
       " | " + "delete".ljust(delete_col_size) +
       " |"

  puts "| " + "-" * store_col_size +
       " | " + "-" * set_col_size +
       " | " + "-" * get_col_size +
       " | " + "-" * get_empty_col_size +
       " | " + "-" * delete_col_size +
       " |"

  # rows
  result.each do |store, metrics|
    puts "| " + store.ljust(store_col_size) +
         " | " + metrics["set"].to_s.rjust(set_col_size) +
         " | " + metrics["get"].to_s.rjust(get_col_size) +
         " | " + metrics["get_empty"].to_s.rjust(get_empty_col_size) +
         " | " + metrics["delete"].to_s.rjust(delete_col_size) +
         " |"
  end
end

puts
puts "Initializing stores..."
stores = Array(Kiwi::Store).new

stores << Kiwi::MemoryStore.new
stores << Kiwi::MemcachedStore.new(Memcached::Client.new)

stores << Kiwi::LevelDBStore.new(LevelDB::DB.new("/tmp/kiwi_benchmark_leveldb"))
stores << Kiwi::RedisStore.new(Redis.new)
stores << Kiwi::FileStore.new("/tmp/kiwi_benchmark_file")

result = measure(stores)
puts "\n"
print_table(result)
puts "\n"
