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

# make test captures most log output by design
#  we can simulate `cargo test --no-capture`
#  for a single test
# Usage:
#  make TEST_TO_DEBUG=subscribe_returns_a_200_when_form_data_valid test_no_capture_logging
# TEST_TO_DEBUG defaults to health check works if not supplied
TEST_TO_DEBUG := health_check_works
.PHONY: test_no_capture_logging
test_no_capture_logging:
	TEST_LOG=true cargo test ${TEST_TO_DEBUG} | bunyan

.PHONY: watch
watch:
	cargo watch -x check -x test -x run
