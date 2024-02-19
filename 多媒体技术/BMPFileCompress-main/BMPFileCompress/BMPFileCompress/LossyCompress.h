#ifndef __JPEG_ENCODER_HEADER__
#define __JPEG_ENCODER_HEADER__

#include"Compress.h"
#include"ReadBMPFile.h"

//-------------------------------------------------------------------------------
const unsigned char Luminance_Quantization_Table[64] =
        {
                16,  11,  10,  16,  24,  40,  51,  61,
                12,  12,  14,  19,  26,  58,  60,  55,
                14,  13,  16,  24,  40,  57,  69,  56,
                14,  17,  22,  29,  51,  87,  80,  62,
                18,  22,  37,  56,  68, 109, 103,  77,
                24,  35,  55,  64,  81, 104, 113,  92,
                49,  64,  78,  87, 103, 121, 120, 101,
                72,  92,  95,  98, 112, 100, 103,  99
        };

//-------------------------------------------------------------------------------
const unsigned char Chrominance_Quantization_Table[64] =
        {
                17,  18,  24,  47,  99,  99,  99,  99,
                18,  21,  26,  66,  99,  99,  99,  99,
                24,  26,  56,  99,  99,  99,  99,  99,
                47,  66,  99,  99,  99,  99,  99,  99,
                99,  99,  99,  99,  99,  99,  99,  99,
                99,  99,  99,  99,  99,  99,  99,  99,
                99,  99,  99,  99,  99,  99,  99,  99,
                99,  99,  99,  99,  99,  99,  99,  99
        };

//-------------------------------------------------------------------------------
const char ZigZag[64] =
        {
                0, 1, 5, 6,14,15,27,28,
                2, 4, 7,13,16,26,29,42,
                3, 8,12,17,25,30,41,43,
                9,11,18,24,31,40,44,53,
                10,19,23,32,39,45,52,54,
                20,22,33,38,46,51,55,60,
                21,34,37,47,50,56,59,61,
                35,36,48,49,57,58,62,63
        };

//-------------------------------------------------------------------------------
const char Standard_DC_Luminance_NRCodes[] = { 0, 0, 7, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 };
const unsigned char Standard_DC_Luminance_Values[] = { 4, 5, 3, 2, 6, 1, 0, 7, 8, 9, 10, 11 };

//-------------------------------------------------------------------------------
const char Standard_DC_Chrominance_NRCodes[] = { 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 };
const unsigned char Standard_DC_Chrominance_Values[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 };

//-------------------------------------------------------------------------------
const char Standard_AC_Luminance_NRCodes[] = { 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d };
const unsigned char Standard_AC_Luminance_Values[] =
        {
                0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
                0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
                0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
                0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
                0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
                0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
                0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
                0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
                0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
                0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
                0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
                0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
                0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
                0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
                0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
                0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
                0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
                0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
                0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
                0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
                0xf9, 0xfa
        };

//-------------------------------------------------------------------------------
const char Standard_AC_Chrominance_NRCodes[] = { 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 0x77 };
const unsigned char Standard_AC_Chrominance_Values[] =
        {
                0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
                0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
                0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
                0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
                0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
                0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
                0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
                0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
                0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
                0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
                0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
                0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
                0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
                0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
                0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
                0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
                0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
                0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
                0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
                0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
                0xf9, 0xfa
        };

struct HuffmanCode
{
    int length;
    int value;
};

class JpegEncoder:public Compress
{
public:
    BMPInfo info;
    int quality_scale;
    /** 压缩到jpg文件中，quality_scale表示质量，取值范围(0,100), 数字越大压缩比例越高*/
    //void encodeToJPG(int quality_scale);
    void compress() override;

private:

    char yData[64], cbData[64], crData[64];
    short yQuant[64], cbQuant[64], crQuant[64];
    unsigned char 	m_YTable[64];
    unsigned char 	m_CbCrTable[64];



    HuffmanCode m_Y_DC_Huffman_Table[12];
    HuffmanCode m_Y_AC_Huffman_Table[256];

    HuffmanCode m_CbCr_DC_Huffman_Table[12];
    HuffmanCode m_CbCr_AC_Huffman_Table[256];

    HuffmanCode outputBitString[128];
    int bitStringCounts;

private:
    void RGBtoYCbCr(int HeightBlock, int WidthBlock);
    void _initHuffmanTables(void);

    void _computeHuffmanTable(const char* nr_codes, const unsigned char* std_table, HuffmanCode* huffman_table);

    int Round(int number, int High, int Low);
    void DCT();


    void _doHuffmanEncoding(const short* DU, short& prevDC, const HuffmanCode* HTDC, const HuffmanCode* HTAC,
                            HuffmanCode* outputBitString, int& bitStringCounts);

private:
    void _write_jpeg_header(FILE* fp);
    void _write_byte_(unsigned char value, FILE* fp);
    void _write_word_(unsigned short value, FILE* fp);
    void _write_bitstring_(const HuffmanCode* bs, int counts, int& newByte, int& newBytePos, FILE* fp);
    void _write_(const void* p, int byteSize, FILE* fp);

public:
    JpegEncoder(BMPInfo info):info(info){}

};

#endif
