#ifndef _RLCCOMPRESS
#define _RLCCOMPRESS

#include"Compress.h"
using namespace std;

class RLCCompress :public Compress{
public:
	// ctor
	RLCCompress(BMPInfo info):Compress(info){}

public:
	virtual void compress();
	virtual void decompress();
};

#endif // !_RLCCOMPRESS

