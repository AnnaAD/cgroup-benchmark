#include <iostream>
#include <chrono>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <ctime>
#include <iomanip>
#include <sstream> // Include the <sstream> header

// Function to get the current formatted time
std::string getCurrentFormattedTime() {
    auto now = std::chrono::system_clock::now();
    std::time_t time = std::chrono::system_clock::to_time_t(now);
    auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(now.time_since_epoch()) % 1000;
    auto tm = *std::localtime(&time);
    std::ostringstream oss;
    oss << std::put_time(&tm, "%b %d %Y %H:%M:%S");
    oss << "." << std::setfill('0') << std::setw(3) << milliseconds.count();
    return oss.str();
}

int main(int argc, char **argv) {

    if (argc != 2) {
        perror("USAGE: ./client <ip addr>");
        return 1;
    }
    int clientSocket;
    struct sockaddr_in serverAddr;
    const int port = 12345;
    char buffer[1024];

    // Create a socket
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket == -1) {
        perror("Error creating socket");
        return 1;
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port);
    serverAddr.sin_addr.s_addr = inet_addr(argv[1]);

    // Connect to the server
    if (connect(clientSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("Error connecting to server");
        return 1;
    }

    while (true) {
        auto start = std::chrono::high_resolution_clock::now();

        // Send a request to the server
        send(clientSocket, "Client request", 14, 0);

        // Receive the server response
        recv(clientSocket, buffer, sizeof(buffer), 0);

        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);

        std::cout << "LOG: " << getCurrentFormattedTime() << "Round trip time: " << duration.count() << " ns" << std::endl;
        usleep(50);
    }

    // Close the client socket (not reached in this example)
    close(clientSocket);

    return 0;
}
