# Makefile for compiling individual COBOL files with GNU Cobol (cobc)

# Compiler
COBC = cobc
CFLAGS = -x -O2 -fbinary-byteorder=native -std=mf # Create executable

# Directories
SRC_DIR = .
BIN_DIR = bin

# Default target
all: help

# Rule to compile a single COBOL source file
%.exe: %.cbl | $(BIN_DIR)
	@source /mingw64/bin/cobenv.sh && $(COBC) $(CFLAGS) -o $(BIN_DIR)/$@ $<

# Create the bin directory if it doesn't exist
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Rule to run the compiled executable
run:
	@if [ -n "$(FILE)" ]; then \
		cd $(BIN_DIR); \
		./$(FILE); \
	else \
		echo "Error: No FILE specified. Use 'make help' for more info."; \
	fi

# Help rule to display usage information
help:
	@echo "Usage:"
	@echo "  make <filename>.exe   - Compile a COBOL source file"
	@echo "  make run FILE=<exe>   - Run an executable from the bin directory"
	@echo "  make clean            - Remove compiled executables"

# Clean rule to remove generated files
clean:
	rm -rf $(BIN_DIR)/*.exe
