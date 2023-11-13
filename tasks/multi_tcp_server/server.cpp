#include <iostream>
#include <thread>
#include <vector>
#include <string>
#include <chrono>
#include <mutex>
#include <netinet/in.h>
#include <unistd.h>
#include <cstring>

// Function to handle client requests
void handleClient(int clientSocket) {
    char buffer[1024];
    std::memset(buffer, 0, sizeof(buffer));

    // Receive data from the client
    int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
    if (bytesRead < 0) {
        perror("Error reading from client");
    } else {
        // Simulate some processing time (replace this with your actual server logic)
        std::this_thread::sleep_for(std::chrono::milliseconds(100));

        // Send a response back to the client
        send(clientSocket, "Server response", 15, 0);
    }

    // Close the client socket
    close(clientSocket);
}

int main() {
    int serverSocket, clientSocket;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t clientLen = sizeof(clientAddr);
    std::vector<std::thread> threads;
    const int port = 12345;

    // Create a socket
    serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == -1) {
        perror("Error creating socket");
        exit(1);
    }

    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port);
    serverAddr.sin_addr.s_addr = INADDR_ANY;

    // Bind the socket
    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr) ) < 0) {
        perror("Error binding the socket");
        exit(1);
    }

    // Listen for incoming connections
    listen(serverSocket, 5);
    std::cout << "Server listening on port " << port << std::endl;

    while (true) {
        // Accept a connection
        clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &clientLen);

        // Create a new thread to handle the client
        threads.emplace_back(handleClient, clientSocket);
    }

    // Close the server socket (not reached in this example)
    close(serverSocket);

    return 0;
}
