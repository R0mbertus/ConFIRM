CXX=clang++
CFLAGS=-g

# CXX=clang++
# CFLAGS=-g -flto -fvisibility=default -fsanitize=shadow-call-stack,cfi

# CXX=clang++-17
# CFLAGS=-g -fsanitize=shadow-call-stack,kcfi

# CXX=g++
# CFLAGS=-g -fcf-protection=full

# CXX=clang++
# CFLAGS=-g -fsanitize=shadow-call-stack -O0 -fpass-plugin=../../policies/custom/build/lib/libControlFlowIntegrity.so

# CXX=clang++
# CFLAGS=-g -fsanitize=shadow-call-stack -O0 -fpass-plugin=../../policies/custom/build/lib/libOpaqueControlFlowIntegrity.so

# CXX=/root/MCFI/toolchain/bin/clang++
# CFLAGS=-g

# CXX=/root/MCFI/toolchain/bin/clang++
# CFLAGS=-g -Xclang -mdisable-picfi

CPP_FILES_ALL := $(wildcard src/*.cpp)
CPP_FILES := $(filter-out src/setup.cpp, $(CPP_FILES_ALL))
EXECUTABLES := $(addprefix build/, $(CPP_FILES:.cpp=))
SETUP_CPP := src/setup.cpp
SETUP_H := src/setup.h
SETUP_O := build/setup.o

# Default target
all: build setup compile run

build:
	@mkdir -p build/src

setup: $(SETUP_O)


$(SETUP_O): $(SETUP_CPP) $(SETUP_H)
	@echo "Compiling $<..."
	@${CXX} ${CFLAGS} -c $(SETUP_CPP) -o $@

compile: $(EXECUTABLES)

build/%: %.cpp
	@echo "Compiling $<..."
	@${CXX} ${CFLAGS} -o $@ $< $(SETUP_O)

run: $(EXECUTABLES)
	@for exe in $(EXECUTABLES); do \
		echo "Running $$exe..."; \
		./$$exe; \
		echo "\n"; \
	done

clean:
	@rm -rf build

.PHONY: all compile run clean
