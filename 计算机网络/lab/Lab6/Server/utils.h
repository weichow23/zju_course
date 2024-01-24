//
// Created by 17124 on 2023/10/9.
//

#ifndef SERVER_UTILS_H
#define SERVER_UTILS_H
#include "winsock2.h"
#include "string"
#include "map"
#include "sstream"
bool InitializeWinsock();

std::string parse_http_request(std::string& request_data, std::string& method,
                               std::string& path, std::map<std::string, std::string>& headers) ;

#endif
//SERVER_UTILS_H
