
#include "WriteBMP.h"

void writeBMPFile(const char* filename, BMPFILE *bmp)
{

    std::cout << "Writing BMP file into " << filename << std::endl;

    // 打开输出文件
    FILE* fp = fopen(filename, "wb");
    if (fp == NULL) {
        printf("Failed to create file.\n");
        throw std::runtime_error(("Error: Could not open file " + std::string(filename)));
    }

    // 计算文件头和信息头的大小
    DWORD fileHeaderSize = sizeof(BITMAPFILEHEADER);
    DWORD infoHeaderSize = sizeof(BITMAPINFOHEADER);

    // 计算像素数据的大小（以字节为单位）
    DWORD pixelDataSize = bmp->getWidth() * bmp->getHeight() * sizeof(RGBQUAD);

    // 计算文件总大小
    DWORD fileSize = fileHeaderSize + infoHeaderSize + pixelDataSize;

    // 创建文件头
    BITMAPFILEHEADER fileHeader = {};
    fileHeader.bfType = 0x4D42; // "BM"
    fileHeader.bfSize = fileSize;
    fileHeader.bfOffBits = fileHeaderSize + infoHeaderSize;

    // 创建信息头
    BITMAPINFOHEADER infoHeader = {};
    infoHeader.biSize = infoHeaderSize;
    infoHeader.biWidth = bmp->getWidth();
    infoHeader.biHeight = bmp->getHeight();
    infoHeader.biPlanes = 1;
    infoHeader.biBitCount = 24;
    infoHeader.biCompression = BI_RGB;
    infoHeader.biSizeImage = pixelDataSize;

    // 写入文件头和信息头
    fwrite(&fileHeader, sizeof(fileHeader), 1, fp);
    fwrite(&infoHeader, sizeof(infoHeader), 1, fp);

    // 写入像素数据
    fwrite(bmp->getImageData(), sizeof(BYTE), bmp->getImageSize(), fp);

    // 关闭文件
    fclose(fp);

    std::cout << "  Writing finished!" << std::endl;

    return;
}
