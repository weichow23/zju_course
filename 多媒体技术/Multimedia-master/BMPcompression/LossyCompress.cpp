#include "LossyCompress.h"

MyRGB::MyRGB(BYTE r, BYTE g, BYTE b)
{
    this->r = r;
    this->g = g;
    this->b = b;
}
MyRGB::MyRGB()
{
    this->r = 0;
    this->g = 0;
    this->b = 0;
}

BYTE MyRGB::getR()
{
    return this->r;
}

BYTE MyRGB::getG()
{
    return this->g;
}

BYTE MyRGB::getB()
{
    return this->b;
}

void MyRGB::setR(BYTE r)
{
    this->r = r;
}

void MyRGB::setG(BYTE g)
{
    this->g = g;
}

void MyRGB::setB(BYTE b)
{
    this->b = b;
}

BYTE Convert24To8(MyRGB rgb)
{
    BYTE res = rgb.getR()/32*32 + rgb.getG()/32*4 + rgb.getB()/64;
    //std::cout << (int)rgb.getR() << " " << (int)rgb.getG() << " " << (int)rgb.getB() << std::endl;
    //std::cout << (int)res << std::endl;
    return res;
}

MyRGB Convert8To24(BYTE rgb)
{
    BYTE r = rgb/32*32;
    BYTE g = (rgb%32)/4*32;
    BYTE b = (rgb%32)%4*64;
    MyRGB res(r, g, b);
    //std::cout << (int)res.getR() << " " << (int)res.getG() << " " << (int)res.getB() << std::endl;
    //std::cout << (int)rgb << std::endl;    
    return res;
}

void LossyEncode(const char *filename, BMPFILE *bmp)
{

    std::cout << "Encoding..." << std::endl;

   // 打开输出文件
    FILE* fp = fopen(filename, "wb");
    if (fp == NULL) {
        printf("Failed to create file.\n");
        throw std::runtime_error(("Error: Could not open file " + std::string(filename)));
    }

    BITMAPFILEHEADER fileHeader = bmp->getFileHeader();
    BITMAPINFOHEADER infoHeader = bmp->getInfoHeader();
    int width = infoHeader.biWidth;
    int height = infoHeader.biHeight;
    int size = width*height;
    BYTE *code = new BYTE[size];
    MyRGB rgb;
    for (int i = 0; i < size; i++)
    {
        rgb.setB(bmp->getImageData()[i*3]);
        rgb.setG(bmp->getImageData()[i*3+1]);
        rgb.setR(bmp->getImageData()[i*3+2]);
        code[i] = Convert24To8(rgb);
    }

    fwrite(&fileHeader, sizeof(BITMAPFILEHEADER), 1, fp);
    fwrite(&infoHeader, sizeof(BITMAPINFOHEADER), 1, fp);

    fwrite(code, sizeof(BYTE), size, fp);

    fclose(fp);
    delete[] code;

    std::cout << "  Encoding finished!" << std::endl;
    return;
}

BMPFILE LossyDecode(const char *filename)
{
    std::cout << "Decoding..." << std::endl;

    // 打开输入文件
    FILE* fp = fopen(filename, "rb");
    if (fp == NULL) {
        printf("Failed to open file.\n");
        throw std::runtime_error(("Error: Could not open file " + std::string(filename)));
    }
    
    // 读取文件头和信息头
    BITMAPFILEHEADER fileHeader = {};
    BITMAPINFOHEADER infoHeader = {};
    fread(&fileHeader, sizeof(fileHeader), 1, fp);
    fread(&infoHeader, sizeof(infoHeader), 1, fp);

    //std::cout << infoHeader.biSizeImage << std::endl;
    BYTE* code = new BYTE[infoHeader.biSizeImage];
    fread(code, sizeof(BYTE), infoHeader.biSizeImage, fp);
    std::cout << (int)code[0] << std::endl;
    // 关闭文件
    fclose(fp);

    BYTE* bmpData = new BYTE[infoHeader.biSizeImage*3];
    MyRGB rgb;
    for(int i=0; i<infoHeader.biSizeImage; i++)
    {
        rgb = Convert8To24(code[i]);
        bmpData[3*i] = rgb.getB();
        bmpData[3*i+1] = rgb.getG();
        bmpData[3*i+2] = rgb.getR();
        //std::cout << i << " " << bmpData[3*i] << " " << bmpData[3*i+1] << " " << bmpData[3*i+2] << std::endl;
    }
    BMPFILE bmp(fileHeader, infoHeader, bmpData);

    std::cout << "  Decoding finished!" << std::endl;

    return bmp;
}
