#include <iostream>
#include "../GifCoder/DataBlockGenerator.h"


unsigned char testData[]={0x52,0x92,0x5a,0x92,0x52,0x92,0x5a,0x92,0x52,0x92,0x5a,0x92};

int main(){
	std::cout<<sizeof(unsigned int)<<std::endl;
	DataBlockGenerator dbg;
	dbg.initial();
	for(size_t i=0;i<sizeof(testData)/sizeof(unsigned char);i++){
		dbg.inputPixelData(testData[i]);
	}
	dbg.inputFinish();
	unsigned char* codedData;
	while(dbg.hasDataLeft()){
		size_t size=dbg.getDataBlock(codedData);
		for(size_t i=0;i<size;i++){
			std::cout<<std::dec<<"data: "<<i<<" : "<<std::hex<<(unsigned int)codedData[i]<<std::endl;
		}
		std::cout<<std::endl;
	}
	dbg.deinitial();
}