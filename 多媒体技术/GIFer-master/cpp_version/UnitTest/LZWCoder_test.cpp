#include <iostream>
#include "../GifCoder/LZWCoder.h"
using namespace std;
int main(){
	LZWCoder lzw_coder;
	lzw_coder.initial();
	std::cout<<std::hex<<lzw_coder.getHeader()<<std::endl;
	std::cout<<lzw_coder.getCode(string("52"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("5292"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("925a"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("5a92"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("9252"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("5292"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("52925a"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("5a92"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("5a9252"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("52925a"))<<std::endl;
	std::cout<<lzw_coder.getCode(string("52925a92"))<<std::endl;
	return 0;
}