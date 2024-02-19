#ifndef _DATABLOCKGENERATOR_H_
#define _DATABLOCKGENERATOR_H_

#include <string>
#include <vector>
#include <sstream>
#include "LZWCoder.h"

class DataBlockGenerator{
public:
	void initial();
	void inputPixelData(unsigned char data);
	void inputFinish();
	bool hasDataLeft();
	size_t getDataBlock(unsigned char* &data);
	void deinitial();
private:
	void putData(unsigned int data);
	unsigned int currentCode_;
	std::string currentData_;
	std::string newData_;
	std::vector<unsigned char*> data_;
	unsigned int output_block_;
	unsigned int current_block_;
	unsigned int current_position_;
	unsigned int current_bit_;
	LZWCoder lzw_coder_;
	std::stringstream strparser_;
};

#endif