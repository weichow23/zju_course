#include <stdlib.h>
#include <iostream>
#include "BMPReader.h"

int BMPReader::openBMP(const char* path){
	bitmap_ = FreeImage_Load(FIF_BMP,path);
	if(!bitmap_){
		return -1;
	}
	palette_=(unsigned char*)malloc(sizeof(unsigned char)*3*256);
	RGBQUAD *palette=FreeImage_GetPalette(bitmap_);
	for(int i=0;i<256;i++){
		palette_[i*3+0]=palette[i].rgbRed;
		palette_[i*3+1]=palette[i].rgbGreen;
		palette_[i*3+2]=palette[i].rgbBlue;
	}
	width_=FreeImage_GetWidth(bitmap_);
	height_=FreeImage_GetHeight(bitmap_);
	current_height_=height_-1;
	current_width_=0;
}

unsigned char* BMPReader::getPalette(){
	return palette_;
}

bool BMPReader::hasPixelLeft(){
	if(current_height_<0){
		return FALSE;
	}
	return TRUE;
}

bool BMPReader::getNextPixel(unsigned char* pixel){
	if(FreeImage_GetPixelIndex(bitmap_,current_width_,current_height_,pixel)==TRUE){
		current_width_++;
		if(current_width_==width_){
			current_width_=0;
			current_height_--;
		}
		//std::cout<<current_width_<<", "<<current_height_<<std::endl;
		return TRUE;
	}
	else{
		return FALSE;
	}
}