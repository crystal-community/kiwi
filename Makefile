CRYSTAL_BIN ?= $(shell which crystal)

benchmark:
	$$(mkdir tmp -p)
	$(CRYSTAL_BIN) build --release -o tmp/benchmark ./benchmark.cr $(CRFLAGS)
	tmp/benchmark
test:
	$(CRYSTAL_BIN) spec
