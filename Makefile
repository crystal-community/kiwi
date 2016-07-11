CRYSTAL_BIN ?= $(shell which crystal)

test:
	$(CRYSTAL_BIN) spec

benchmark:
	$$(mkdir tmp -p)
	$(CRYSTAL_BIN) build --release -o tmp/benchmark ./benchmark.cr $(CRFLAGS)
	tmp/benchmark
