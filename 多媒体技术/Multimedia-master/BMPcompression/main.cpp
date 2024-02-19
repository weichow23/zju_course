#include <windows.h>
#include <stdio.h>
#include <time.h>
#include <sys/stat.h>
#include "ReadBMP.h"
#include "WriteBMP.h"
#include "HuffmanTree.h"
#include "LosslessCompress.h"
#include "LossyCompress.h"

// 通过stat结构体 获得文件大小，单位字节
size_t getFileSize1(const char *fileName) {

	if (fileName == NULL) {
		return 0;
	}
	
	// 这是一个存储文件(夹)信息的结构体，其中有文件大小和创建时间、访问时间、修改时间等
	struct stat statbuf;

	// 提供文件名字符串，获得文件属性结构体
	stat(fileName, &statbuf);
	
	// 获取文件大小
	size_t filesize = statbuf.st_size;

	return filesize;
}

void ConvertToRGB(BMPFILE* bmp)
{
    BMPFILE r(bmp);
    BMPFILE g(bmp);
    BMPFILE b(bmp);

    //空BYTE数组
    BYTE* e = new BYTE[bmp->getImageSize()/3];
    for (int i = 0; i < bmp->getImageSize()/3; i++) {
        e[i] = 0;
    }
    r.setG(e);
    r.setB(e);
    g.setR(e);
    g.setB(e);
    b.setR(e);
    b.setG(e);

    writeBMPFile("1-r.bmp", &r);
    writeBMPFile("1-g.bmp", &g);
    writeBMPFile("1-b.bmp", &b);    
}

void TestHuffman()
{
    unsigned char ch[8] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
    int f[8] = {1,2,3,4,5,6,7,8};
    HuffmanNode* root = buildHuffmanTree(8, f, ch);
    printLevelOrder(root);
    string code="";
    printHuffmanCode(root, code);
}

void LossyCompress(BMPFILE &bmp, string &losname, string &output)
{
    LossyEncode(losname.c_str(), &bmp);
    BMPFILE decode_bmp = LossyDecode(losname.c_str());
    writeBMPFile(output.c_str(), &decode_bmp);
}

void LosslessCompress(BMPFILE &bmp, string &hufname, string &output)
{
    unordered_map<unsigned char,string> code;
    unordered_map<string, unsigned char> anticode;
    encode(hufname.c_str(), &bmp, anticode);
    BMPFILE decode_bmp = decode(hufname.c_str(), anticode);
    writeBMPFile(output.c_str(), &decode_bmp);
    //bmp.writeData("1-data.txt");
    //decode_bmp.writeData("1-decode-data.txt");
}

int main()
{
    string input,output,hufname,losname,cprname;
    int lossy;
    cout << "Please enter the filename which you want to read: " << endl;
    cout << "  ";
    cin >> input;
    cout << "Please enter the filename which you want to write: " << endl;
    cout << "  ";
    cin >> output;
    cout << "Please enter the compression method: " << endl;
    cout << "  0. Lossy" << endl;
    cout << "  1. Lossless" << endl;
    cout << "  ";
    cin >> lossy;

    hufname = input.substr(0,input.find('.')) + ".huf";
    losname = input.substr(0,input.find('.')) + ".los";
    clock_t start_time=clock();
    BMPFILE bmp(input.c_str());

    // ConvertToRGB(&bmp);
    //TestHuffman();

    if (lossy==0) {
        cprname = losname;
        LossyCompress(bmp, losname, output);
    }
    else {
        cprname = hufname;
        LosslessCompress(bmp, hufname, output);
    }

    clock_t end_time=clock();
    cout << "Program running time: " << (double)(end_time-start_time)/CLOCKS_PER_SEC << "s" << endl;
    cout << "Compression rate: " << (double)getFileSize1(cprname.c_str())/(double)getFileSize1(input.c_str()) << endl;
    return 0;
}
