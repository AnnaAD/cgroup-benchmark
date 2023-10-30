#include <arpa/inet.h> // inet_addr()
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h> // bzero()
#include <sys/socket.h>
#include <unistd.h> // read(), write(), close()
#include <time.h>


#define MAX 80
#define PORT 8080
#define SA struct sockaddr


void func(int sockfd)
{
	char buff[MAX];
	int n;
	for (;;) {
		bzero(buff, sizeof(buff));
		n = 0;
		strcpy(buff, "msg");
		write(sockfd, buff, sizeof(buff));
		bzero(buff, sizeof(buff));
        struct timespec t0, t1;

        // Get starting time
        timespec_get(&t0, TIME_UTC);  // C11 feature
		read(sockfd, buff, sizeof(buff));

        timespec_get(&t1, TIME_UTC);
        // Compute difference in nanoseconds
        long dns = t1.tv_nsec - t0.tv_nsec;
		long ds = (t1.tv_sec - t0.tv_sec)*1000000000;
        time_t ltime;
		time(&ltime);
		printf("%s - Latency : %ld ns ",ctime(&ltime),  dns+ds);
		if ((strncmp(buff, "exit", 4)) == 0) {
			printf("Client Exit...\n");
			break;
		}

		usleep(50);
	}
}

int main(int argc, char **argv )
{
	int sockfd, connfd;
	struct sockaddr_in servaddr, cli;

	// socket create and verification
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd == -1) {
		printf("socket creation failed...\n");
		exit(0);
	}
	else
		printf("Socket successfully created..\n");
	bzero(&servaddr, sizeof(servaddr));

	// assign IP, PORT
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = inet_addr(argv[1]);
	servaddr.sin_port = htons(PORT);

	// connect the client socket to server socket
	if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr))
		!= 0) {
		printf("connection with the server failed...\n");
		exit(0);
	}
	else
		printf("connected to the server..\n");

	// function for chat
	func(sockfd);

	// close the socket
	close(sockfd);
}