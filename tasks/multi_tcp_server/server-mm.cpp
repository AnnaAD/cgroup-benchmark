#include <iostream>
#include <thread>
#include <vector>
#include <string>
#include <chrono>
#include <mutex>
#include <netinet/in.h>
#include <unistd.h>
#include <cstring>


void matrix_multiply(int rows1, int cols1, int cols2) {
     // Allocate memory for matrices
    int **matrix1 = (int **)malloc(rows1 * sizeof(int *));
    int **matrix2 = (int **)malloc(cols1 * sizeof(int *));
    int **result = (int **)malloc(rows1 * sizeof(int *));

    for (int i = 0; i < rows1; i++) {
        matrix1[i] = (int *)malloc(cols1 * sizeof(int));
        result[i] = (int *)malloc(cols2 * sizeof(int));
    }

    for (int i = 0; i < cols1; i++) {
        matrix2[i] = (int *)malloc(cols2 * sizeof(int));
    }

    // Fill Matrix
    for (int i = 0; i < rows1; i++) {
        for (int j = 0; j < cols1; j++) {
            matrix1[i][j] = rand() % 256;  // Generate a random number between 0 and 9
        }

        for (int j = 0; j < cols2; j++) {
            matrix2[i][j] = rand() % 256;  // Generate a random number between 0 and 9
        }
    }

    for (int i = 0; i < rows1; i++) {
        for (int j = 0; j < cols2; j++) {
            result[i][j] = 0;  // Initialize result matrix cell to 0

            for (int k = 0; k < cols1; k++) {
                result[i][j] += matrix1[i][k] * matrix2[k][j];
            }
        }
    }

     // Free allocated memory
    for (int i = 0; i < rows1; i++) {
        free(matrix1[i]);
        free(result[i]);
    }
    for (int i = 0; i < cols1; i++) {
        free(matrix2[i]);
    }

    free(matrix1);
    free(matrix2);
    free(result);
}
// Function to handle client requests
void handleClient(int clientSocket) {
    char buffer[1024];
    std::memset(buffer, 0, sizeof(buffer));

    // Receive data from the client

    while(true) {
        int bytesRead = recv(clientSocket, buffer, sizeof(buffer), 0);
        if (bytesRead < 0) {
            perror("Error reading from client");
        } else {
            // Simulate some processing time (replace this with your actual server logic)
            std::cout << "Recieved Req - " << std::endl;
            
            matrix_multiply(100,100,100);
            // Send a response back to the client
            send(clientSocket, "Server response", 15, 0);
        }
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
