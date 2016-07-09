require "./src/kiwi"

N = 100_000

def benchmark(name)
  start_time = Time.now
  yield
  writing_time = Time.now - start_time
  speed = (N.to_f / writing_time.to_f)
  rounded_speed = ((speed / 1000).round * 1000).to_i
  puts "  #{name}: #{rounded_speed} ops/sec"
  rounded_speed
end

def gen_data
  data = Hash(String, String).new
  N.times do |i|
    key = "key-#{i.to_s}"
    value = "value-#{i.to_s}"
    data[key] = value
  end
  data
end

stores = Array(Kiwi::Store).new
stores << Kiwi::MemoryStore.new
stores << Kiwi::FileStore.new(dir: "/tmp/kiwi_test")
stores << Kiwi::RedisStore.new(redis: Redis.new)


def measure(stores)
  data = gen_data
  result = Hash(String, Hash(String, Int32)).new

  stores.each do |store|
    puts store.class
    store_metrics = Hash(String, Int32).new

    store_metrics["set"] = benchmark("#set") do
      data.each do |key, val|
        store.set(key, val)
      end
    end

    store_metrics["get"] = benchmark("#get") do
      data.each do |key, val|
        store.get(key)
      end
    end

    store_metrics["delete"] = benchmark("#delete") do
      data.each do |key, val|
        store.delete(key)
      end
    end

    store.clear
    store_name = store.class.to_s.split("::").last
    result[store_name] = store_metrics
  end
  result
end

def print_table(result)
  store_col_size = result.keys.map(&.size).max
  set_col_size = result.values.map { |metrics| metrics["set"].to_s.size }.max
  get_col_size = result.values.map { |metrics| metrics["get"].to_s.size }.max
  delete_col_size = result.values.map { |metrics| metrics["delete"].to_s.size }.max

  # header
  puts "| " + " " * store_col_size + " | " + "set".ljust(set_col_size) + " | " + "get".ljust(get_col_size) + " | " + "delete".ljust(delete_col_size) + " |"
  puts "| " + "-" * store_col_size + " | " + "-" * set_col_size + " | " + "-" * get_col_size + " | " + "-" * delete_col_size + " |"

  # rows
  result.each do |store, metrics|
    print "| "
    print store.ljust(store_col_size)
    print " | "
    print metrics["set"].to_s.rjust(set_col_size)
    print " | "
    print metrics["get"].to_s.rjust(get_col_size)
    print " | "
    print metrics["delete"].to_s.rjust(delete_col_size)
    puts " |"
  end
end

puts
result = measure(stores)
puts "\n"
print_table(result)
puts "\n"
