SRC = main.c
EXEC = main

build: $(EXEC)

run: build
	./$(EXEC)

$(EXEC): $(SRC)
	gcc -o $@ $^ -Wall -Werror -std=c11 -lm

.PHONY: clean
clean:
	rm -f $(EXEC)
