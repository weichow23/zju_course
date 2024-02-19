
#include "ReadBMP.h"

BMPFILE::BMPFILE(const char* filename):width(0), height(0), colorDepth(0), imageSize(0){

    std::cout << "Reading bmp image from " << filename << "..." << std::endl;

    // 打开BMP文件
    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
        printf("Failed to open file.\n");
        throw std::runtime_error("Error: Could not open file " + std::string(filename));
    }

    // 读取BMP文件头
    fread(&bmpHeader, sizeof(BITMAPFILEHEADER), 1, file);

    // 判断文件是否是BMP文件
    if (bmpHeader.bfType != 0x4D42) {
        printf("Invalid BMP file format.\n");
        fclose(file);
        throw std::runtime_error("Error: Invalid BMP file format.");
    }

    // 读取位图信息头
    fread(&bmpInfo, sizeof(BITMAPINFOHEADER), 1, file);

    // 获取图像宽度、高度、颜色深度、像素数组大小等信息
    width = bmpInfo.biWidth;
    height = bmpInfo.biHeight;
    colorDepth = bmpInfo.biBitCount;
    imageSize = bmpInfo.biSizeImage;

    // 如果是8位颜色深度的BMP文件，读取调色板
    if (colorDepth == 8) {
        fread(palette, sizeof(RGBQUAD), 256, file);
    }

    // 分配内存并读取像素数组
    bmpData = new BYTE[imageSize];
    fread(bmpData, sizeof(BYTE), imageSize, file);

    // 关闭文件
    fclose(file);

    std::cout << "  Reading finished!" << std::endl;

};

BMPFILE::BMPFILE(int width, int height, int colorDepth, BYTE* bmpData):width(width), height(height), colorDepth(colorDepth), imageSize(width*height*colorDepth/8), bmpData(bmpData){
    // 创建文件头
    bmpHeader.bfType = 0x4D42; // "BM"
    bmpHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + imageSize;
    bmpHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    // 创建信息头
    bmpInfo.biSize = sizeof(BITMAPINFOHEADER);
    bmpInfo.biWidth = width;
    bmpInfo.biHeight = height;
    bmpInfo.biPlanes = 1;
    bmpInfo.biBitCount = colorDepth;
    bmpInfo.biCompression = BI_RGB;
    bmpInfo.biSizeImage = imageSize;

    // 如果是8位颜色深度的BMP文件，创建调色板
    if (colorDepth == 8) {
        for (int i = 0; i < 256; i++) {
            palette[i].rgbBlue = i;
            palette[i].rgbGreen = i;
            palette[i].rgbRed = i;
            palette[i].rgbReserved = 0;
        }
    }

    // 分配内存
    bmpData = new BYTE[imageSize];

};

BMPFILE::BMPFILE(BMPFILE *bmp){
    // 创建文件头
    bmpHeader.bfType = 0x4D42; // "BM"
    bmpHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + bmp->getImageSize();
    bmpHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
    
    // 创建信息头
    bmpInfo.biSize = sizeof(BITMAPINFOHEADER);
    bmpInfo.biWidth = width;
    bmpInfo.biHeight = height;
    bmpInfo.biPlanes = 1;
    bmpInfo.biBitCount = colorDepth;
    bmpInfo.biCompression = BI_RGB;
    bmpInfo.biSizeImage = imageSize;

    // 分配内存并读取像素数组
    bmpData = new BYTE[bmp->getImageSize()];
    memcpy(bmpData, bmp->getImageData(), bmp->getImageSize());

    // 获取图像宽度、高度、颜色深度、像素数组大小等信息
    width = bmp->getWidth();
    height = bmp->getHeight();
    colorDepth = bmp->getColorDepth();
    imageSize = bmp->getImageSize();

    // 如果是8位颜色深度的BMP文件，读取调色板
    if (colorDepth == 8) {
        memcpy(palette, bmp->palette, sizeof(RGBQUAD)*256);
    }


}

BMPFILE::BMPFILE(BITMAPFILEHEADER bmpHeader, BITMAPINFOHEADER bmpInfo, BYTE* bmpData){
    this->bmpHeader = bmpHeader;
    this->bmpInfo = bmpInfo;
    this->bmpData = bmpData;
    width = bmpInfo.biWidth;
    height = bmpInfo.biHeight;
    colorDepth = bmpInfo.biBitCount;
    imageSize = bmpInfo.biSizeImage;
}

BMPFILE::~BMPFILE(){
    // 释放内存
    delete[] bmpData;
};

BITMAPFILEHEADER BMPFILE::getFileHeader(){
    return bmpHeader;
}

BITMAPINFOHEADER BMPFILE::getInfoHeader(){
    return bmpInfo;
}

void BMPFILE::setFileHeader(BITMAPFILEHEADER bmpHeader){
    this->bmpHeader = bmpHeader;
}

void BMPFILE::setInfoHeader(BITMAPINFOHEADER bmpInfo){
    this->bmpInfo = bmpInfo;
}

DWORD BMPFILE::getWidth(){
    return width;
};

DWORD BMPFILE::getHeight(){
    return height;
};

DWORD BMPFILE::getColorDepth(){
    return colorDepth;
};

DWORD BMPFILE::getImageSize(){
    return imageSize;
};

BYTE* BMPFILE::getImageData(){
    return bmpData;
};

BYTE* BMPFILE::getR(){
    BYTE* r = new BYTE[width * height];
    for (int i = 0; i < width * height; i++) {
        r[i] = getImageData()[3*i+2];
    }
    return r;
};

BYTE* BMPFILE::getG(){
    BYTE* g = new BYTE[width * height];
    for (int i = 0; i < width * height; i++) {
        g[i] = getImageData()[3*i+1];
    }
    return g;
};

BYTE* BMPFILE::getB(){
    BYTE* b = new BYTE[width * height];
    for (int i = 0; i < width * height; i++) {
        b[i] = getImageData()[3*i];
    }
    return b;
};

void BMPFILE::setR(BYTE* r){
    for (int i = 0; i < width * height; i++) {
        getImageData()[3*i+2] = r[i];
    }
};

void BMPFILE::setG(BYTE* g){
    for (int i = 0; i < width * height; i++) {
        getImageData()[3*i+1] = g[i];
    }
};

void BMPFILE::setB(BYTE* b){
    for (int i = 0; i < width * height; i++) {
        getImageData()[3*i] = b[i];
    }
};

void BMPFILE::setImageData(BYTE* bmpData){
    this->bmpData = bmpData;
}

void BMPFILE::writeData(const char *filename){
    // 打开文件
    using namespace std;
	fstream f;
	f.open("data.txt",ios::out); 
    for(DWORD i=0 ;i<imageSize;i++){
        cout << (int)bmpData[i] << " ";
        f << (int)bmpData[i] << " ";
    }
    f.close();
}

void PrintInfo(BMPFILE* bmp)
{
    printf("width: %d\n", bmp->getWidth());
    printf("height: %d\n", bmp->getHeight());
    printf("color depth: %d\n", bmp->getColorDepth());
    printf("image size: %d\n", bmp->getImageSize());
}

