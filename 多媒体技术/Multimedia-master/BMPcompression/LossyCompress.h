#ifndef LOSSYCOMPRESS_H
#define LOSSYCOMPRESS_H

#include <iostream>
#include <windows.h>
#include "ReadBMP.h"

class MyRGB
{
public:
    MyRGB(BYTE r, BYTE g, BYTE b);
    MyRGB();
    BYTE getR();
    BYTE getG();
    BYTE getB();
    void setR(BYTE r);
    void setG(BYTE g);
    void setB(BYTE b);
private:
    BYTE r, g, b;
};

BYTE Convert24To8(MyRGB rgb);
MyRGB Convert8To24(BYTE b);

void LossyEncode(const char *filename, BMPFILE *bmp);
BMPFILE LossyDecode(const char *filename);

#endif  // LOSSYCOMPRESS_H