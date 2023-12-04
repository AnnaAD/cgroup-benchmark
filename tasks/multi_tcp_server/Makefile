CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
LDFLAGS = -pthread

SERVER_SRC = server.cpp
SERVER_SRC_MM = server_mm.cpp
CLIENT_SRC = client.cpp

SERVER_BIN = server
SERVER_BIN_MM = server_mm
CLIENT_BIN = client

all: $(SERVER_BIN) $(CLIENT_BIN) $(SERVER_BIN_MM)

$(SERVER_BIN): $(SERVER_SRC)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)


$(SERVER_BIN_MM): $(SERVER_SRC_MM)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(CLIENT_BIN): $(CLIENT_SRC)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(SERVER_BIN) $(CLIENT_BIN)

.PHONY: all clean
