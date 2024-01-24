//
// Created by 17124 on 2023/10/9.
//

#ifndef SERVER_SERVER_H
#define SERVER_SERVER_H
#include <iostream>
#include <ctime>

#include <thread>
#include <vector>
#include <cstring>
#include <thread>
#include <winsock2.h>
#include "utils.h"
#include "fstream"
class Server{
    int port;
    SOCKET serverSocket;
    void init();
    std::string server_path;

    static void handle_requirement(SOCKET clientSocket,Server* server);
    static void handleGetRequest(SOCKET clientSocket, const std::string& path, Server* server);
    static void handlePostRequest(SOCKET clientSocket, const std::string& path, const std::string& request_data, Server* server);

    static int response_get(const std::string& file_path, std::string& response);
    static int login_response(std::string &response,bool flag);

    static std::string indentify_content_type(const std::string& file_extension);
public:
    Server(int _port):port(_port){};
    int run();
};


#endif //SERVER_SERVER_H
