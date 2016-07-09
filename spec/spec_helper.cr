require "spec"
require "../src/kiwi"

macro behaves_like_store(store_definition)
  it "behaves like a store" do
    store = {{store_definition}}

    # set
    store.set("key1", "value1").should(eq("value1"), "#set fails")
    store.set("key2", "value2").should(eq("value2"), "#set fails")
    store.set("key3", "value3").should(eq("value3"), "#set fails")

    # get
    store.get("key1").should(eq("value1"), "#get fails")
    store.get("key2").should(eq("value2"), "#get fails")
    store.get("key3").should(eq("value3"), "#get fails")
    store.get("none").should(eq(nil), "#get fails")

    # delete
    store.delete("key1").should eq "value1"
    store.get("key1").should eq nil
    store.get("key2").should eq "value2"
    store.get("key3").should eq "value3"

    # clear
    store.clear.should eq store
    store.get("key1").should eq nil
    store.get("key2").should eq nil
    store.get("key3").should eq nil
  end
end
