CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
LDFLAGS = -pthread

SERVER_SRC = server.cpp
CLIENT_SRC = client.cpp

SERVER_BIN = server
CLIENT_BIN = client

all: $(SERVER_BIN) $(CLIENT_BIN)

$(SERVER_BIN): $(SERVER_SRC)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(CLIENT_BIN): $(CLIENT_SRC)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(SERVER_BIN) $(CLIENT_BIN)

.PHONY: all clean
