CXX=clang++
CFLAGS=-g

CPP_FILES_ALL := $(wildcard src/*.cpp)
CPP_FILES := $(filter-out src/setup.cpp, $(CPP_FILES_ALL))
EXECUTABLES := $(addprefix build/, $(CPP_FILES:.cpp=))
SETUP_CPP := src/setup.cpp
SETUP_H := src/setup.h
SETUP_O := build/setup.o

# Default target
all: build compile run

build:
	@mkdir -p build/src

$(SETUP_O): $(SETUP_CPP) $(SETUP_H)
	@echo ${EXECUTABLES}
	@${CXX} ${CFLAGS} -c $(SETUP_CPP) -o $@

compile: $(SETUP_O) $(EXECUTABLES)

build/%: %.cpp
	@echo "Compiling $<..."
	@${CXX} ${CFLAGS} -o $@ $< $(SETUP_O)

run: $(EXECUTABLES)
	@for exe in $(EXECUTABLES); do \
		echo "Running $$exe..."; \
		./$$exe; \
		echo -e "\n"; \
	done

clean:
	@rm -rf build

.PHONY: all compile run clean
