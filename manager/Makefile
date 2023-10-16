all: manager

CC=gcc
CFLAGS= -I. -lpthread

%.o: %.c 
	$(CC) -c -o $@ $< $(CFLAGS)

manager: manager.o
	$(CC) -o $@ $^ $(CFLAGS)

server:
	source run-fig1-experiment-server.sh 10
