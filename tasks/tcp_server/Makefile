all: server client

CC=gcc
CFLAGS=-I.

clean:
	rm *.o
	
%.o: %.c 
	$(CC) -c -o $@ $< $(CFLAGS)

server: server.o
	$(CC) -o $@ $^ $(CFLAGS)

client: client.o
	$(CC) -o $@ $^ $(CFLAGS)