#ifndef _BMPREADER_H_
#define _BMPREADER_H_

#include "FreeImage.h"

class BMPReader{
public:
	int openBMP(const char* path);
	unsigned char* getPalette();
	bool hasPixelLeft();
	bool getNextPixel(unsigned char* pixel);
private:
	FIBITMAP* bitmap_;
	unsigned char* palette_;
	int width_;
	int height_;
	int current_width_;
	int current_height_;
};

#endif