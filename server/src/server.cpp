#include "server.hpp"

#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <cassert>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <thread>
#include <utility>

#include "h4_types.hpp"

void Server::server_loop() {
    char *buffer = static_cast<char *>(malloc(sizeof(char) * H40_MAX_MESSAGE_LENGTH));
    assert(buffer != nullptr);

    int sockfd = this->socketfd;
    struct sockaddr_in cliaddr;
    memset(&cliaddr, 0, sizeof(cliaddr));

    while (this->running == false) {
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    while (true) {
        if (this->running == false) {
            break;
        }

        socklen_t len = sizeof(cliaddr);
        int n = recvfrom(sockfd, buffer, H40_MAX_MESSAGE_LENGTH, MSG_WAITALL,
                         (struct sockaddr *)&cliaddr, &len);

        buffer[n] = 0;

        char *msg = static_cast<char *>(malloc(sizeof(char) * n));
        assert(msg != nullptr);

        memcpy(msg, buffer, n);
        on_recieve_callback(this, std::make_pair(msg, n), cliaddr);
    }

    free(buffer);
}

Server::Server(RecieveCallbackFunc on_recieve_callback) {
    Server(0, on_recieve_callback);
}

Server::Server(u16 port, RecieveCallbackFunc on_recieve_callback) {
    this->on_recieve_callback = on_recieve_callback;
    this->is_valid = true;
    this->socketfd = 0;

    if ((socketfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("Socket creator failed");

        this->is_valid = false;
        return;
    }

    memset(&this->serveraddr, 0, sizeof(serveraddr));

    this->serveraddr.sin_family = AF_INET;
    this->serveraddr.sin_addr.s_addr = INADDR_ANY;
    this->serveraddr.sin_port = htons(port);

    if (bind(socketfd, (const struct sockaddr *)&this->serveraddr,
             sizeof(serveraddr)) < 0) {
        perror("Socket binding failed.");

        this->is_valid = false;
        return;
    }

    this->thread = std::thread(&Server::server_loop, this);
}

void Server::run() {
    if (!this->is_valid) {
        perror("Trying to run an invalid Server.");
        exit(EXIT_FAILURE);
    }

    char ip[INET_ADDRSTRLEN] = {0};
    u16 port;
    
    inet_ntop(AF_INET, &this->serveraddr, ip, sizeof(ip));
    port = htons(this->serveraddr.sin_port);

    printf("Running server: %s:%d\n", ip, port);
    fflush(stdout);

    this->running = true;
}

void Server::stop() {
    if (!this->is_valid) {
        perror("Trying to run an invalid Server.");
        exit(EXIT_FAILURE);
    }

    this->running = false;
    this->thread.detach();
}