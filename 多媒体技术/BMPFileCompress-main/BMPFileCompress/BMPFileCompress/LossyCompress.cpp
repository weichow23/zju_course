#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <memory.h>
#include <math.h>

#include "LossyCompress.h"



void JpegEncoder::DCT() {
    memset(&yQuant,0,sizeof(yQuant));
    memset(&cbQuant,0,sizeof(cbQuant));
    memset(&crQuant,0,sizeof(crQuant));
    for(int u=0; u<8; u++)
    {
        for(int v=0; v<8; v++)
        {
            float YResult = 0.0;
            float CbResult = 0.0;
            float CrResult = 0.0;
            for(int x=0; x<8; x++) {
                for (int y = 0; y < 8; y++) {
                    YResult += (float) yData[y * 8 + x] * cos((2 * x + 1) * u * 3.1415926 / 16) *
                               cos((2 * y + 1) * v * 3.1415926 / 16);
                    CbResult += (float) cbData[y * 8 + x] * cos((2 * x + 1) * u * 3.1415926 / 16) *
                                cos((2 * y + 1) * v * 3.1415926 / 16);
                    CrResult += (float) crData[y * 8 + x] * cos((2 * x + 1) * u * 3.1415926 / 16) *
                                cos((2 * y + 1) * v * 3.1415926 / 16);
                }
            }
            if(u==0&&v==0){
                yQuant[ZigZag[u+v*8]] = (short) ((short)(YResult/(8*m_YTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                cbQuant[ZigZag[u+v*8]] = (short) ((short)(CbResult/(8*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                crQuant[ZigZag[u+v*8]] = (short) ((short)(CrResult/(8*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
            }
            else if((u==0&&v!=0)||(u!=0&&v==0)){
                yQuant[ZigZag[u+v*8]] = (short) ((short)(YResult/(2*sqrt(8.0)*m_YTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                cbQuant[ZigZag[u+v*8]] = (short) ((short)(CbResult/(2*sqrt(8.0)*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                crQuant[ZigZag[u+v*8]] = (short) ((short)(CrResult/(2*sqrt(8.0)*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
            }
            else{
                yQuant[ZigZag[u+v*8]] = (short) ((short)(YResult/(4*m_YTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                cbQuant[ZigZag[u+v*8]] = (short) ((short)(CbResult/(4*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
                crQuant[ZigZag[u+v*8]] = (short) ((short)(CrResult/(4*m_CbCrTable[ZigZag[u+v*8]]) + 16384.5) - 16384);
            }

        }
    }
}



//-------------------------------------------------------------------------------
void JpegEncoder::compress()
{


    //输出文件
    FILE* fp = fopen("output.jpg", "wb");

    _initHuffmanTables();
    //初始化量化表
    //_initQualityTables(quality_scale);
    int Scale = Round(quality_scale,99,1);
    for(int i=0;i<64;i++){
        m_YTable[ZigZag[i]] = (unsigned char)Round(((int)(Luminance_Quantization_Table[i]*Scale+50)/100),0xFF,1);
        m_CbCrTable[ZigZag[i]] = (unsigned char)Round(((int)(Chrominance_Quantization_Table[i]*Scale+50)/100),0xFF,1);
    }

    //文件头
    _write_jpeg_header(fp);

    short prev_DC_Y = 0, prev_DC_Cb = 0, prev_DC_Cr = 0;
    int newByte=0, newBytePos=7;

    for(int yPos=0; yPos<info.height; yPos+=8)
    {
        for (int xPos=0; xPos<info.width; xPos+=8)
        {

            RGBtoYCbCr(xPos,yPos);

            DCT();

            //Y通道压缩
            //_foword_FDC(yData, yQuant);
            _doHuffmanEncoding(yQuant, prev_DC_Y, m_Y_DC_Huffman_Table, m_Y_AC_Huffman_Table, outputBitString, bitStringCounts);
            _write_bitstring_(outputBitString, bitStringCounts, newByte, newBytePos, fp);

            //Cb通道压缩
            //_foword_FDCCb(cbData, cbQuant);
            _doHuffmanEncoding(cbQuant, prev_DC_Cb, m_CbCr_DC_Huffman_Table, m_CbCr_AC_Huffman_Table, outputBitString, bitStringCounts);
            _write_bitstring_(outputBitString, bitStringCounts, newByte, newBytePos, fp);

            //Cr通道压缩
            //_foword_FDCCb(crData, crQuant);
            _doHuffmanEncoding(crQuant, prev_DC_Cr, m_CbCr_DC_Huffman_Table, m_CbCr_AC_Huffman_Table, outputBitString, bitStringCounts);
            _write_bitstring_(outputBitString, bitStringCounts, newByte, newBytePos, fp);
        }
    }

    _write_word_(0xFFD9, fp); //Write End of Image Marker

    fclose(fp);


}

//-------------------------------------------------------------------------------
void JpegEncoder::_initHuffmanTables(void)
{
    //memset(&m_Y_DC_Huffman_Table, 0, sizeof(m_Y_DC_Huffman_Table));
    _computeHuffmanTable(Standard_DC_Luminance_NRCodes, Standard_DC_Luminance_Values, m_Y_DC_Huffman_Table);

    //memset(&m_Y_AC_Huffman_Table, 0, sizeof(m_Y_AC_Huffman_Table));
    _computeHuffmanTable(Standard_AC_Luminance_NRCodes, Standard_AC_Luminance_Values, m_Y_AC_Huffman_Table);

    //memset(&m_CbCr_DC_Huffman_Table, 0, sizeof(m_CbCr_DC_Huffman_Table));
    _computeHuffmanTable(Standard_DC_Chrominance_NRCodes, Standard_DC_Chrominance_Values, m_CbCr_DC_Huffman_Table);

    //memset(&m_CbCr_AC_Huffman_Table, 0, sizeof(m_CbCr_AC_Huffman_Table));
    _computeHuffmanTable(Standard_AC_Chrominance_NRCodes, Standard_AC_Chrominance_Values, m_CbCr_AC_Huffman_Table);
}



int JpegEncoder::Round(int number, int High, int Low){
    if(number >= High){
        return High;
    }
    if(number <= Low){
        return Low;
    }
    return number;
}

//-------------------------------------------------------------------------------
void JpegEncoder::_computeHuffmanTable(const char* nr_codes, const unsigned char* std_table, HuffmanCode* huffman_table)
{
    int position =0;
    unsigned short bitcode=0;

    for(int i=1;i<=16;i++){
        for(int j=1;j<=nr_codes[i-1];j++){
            huffman_table[std_table[position]].value=bitcode++;
            huffman_table[std_table[position++]].length=i;
        }
        bitcode = bitcode << 1;
    }
}

//-------------------------------------------------------------------------------
void JpegEncoder::_write_byte_(unsigned char value, FILE* fp)
{
    _write_(&value, 1, fp);
}

//-------------------------------------------------------------------------------
void JpegEncoder::_write_word_(unsigned short value, FILE* fp)
{
    unsigned short _value = ((value>>8)&0xFF) | ((value&0xFF)<<8);
    _write_(&_value, 2, fp);
}

//-------------------------------------------------------------------------------
void JpegEncoder::_write_(const void* p, int byteSize, FILE* fp)
{
    fwrite(p, 1, byteSize, fp);
}

//-------------------------------------------------------------------------------
//_doHuffmanEncoding(yQuant, prev_DC_Y, m_Y_DC_Huffman_Table, m_Y_AC_Huffman_Table, outputBitString, bitStringCounts);
//const char Standard_DC_Luminance_NRCodes[] = { 0, 0, 7, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 };
//const unsigned char Standard_DC_Luminance_Values[] = { 4, 5, 3, 2, 6, 1, 0, 7, 8, 9, 10, 11 };
void JpegEncoder::_doHuffmanEncoding(const short* DU, short& prevDC, const HuffmanCode* HTDC, const HuffmanCode* HTAC,
                                     HuffmanCode* outputBitString, int& bitStringCounts)
{
    bitStringCounts = 0;
    int int_value = 0;
    short Difference = DU[0]-prevDC;
    prevDC = DU[0];
    HuffmanCode code;
    if(Difference==0){
        outputBitString[bitStringCounts++] = HTDC[0x00];
    }else if(Difference>0){
        int_value = Difference;
        for(code.length = 0;int_value;int_value>>=1){
            code.length++;
        }
        code.value = Difference;
        outputBitString[bitStringCounts++] = HTDC[code.length];
        outputBitString[bitStringCounts++] = code;
    }else if(Difference<0){
        int_value = (-Difference);
        for(code.length = 0;int_value;int_value>>=1){
            code.length++;
        }
        code.value = ((1<<code.length)+Difference-1);
        outputBitString[bitStringCounts++] = HTDC[code.length];
        outputBitString[bitStringCounts++] = code;
    }

    int End = 63;
    while(End>0 && DU[End]==0)
        End-- ;
    for(int i = 1 ; i<=End;){
        int Start = i;
        while(i<=End && DU[i]==0)
            i++;
        int zerocount = i-Start;
        if(zerocount>=16){
            for(int j=1;j<=zerocount/16;j++){
                outputBitString[bitStringCounts++] = HTAC[0xF0];

                zerocount = zerocount%16;
            }
        }
        if(DU[i]>0){
            int_value = DU[i];
            for(code.length = 0;int_value;int_value>>=1){
                code.length++;
            }
            code.value = DU[i];
            outputBitString[bitStringCounts++] = HTAC[(zerocount<<4)|code.length];
            outputBitString[bitStringCounts++] = code;
        }else if(DU[i]<0){
            int_value = (-DU[i]);
            for(code.length = 0;int_value;int_value>>=1){
                code.length++;
            }
            code.value = ((1<<code.length)+DU[i]-1);
            outputBitString[bitStringCounts++] = HTAC[(zerocount<<4)|code.length];
            outputBitString[bitStringCounts++] = code;
        }
        i++;
    }

    if (End != 63)
        outputBitString[bitStringCounts++] = HTAC[0x00];
}

//-------------------------------------------------------------------------------
void JpegEncoder::_write_bitstring_(const HuffmanCode* bs, int counts, int& newByte, int& newBytePos, FILE* fp)
{
    unsigned short mask[] = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768};

    for(int i=0; i<counts; i++)
    {
        int value = bs[i].value;
        int posval = bs[i].length - 1;

        while (posval >= 0)
        {
            if ((value & mask[posval]) != 0)
            {
                newByte = newByte  | mask[newBytePos];
            }
            posval--;
            newBytePos--;
            if (newBytePos < 0)
            {
                // Write to stream
                _write_byte_((unsigned char)(newByte), fp);
                if (newByte == 0xFF)
                {
                    // Handle special case
                    _write_byte_((unsigned char)(0x00), fp);
                }

                // Reinitialize
                newBytePos = 7;
                newByte = 0;
            }
        }
    }
}

void JpegEncoder::RGBtoYCbCr(int WidthBlock, int HeightBlock) {
    for (int y=0; y<8; y++)
    {
        int p = (info.height-1-y-HeightBlock)*info.width+WidthBlock;
        for (int x=0; x<8; x++)
        {
            unsigned char B = info.B[p];
            unsigned char G = info.G[p];
            unsigned char R = info.R[p++];

            yData[y*8+x] = (char)(0.299f * R + 0.587f * G + 0.114f * B - 128);
            cbData[y*8+x] = (char)(-0.1687f * R - 0.3313f * G + 0.5f * B );
            crData[y*8+x] = (char)(0.5f * R - 0.4187f * G - 0.0813f * B);
        }
    }
}


//-------------------------------------------------------------------------------
void JpegEncoder::_write_jpeg_header(FILE* fp)
{
    //SOI
    _write_word_(0xFFD8, fp);		// marker = 0xFFD8

    //APPO
    _write_word_(0xFFE0,fp);		// marker = 0xFFE0
    _write_word_(16, fp);			// length = 16 for usual JPEG, no thumbnail
    _write_("JFIF", 5, fp);			// 'JFIF\0'
    _write_byte_(1, fp);			// version_hi
    _write_byte_(1, fp);			// version_low
    _write_byte_(0, fp);			// xyunits = 0 no units, normal density
    _write_word_(1, fp);			// xdensity
    _write_word_(1, fp);			// ydensity
    _write_byte_(0, fp);			// thumbWidth
    _write_byte_(0, fp);			// thumbHeight

    //DQT
    _write_word_(0xFFDB, fp);		//marker = 0xFFDB
    _write_word_(132, fp);			//size=132
    _write_byte_(0, fp);			//QTYinfo== 0:  bit 0..3: number of QT = 0 (table for Y)
    //				bit 4..7: precision of QT
    //				bit 8	: 0
    _write_(m_YTable, 64, fp);		//YTable
    _write_byte_(1, fp);			//QTCbinfo = 1 (quantization table for Cb,Cr)
    _write_(m_CbCrTable, 64, fp);	//CbCrTable

    //SOFO
    _write_word_(0xFFC0, fp);			//marker = 0xFFC0
    _write_word_(17, fp);				//length = 17 for a truecolor YCbCr JPG
    _write_byte_(8, fp);				//precision = 8: 8 bits/sample
    _write_word_(info.height&0xFFFF, fp);	//height
    _write_word_(info.width&0xFFFF, fp);	//width
    _write_byte_(3, fp);				//nrofcomponents = 3: We encode a truecolor JPG

    _write_byte_(1, fp);				//IdY = 1
    _write_byte_(0x11, fp);				//HVY sampling factors for Y (bit 0-3 vert., 4-7 hor.)(SubSamp 1x1)
    _write_byte_(0, fp);				//QTY  Quantization Table number for Y = 0

    _write_byte_(2, fp);				//IdCb = 2
    _write_byte_(0x11, fp);				//HVCb = 0x11(SubSamp 1x1)
    _write_byte_(1, fp);				//QTCb = 1

    _write_byte_(3, fp);				//IdCr = 3
    _write_byte_(0x11, fp);				//HVCr = 0x11 (SubSamp 1x1)
    _write_byte_(1, fp);				//QTCr Normally equal to QTCb = 1

    //DHT
    _write_word_(0xFFC4, fp);		//marker = 0xFFC4
    _write_word_(0x01A2, fp);		//length = 0x01A2
    _write_byte_(0, fp);			//HTYDCinfo bit 0..3	: number of HT (0..3), for Y =0
    //			bit 4		: type of HT, 0 = DC table,1 = AC table
    //			bit 5..7	: not used, must be 0
    _write_(Standard_DC_Luminance_NRCodes, sizeof(Standard_DC_Luminance_NRCodes), fp);	//DC_L_NRC
    _write_(Standard_DC_Luminance_Values, sizeof(Standard_DC_Luminance_Values), fp);		//DC_L_VALUE
    _write_byte_(0x10, fp);			//HTYACinfo
    _write_(Standard_AC_Luminance_NRCodes, sizeof(Standard_AC_Luminance_NRCodes), fp);
    _write_(Standard_AC_Luminance_Values, sizeof(Standard_AC_Luminance_Values), fp); //we'll use the standard Huffman tables
    _write_byte_(0x01, fp);			//HTCbDCinfo
    _write_(Standard_DC_Chrominance_NRCodes, sizeof(Standard_DC_Chrominance_NRCodes), fp);
    _write_(Standard_DC_Chrominance_Values, sizeof(Standard_DC_Chrominance_Values), fp);
    _write_byte_(0x11, fp);			//HTCbACinfo
    _write_(Standard_AC_Chrominance_NRCodes, sizeof(Standard_AC_Chrominance_NRCodes), fp);
    _write_(Standard_AC_Chrominance_Values, sizeof(Standard_AC_Chrominance_Values), fp);

    //SOS
    _write_word_(0xFFDA, fp);		//marker = 0xFFC4
    _write_word_(12, fp);			//length = 12
    _write_byte_(3, fp);			//nrofcomponents, Should be 3: truecolor JPG

    _write_byte_(1, fp);			//Idy=1
    _write_byte_(0, fp);			//HTY	bits 0..3: AC table (0..3)
    //		bits 4..7: DC table (0..3)
    _write_byte_(2, fp);			//IdCb
    _write_byte_(0x11, fp);			//HTCb

    _write_byte_(3, fp);			//IdCr
    _write_byte_(0x11, fp);			//HTCr

    _write_byte_(0, fp);			//Ss not interesting, they should be 0,63,0
    _write_byte_(0x3F, fp);			//Se
    _write_byte_(0, fp);			//Bf
}
