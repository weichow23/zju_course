#include"ReadBMPFile.h"
#include<stdlib.h>
#include<iostream>
using namespace std;

bool ReadBMPFile::ReadBMPHead()
{
	FILE *f;

	if (filename.empty()) {							// if filename not exists, return 0
		cout << "Not an available Filename!" << endl;
		return false;
	}
	else if (!location.empty()) {					// read BMP Head from location
		if ((f = fopen((location + "\\" + filename).c_str(), "rb")) == NULL) {
			cout << "BMP not found by location!" << endl;
			return false;
		}
	}
	else {											// read BMP Head from current location
		if ((f = fopen(filename.c_str(), "rb")) == NULL) {
			cout << "BMP not found in current location!" << endl;
			return false;
		}
	}

	this->headfp = f;								// we firstly store the start head fp

	unsigned short bfType;
	fread(&bfType, sizeof(unsigned short), 1, f);
	if (bfType != 0x4d42) {							// check BMP type
		printf("This is not an available BMP file!\n");
		return false;
	}

	fread(&head.filehead, sizeof(FileHead), 1, f);	// read FileHead
	fread(&head.infohead, sizeof(InfoHead), 1, f);	// read InfoHead

	// process BMPHead data
	height = head.infohead.biHeight;				// get length and width
	width = head.infohead.biWidth;					
	bit = head.infohead.biBitCount;					// BMP use offsets to syncronize each row
	if ((offset = (bit / 8 * width) % 4) != 0) offset = 4 - offset;

	this->colorfp = f;								// store color head fp

	// process color data
	int a;
	if (bit != 24) {								// check color bit
		printf("Read Color ERROR, not 24bits!\n");
		cout << "BMPFile not 24-bit, Sorry." << endl;
		return false;
	}
	if (width > MAXWIDTH || height > MAXHEIGHT) {	// check image size
		printf("Too large bmp file!\n");
		cout << "BMP File too large! sorry." << endl;
	}

	fseek(f, head.filehead.bfOffBits, 0);

	R = new int[height * width];
	G = new int[height * width];
	B = new int[height * width];

	int i, j;
	unsigned char r, g, b;				// used to change bmp file unsigned char typr to int type
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			fread(&b, 1, 1, f);			// read data
			fread(&g, 1, 1, f);
			fread(&r, 1, 1, f);
			
			B[i * width + j] = (int)b;	// change type and store
			G[i * width + j] = (int)g;
			R[i * width + j] = (int)r;

		}
		if (offset != 0) fread(&a, offset, 1, f);
	}

	/*cout << "TEST:::::in readfile" << endl;
	for (int i = 0; i < 20; i++) {
		cout << R[i] << " " << G[i] << " " << B[i] << endl;
	}*/

	return true;
}

void ReadBMPFile::output(string after) {
	// output BMPFileHead to compress file
	FILE *fp;
	if ((fp = fopen((filename + "." + after).c_str(), "wb")) == NULL) {
		printf("Write Compress ERROR!\n");
		exit(0);
	}
	unsigned short bfType=0x4d42;
	fwrite(&bfType, 2, 1, fp);			// bfType is bot belong to BMPFileHead
	fwrite(&head.filehead, sizeof(FileHead), 1, fp);
	fwrite(&head.infohead, sizeof(InfoHead), 1, fp);

	// output BMPFileHead to decompress file
	FILE *ffp;
	if ((ffp = fopen((filename + "." + after + ".bmp").c_str(), "wb")) == NULL) {
		printf("Write Decompress ERROR!\n");
		exit(0);
	}
	fwrite(&bfType, 2, 1, ffp);			// bfType is bot belong to BMPFileHead
	fwrite(&head.filehead, sizeof(FileHead), 1, ffp);
	fwrite(&head.infohead, sizeof(InfoHead), 1, ffp);

	cout << "Successfully generate compress & decompress file" << endl;
}