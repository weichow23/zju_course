#include "utils.h"
#include <iostream>

bool InitializeWinsock() {
    WSADATA wsaData;
    int result = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (result != 0) {
        std::cerr << "WSAStartup failed with error: " << result
                  << " (Error Code: " << WSAGetLastError() << ")" << std::endl;
        return false;
    }
    return true;
}

std::string parse_http_request(std::string& request_data, std::string& method,
                               std::string& path, std::map<std::string, std::string>& headers) {
    const std::string HEADER_DELIMITER = ": ";
    std::istringstream request_stream(request_data);
    std::string request_line;
    if (!getline(request_stream, request_line) || request_line.empty()) {
        return request_data; // 返回未解析的请求数据
    }

    std::istringstream request_line_stream(request_line);
    if (!(request_line_stream >> method >> path)) {
        return request_data;
    }

    std::string header;
    while (getline(request_stream, header) && !header.empty()) {
        size_t colon_pos = header.find(HEADER_DELIMITER);
        if (colon_pos != std::string::npos) {
            std::string header_name = header.substr(0, colon_pos);
            std::string header_value = header.substr(colon_pos + HEADER_DELIMITER.length());
            headers[header_name] = header_value;
        }
    }
    return request_data;
}
