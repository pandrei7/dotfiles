SRC = main.cc
EXEC = main

build: $(EXEC)

run: build
	./$(EXEC)

$(EXEC): $(SRC)
	g++ -o $@ $^ -Wall -Werror -std=c++17 -lm

.PHONY: clean
clean:
	rm -f $(EXEC)
