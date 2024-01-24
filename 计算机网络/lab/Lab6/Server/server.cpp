#include "server.h"
#include <ws2tcpip.h> // 包含inet_ntop函数的头文件
#include <thread>

#include <iostream>
#include <ctime>

#include <vector>
#include <cstring>
#include "utils.h"
#include "fstream"

void Server::handle_requirement(SOCKET clientSocket,Server* server) {
    std::vector<char> buffer(1024);
    std::string request_data;
    while (true) {
        request_data.clear();
        int totalBytesReceived = 0;
        while (true) {
            int bytesReceived = recv(clientSocket, buffer.data() + totalBytesReceived, buffer.size() - totalBytesReceived, 0);
            if (bytesReceived <= 0) {
                closesocket(clientSocket); // 关闭套接字以避免资源泄露
                return; // 如果接收失败或连接关闭，则退出函数
            }
            totalBytesReceived += bytesReceived;
            request_data.append(buffer.begin(), buffer.begin() + totalBytesReceived);
            if (request_data.find("\r\n\r\n") != std::string::npos) {
                break; // 找到请求结束标志
            }
            if (totalBytesReceived == buffer.size()) {
                buffer.resize(buffer.size() * 2); // 动态扩展buffer的大小
            }
        }
        std::string method, path;
        std::map<std::string, std::string> headers;
        parse_http_request(request_data, method, path, headers);
        if(method=="GET"){
            handleGetRequest(clientSocket, path, server);
        }
        if(method=="POST"){
            handlePostRequest(clientSocket, path, request_data, server);
        }
    }
}

void Server::handleGetRequest(SOCKET clientSocket, const std::string& path, Server* server) {
    std::cout << "Received GET request to path: " << path << std::endl;
    std::string file_path = server->server_path + path;
    std::string response;

    int length = response_get(file_path, response);
    if (length > 0) {
        send(clientSocket, response.c_str(), response.length(), 0);
    }
}


void Server::handlePostRequest(SOCKET clientSocket, const std::string& path, const std::string& request_data, Server* server) {
    std::cout << "Received POST request to path: " << path << std::endl;
    std::string response;
    if(path!="/serverfolder/dopost"){
        response = "HTTP/1.1 404 Not Found\r\n\r\n";
        send(clientSocket, response.c_str(), response.length(), 0);
    }
    else {
        std::string response_body;
        size_t pos = request_data.find("\r\n\r\n");
        std::cout << "try to ack" << std::endl;
        if (pos != std::string::npos) {
            response_body = request_data.substr(pos + 4);
        }
        std::string response;
        login_response(response, response_body == "login=3210103790&pass=3790");
        std::cout << "Sending response: " << response << std::endl;
        send(clientSocket, response.c_str(), response.length(), 0);
    }
}

void Server::init() {
    // 创建监听套接字
    if (!InitializeWinsock()) {
        std::cerr << "Failed to initialize Winsock." << std::endl;
        return;
    }
    // 绑定监听端口
    serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == INVALID_SOCKET) {
        std::cerr << "Failed to create socket." << std::endl;
        return;
    }
    // 设置连接等待队列长度
    sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port);
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    if (bind(serverSocket, (sockaddr*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR) {
        std::cerr << "Bind failed." << std::endl;
        closesocket(serverSocket);
        return ;
    }

    if (listen(serverSocket, SOMAXCONN) == SOCKET_ERROR) {
        std::cerr << "Listen failed." << std::endl;
        closesocket(serverSocket);
        return ;
    }
}

int Server::run() {
    init(); // Server类的初始化函数
    std::vector<std::unique_ptr<std::thread>> clientThreads;
    char buffer[1024];
    if(GetModuleFileName(NULL,buffer,1024)==0)
        std::cerr<<"not such path"<<std::endl;
    server_path=buffer;
    size_t lastSlash = server_path.find_last_of("\\/"); // 寻找最后一个斜杠或反斜杠的位置
    if (lastSlash != std::string::npos) {
        server_path = server_path.substr(0, lastSlash+1); // 去掉最后一个斜杠及之后的内容
    }
    std::cout<<server_path<<std::endl;

    while (true) {
        sockaddr_in clientAddr;
        int clientAddrLen = sizeof(clientAddr);
        SOCKET clientSocket = accept(serverSocket, (sockaddr*)&clientAddr, &clientAddrLen);
        if (clientSocket == INVALID_SOCKET) {
            std::cerr << "Accept failed with error: " << WSAGetLastError() << std::endl;
            continue;
        }
        // 使用智能指针和线程池创建子线程来处理客户端通信
        auto clientThread = std::make_unique<std::thread>(this->handle_requirement, clientSocket, this);
        clientThreads.push_back(std::move(clientThread));
        // 清理已完成的线程
        clientThreads.erase(std::remove_if(clientThreads.begin(), clientThreads.end(),
                                           [](const std::unique_ptr<std::thread>& t) { return !t->joinable(); }), clientThreads.end());
    }
}

std::string Server::indentify_content_type(const std::string &file_extension) {
    if (file_extension == "html") {
        return "text/html";
    } else if (file_extension == "txt") {
        return "text/plain";
    } else if (file_extension == "png") {
        return "image/png";
    } else if (file_extension == "jpg" || file_extension == "jpeg") {
        return "image/jpeg";
    } else {
        return "application/octet-stream";
    }
}

int Server::response_get(const std::string& file_path, std::string& response) {
    std::ifstream stream(file_path, std::ios::binary | std::ios::ate);
    // 未找到文件
    if (!stream) {
        response = "HTTP/1.1 404 Not Found\r\n\r\n";
        return 0;
    }
    size_t length = stream.tellg();
    stream.seekg(0, std::ios::beg);
    std::vector<char> buffer(length);
    // 读取文件失败
    if (!stream.read(buffer.data(), buffer.size())) {
        response = "HTTP/1.1 500 Internal Server Error\r\n\r\n";
        return 0;
    }
    // 读取文件成功
    size_t lastDot = file_path.find_last_of(".");
    std::string file_extension = (lastDot != std::string::npos) ? file_path.substr(lastDot + 1) : "";

    response = "HTTP/1.1 200 OK\r\n";
    response += "Content-Type: " + indentify_content_type(file_extension) + "\r\n";
    response += "Content-Length: " + std::to_string(length) + "\r\n\r\n";
    response.append(buffer.begin(), buffer.end());
    return length;
}




int Server::login_response(std::string &response, bool flag) {
    std::string content;
    if (flag) {
        content = "<center><h1>Login Success!<h1></center>\r\n";
    } else {
        content = "<center><h1>Login Failed!<h1></center>\r\n";
    }

    response = "HTTP/1.1 200 OK\r\n";
    response += "Content-Type: text/html\r\n";
    response += "Content-Length: " + std::to_string(content.length()) + "\r\n\r\n";
    response += content;

    return 0;
}

