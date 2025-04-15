#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include "zenoh.hxx"

#define OSI_OUT_PORT 48198
#define MAX_MSG_SIZE 1024000
#define OSI_MAX_UDP_DATA_SIZE 8200
#define ES_SERV_TIMEOUT 500
#define ZENOH_TOPIC "esmini/gt"

static bool quit = false;

void CloseGracefully(int socket) {
    if (close(socket) < 0) {
        perror("Failed closing socket");
    }
}

void signal_handler(int) {
    quit = true;
}

int main() {
    signal(SIGINT, signal_handler);

    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sock < 0) {
        perror("Socket creation failed");
        return -1;
    }

    struct timeval tv = {ES_SERV_TIMEOUT / 1000, (ES_SERV_TIMEOUT % 1000) * 1000};
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

    struct sockaddr_in server_addr = {};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(OSI_OUT_PORT);
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(sock, reinterpret_cast<struct sockaddr*>(&server_addr), sizeof(server_addr)) != 0) {
        perror("Bind failed");
        CloseGracefully(sock);
        return -1;
    }

    printf("Listening on port %d. Press Ctrl-C to quit.\n", OSI_OUT_PORT);

    zenoh::Config config = zenoh::Config::create_default();
    auto session = zenoh::Session::open(std::move(config));
    auto pub = session.declare_publisher(zenoh::KeyExpr(ZENOH_TOPIC));

    struct {
        int counter;
        unsigned int datasize;
        char data[OSI_MAX_UDP_DATA_SIZE];
    } buf;

    char large_buf[MAX_MSG_SIZE];
    struct sockaddr_in sender_addr;
    socklen_t sender_addr_size = sizeof(sender_addr);

    while (!quit) {
        buf.counter = 1;
        int receivedDataBytes = 0;

        while (buf.counter > 0) {
            int retval = recvfrom(sock, &buf, sizeof(buf), 0,
                                  reinterpret_cast<struct sockaddr*>(&sender_addr), &sender_addr_size);
            if (retval > 0) {
                if (buf.counter == 1) receivedDataBytes = 0;
                memcpy(&large_buf[receivedDataBytes], buf.data, buf.datasize);
                receivedDataBytes += buf.datasize;
            } else {
                break;
            }
        }

        if (receivedDataBytes > 0) {
            pub.put(std::string(large_buf, receivedDataBytes));
        } else {
            usleep(10000); // Sleep for 10ms
        }
    }

    CloseGracefully(sock);
    return 0;
}