#pragma once

#include <netinet/in.h>

#include <atomic>
#include <common/utils.hpp>
#include <functional>
#include <thread>

#define H40_MAX_MESSAGE_LENGTH 256

#define RecieveCallbackFunc \
    std::function<int(Server *, H40Bytes, struct sockaddr_in)>

class Server {
   protected:
    std::atomic_bool running = false;
    RecieveCallbackFunc on_recieve_callback;

    struct sockaddr_in serveraddr;
    int socketfd;

    bool is_valid;
    std::thread thread;

   private:
    void server_loop();

   public:
    Server(u16 port, RecieveCallbackFunc on_recieve_callback);
    Server(RecieveCallbackFunc on_recieve_callback);
    ~Server() {
        if (thread.joinable()) {
            thread.join();
        }
    }

    void run();
    void stop();

    bool is_running() const { return running; }

    H4_DEFINE_GETTER(struct sockaddr_in, serveraddr)
    H4_DEFINE_GETTER(int, socketfd)
    H4_DEFINE_GETTER_SETTER(RecieveCallbackFunc, on_recieve_callback)
};
