#pragma warning(disable:4996)

#ifndef _READBMPFILE_
#define _READBMPFILE_

#define MAXHEIGHT 2000
#define MAXWIDTH 2300

#include<string>
#include<iostream>
using namespace std;

typedef struct {
	//unsigned short bfType;		//type of file
	unsigned long	bfSize;		//size of file
	unsigned short bfReserved1;
	unsigned short	bfReserved2;
	unsigned long	bfOffBits;	//offset
}FileHead;
//ostream & operator<<(ostream& out, FileHead& head)
//{
//	out << 0x4d42 << head.bfSize << head.bfReserved1 << head.bfReserved2 << head.bfOffBits;
//	return out;
//}

typedef struct {
	unsigned long  biSize; 		//size of FileHead
	long   biWidth; 		//Pixels of width
	long   biHeight; 		//Pixels of height
	unsigned short   biPlanes;
	unsigned short   biBitCount;	//bit per pixel
	unsigned long  biCompression; 	//type of compression
	unsigned long  biSizeImage; 	//size of image
	long   biXPelsPerMeter;
	long   biYPelsPerMeter;
	unsigned long   biClrUsed;
	unsigned long   biClrImportant;
}InfoHead;
//ostream & operator<<(ostream& out, InfoHead& head)
//{
//	out << head.biSize << head.biWidth << head.biHeight << head.biPlanes << head.biPlanes 
//		<< head.biBitCount << head.biCompression << head.biSizeImage <<
//		head.biXPelsPerMeter << head.biYPelsPerMeter << head.biClrUsed << head.biClrImportant;
//	return out;
//}

struct BMPFileHead {
	FileHead filehead;
	InfoHead infohead;
};
typedef struct BMPFileHead BMPhead;
//ostream & operator<<(ostream& out, BMPhead& head)
//{
//	out << head.filehead << head.infohead;
//	return out;
//}

struct BMPInfo {
	int height;
	int width;
	int offset;

	int *R;
	int *G;
	int *B;

	string filename;
};

class ReadBMPFile {
protected:
	string filename;		// BMP file name
	string location;		// location for BMP file
	BMPhead head;			// BMP Head information
	FILE *headfp;			// FILE head ptr
	FILE *colorfp;			// FILE color ptr;
	int height;				// row num in BMP
	int width;				// col num in BMP
	int offset;				// BMP file offset
	int bit;				// type of BMP color(24-bit)

	int* R;			// store R vector
	int* G;			// store G vector
	int* B;			// store B vector

public:
	// ctors
	ReadBMPFile() {}
	ReadBMPFile(string filename) :filename(filename) {
		if (!ReadBMPHead()) {
			cout << "BMP File Open ERROR!" << endl;
		}
		else {
			cout << "BMP File Open success!" << endl;
		}
	}
	ReadBMPFile(string filename, string location) :filename(filename), location(location) {
		if (!ReadBMPHead()) {
			cout << "BMP File Open ERROR!" << endl;
		}
		else {
			cout << "BMP File Open success!" << endl;
		}
	}

private:
	bool ReadBMPHead();

public:
	BMPInfo getinfo() {
		BMPInfo info;
		info.height = height;	info.width = width;	info.offset = offset;
		info.R = R;	info.G = G;	info.B = B;
		info.filename = filename;
		return info;
	}

	int getheight() { return height; }
	int getwidth() { return width; }
	int* getR() { return R; }
	int* getG() { return G; }
	int* getB() { return B; }

	void output(string after);				// This function output the bmp head to another file
};

#endif
