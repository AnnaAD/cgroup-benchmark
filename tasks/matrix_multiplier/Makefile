all: matrix

CC=gcc
CFLAGS=-I.

%.o: %.c 
	$(CC) -c -o $@ $< $(CFLAGS)

matrix: matrix.o
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm *.o