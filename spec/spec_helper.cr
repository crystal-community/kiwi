require "spec"
require "timecop"
require "../src/kiwi"

macro behaves_like_store(store_definition)
  it "behaves like a store" do
    store = {{store_definition}}

    # set
    store.set("key1", "value1").should eq("value1")
    store.set("key2", "value2").should eq("value2")
    store.set("key3", "value3").should eq("value3")

    # get
    store.get("key1").should eq("value1")
    store.get("key2").should eq("value2")
    store.get("key3").should eq("value3")
    store.get("none").should be_nil

    # delete
    store.delete("key1").should eq "value1"
    store.get("key1").should be_nil
    store.get("key2").should eq "value2"
    store.get("key3").should eq "value3"

    # []= and [] aliases
    store["key1"] = "abc"
    store["key1"].should eq "abc"

    # fetch
    store.fetch("key9") do
      "value9"
    end
    store["key9"].should eq "value9"

    # clear
    store.clear.should eq store
    store.get("key1").should be_nil
    store.get("key2").should be_nil
    store.get("key3").should be_nil
  end
end

macro behaves_like_expiring_store(store_definition)
  it "behaves like a store with expires capabilities" do
    store = {{store_definition}}

    store.set("key1", "value1")
    store.get("key1").should eq("value1")
    sleep 1.5 # sleep because Timecop won't affect real memcached/redis
    Timecop.travel(Time.utc + 5.seconds) do
      store.get("key1").should be_nil
    end

    store.fetch("key2") do
      "value2"
    end
    sleep 1.5
    Timecop.travel(Time.utc + 10.seconds) do
      store["key2"].should be_nil
    end
  end
end
