#pragma warning(disable:4996)

#ifndef _COMPRESS
#define _COMPRESS

#include"ReadBMPFile.h"

class Compress {
protected:
	BMPInfo info;

public:
	Compress() {}
	Compress(BMPInfo info) :info(info) {}

public:
	virtual void compress() {}
	virtual void decompress() {}
};

#endif // !_COMPRESS
