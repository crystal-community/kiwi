CRYSTAL_BIN ?= $(shell which crystal)

test:
	docker-compose up -d
	sleep 2
	$(CRYSTAL_BIN) spec
	docker-compose down

benchmark:
	$$(mkdir tmp -p)
	$(CRYSTAL_BIN) build --release -o tmp/benchmark ./benchmark.cr $(CRFLAGS)
	tmp/benchmark
