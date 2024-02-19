#ifndef LOSSLESSCOMPRESS_H
#define LOSSLESSCOMPRESS_H

#include <iostream>
#include <fstream>
#include <unordered_map>
#include "ReadBMP.h"
#include "HuffmanTree.h"

void encode(const char *filename, BMPFILE *bmp, unordered_map<string, unsigned char> &anticode);
BMPFILE decode(const char *filename, unordered_map<string, unsigned char> &anticode);

#endif