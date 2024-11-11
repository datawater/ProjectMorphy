#include <netinet/in.h>
#include <sys/socket.h>
#include <common/no_mangle.hpp>
#include <cstdio>

#include "h4_types.hpp"
#include "server.hpp"

int callback_function(Server *server, H40Bytes bytes,
                      struct sockaddr_in cliaddr) {
    (void)server;
    (void)bytes;
    (void)cliaddr;

    printf("Recieved %zu bytes.\n", bytes.second);
    fflush(stdout);

    sendto(server->get_socketfd(), nullptr, 0, MSG_CONFIRM, (const struct sockaddr*) &cliaddr, sizeof(cliaddr));

    return 0;
}

int main() {
    Server server(6969, callback_function);

    server.run();

    return 0;
}