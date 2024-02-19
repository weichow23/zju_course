#include <iostream>
#include <iomanip>
#include "../GifCoder/BMPReader.h"
#include "../GifCoder/DataBlockGenerator.h"

int main(){
	BMPReader bmp_reader;
	if(bmp_reader.openBMP("result000001.bmp")){
		std::cout<<"Open Succeed!"<<std::endl;
	}
	else{
		return -1;
	}
	DataBlockGenerator dbg;
	dbg.initial();
	for(int i=0;i<100;i++){
		if(bmp_reader.hasPixelLeft()){
			unsigned char pixel;
			bmp_reader.getNextPixel(&pixel);
			std::cout<<"pixel : "<<std::hex<<(unsigned int)pixel<<std::dec<<std::endl;
			dbg.inputPixelData(pixel);
		}
		else{
			break;
		}
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