.PHONY: check
check:
	cargo check

.PHONY: db_local_start_container
db_local_start_container:
	./scripts/init_db.sh

.PHONY: db_local_stop
db_local_stop:
	docker stop postgres || true
	docker rm -f postgres

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
