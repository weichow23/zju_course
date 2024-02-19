#include <iostream>
#include <iomanip>
#include "BMPReader.h"
#include "FreeImage.h"

int main(){
	BMPReader bmp_reader;
	if(bmp_reader.openBMP("result000001.bmp")){
		std::cout<<"Open Succeed!"<<std::endl;
	}
	else{
		return -1;
	}
	unsigned char* palette=bmp_reader.getPalette();
	for(int i=0;i<256;i++){
		std::cout<<"palette "<<i<<" : "<<(int)palette[i*3+0]<<", "<<(int)palette[i*3+1]<<", "<<(int)palette[i*3+2]<<std::endl;
	}
	for(int i=0;i<100;i++){
		if(bmp_reader.hasPixelLeft()){
			unsigned char pixel;
			bmp_reader.getNextPixel(&pixel);
			std::cout<<i<<" pixel : "<<std::hex<<(int)pixel<<std::dec<<std::endl;
		}
		else{
			break;
		}
	}
}