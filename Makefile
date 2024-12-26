.PHONY: check
check:
	cargo check

.PHONY: db_local_start_contaienr
db_local_start_contaienr:
	./scripts/init_db.sh

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
