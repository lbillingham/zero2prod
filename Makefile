.PHONY: check
check:
	cargo check

.PHONY: build
build:
	cargo build

.PHONY: run_local_dev
run_local_dev: build
	cargo run

.PHONY: test
test:
	cargo test

.PHONY: watch
watch:
	cargo watch -x check -x test -x run
