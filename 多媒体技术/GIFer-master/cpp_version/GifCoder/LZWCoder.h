#ifndef _LZWCODER_H_
#define _LZWCODER_H_

#include <sstream>
#include <map>
#include <string>
class LZWCoder{
public:
	void initial();
	unsigned int getHeader();
	unsigned int getTailer();
	unsigned int getCode(std::string str);
private:
	std::map<std::string,unsigned int> dictionary_;
	unsigned int current_size_;
	unsigned int limit_size_;
	std::stringstream strparser_;
};

#endif