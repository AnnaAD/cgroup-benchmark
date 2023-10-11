all: manager

CC=gcc
CFLAGS= -I. -lpthread

%.o: %.c 
	$(CC) -c -o $@ $< $(CFLAGS)

manager: manager.o
	$(CC) -o $@ $^ $(CFLAGS)
