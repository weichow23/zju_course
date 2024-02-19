#include"RLCCompress.h"
#include"HuffmanCompress.h"
#include"LossyCompress.h"
#include<iostream>

using namespace std;

void UI();
void RLC();
void Huff();
void JPEG();


int main()
{
	UI();

	string cmd;
	cin >> cmd;
	while (cmd != "exit") {
		if (cmd == "RLCcompression") {
			RLC();
			system("pause");
			break;
		}
		else if (cmd == "HuffmanCompression") {
			Huff();
			system("pause");
			break;
		}
		else if (cmd == "JPEG-lossy") {
			JPEG();
			system("pause");
			break;
		}
		else if (cmd == "clear") {
			system("cls");
			UI();
		}
		else {
			cout << "Unavailable command! Please check input!" << endl;
			cout << "\nPlease input your command here:" << endl;
		}
		cin >> cmd;
	}
}

void RLC()
{
	string location, name;
	cout << "Please input the BMP file location(NULL means current location):";
	cin >> location;
	cout << "Please input the BMP file name(not NULL):";
	cin >> name;

	cout << "Compression .bmp file...";
	ReadBMPFile file;
	if (location != "NULL") {
		file = ReadBMPFile(name, location);
	}
	else {
		file = ReadBMPFile(name);
	}
	file.output("RLC");
	RLCCompress rlc(file.getinfo());
	rlc.compress();
	cout << "Compression finished!"<<endl;

	cout << "Decompression .bmp.RLC file..." << endl;
	rlc.decompress();
	cout << "Decompression finished!" << endl;

	cout << "Successfully compress and decompress the BMP File!" << endl;
}

void Huff()
{
	string location, name;
	cout << "Please input the BMP file location(NULL means current location):";
	cin >> location;
	cout << "Please input the BMP file name(not NULL):";
	cin >> name;
	cout << "OK!" << endl;

	cout << "Compression .bmp file..." << endl;
	ReadBMPFile file;
	if (location != "NULL") {
		file = ReadBMPFile(location, name);
	}
	else {
		file = ReadBMPFile(name);
	}
	//file.output("RLC");
	HuffmanCompress huf(file.getinfo());
	huf.compress();
	cout << "Compression finished!"<<endl;

	cout << "Decompression huffman file..." << endl;
	huf.decompress();
	cout << "Decompression finished!" << endl;

	cout << "Successfully compress and decompress the BMP File!" << endl;
}

void JPEG()
{
	string location, name;
	cout << "Please input the BMP file location(NULL means current location):";
	cin >> location;
	cout << "Please input the BMP file name(not NULL):";
	cin >> name;

	cout << "Compression .bmp file...";
	ReadBMPFile file;
	if (location != "NULL") {
		file = ReadBMPFile(location, name);
	}
	else {
		file = ReadBMPFile(name);
	}
	JpegEncoder encoder(file.getinfo());
	cout << "Please input the quality scale: ";
	cin >> encoder.quality_scale;
	encoder.compress();
	cout << "Compression finished!";

	cout << "Successfully compress the BMP File and encode it to JPG File" << endl;
}

void UI()
{
	cout << "========================BMP File Compression=========================" << endl;
	cout << "    Suupport both Lossless compression & lossy compression" << endl;
	cout << "             MADE by Ren Hauran & Zheng Hao" << endl;
	cout << "-------------------------------------------------------------------" << endl;
	cout << "    Attention: " << endl;
	cout << "        1. the BMP file must be no larger than 2300*2000" << endl;
	cout << "        2. only support 24-Bit BMP file" << endl;
	cout << "        3. BMP file don't has Palatte" << endl;
	cout << "-------------------------------------------------------------------" << endl;
	cout << "    The following command is available:" << endl;
	cout << "        RLCcompression			| Run-Length-Coding lossless compression" << endl;
	cout << "        HuffmanCompression		| Huffman coding based lossless compression" << endl;
	cout << "        JPEG-lossy			| use DCT & quantization & output JPEG" << endl;
	cout << "        clear				| clear screen" << endl;
	cout << "        exit				| exit program" << endl;
	cout << "========================BMP File Compression=========================" << endl;
	cout << "\nPlease input your command here:" << endl;
}


/*
HuffmanCompression
NULL
bmp.bmp
*/

/*
RLCcompression
NULL
bmp.bmp
*/

/*
RLCcompression
E:\
bmp.bmp
*/