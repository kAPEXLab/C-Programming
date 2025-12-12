## `Makefile`

CC      := gcc
CFLAGS  := -std=c11 -Wall -Wextra -Werror -O2
BIN_DIR := bin
SRC_DIR := src

all: $(BIN_DIR)/hello

$(BIN_DIR)/hello: $(SRC_DIR)/main.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

run: all
	./$(BIN_DIR)/hello

test: all tests/run_tests.sh
	bash tests/run_tests.sh

clean:
	rm -rf $(BIN_DIR)