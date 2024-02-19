#include"RLCCompress.h"
#include<iostream>
using namespace std;

void RLCCompress::compress()
{
	FILE *fp = fopen((info.filename + ".RLC").c_str(), "wb");
	if (fp == NULL) {
		printf("Sorry, cannot find compression file!\n");
		exit(0);
	}
	fseek(fp, 0, SEEK_END);

	int now;
	int item;
	int recnum;

	unsigned char iitem, rrecnum;

	//cout << "TEST:::::in lossless before compress" << endl;
	//for (int i = 0; i < 20; i++) {
	//	cout << info.R[i] << " " << info.G[i] << " " << info.B[i] << endl;
	//}


	cout << "R:" << endl;
	for (int i = 0; i < info.height; i++) {
		now = 0;
		recnum = 1;
		item = info.R[i * info.width];
		while (1) {
			now++;
			if (now == info.width) {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				break;
			}

			if (info.R[i * info.width + now] == item) {
				recnum++;
			}
			else {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				item = info.R[i * info.width + now];
				recnum = 1;
			}
		}
	}
	cout << "G:" << endl;
	for (int i = 0; i < info.height; i++) {
		now = 0;
		recnum = 1;
		item = info.G[i * info.width];
		while (1) {
			now++;
			if (now == info.width) {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				break;
			}

			if (info.G[i * info.width + now] == item) {
				recnum++;
			}
			else {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				item = info.G[i * info.width + now];
				recnum = 1;
			}
		}
	}
	cout << "B:" << endl;
	for (int i = 0; i < info.height; i++) {
		now = 0;
		recnum = 1;
		item = info.B[i * info.width];
		while (1) {
			now++;
			if (now == info.width) {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				break;
			}

			if (info.B[i * info.width + now] == item) {
				recnum++;
			}
			else {
				iitem = item;
				rrecnum = recnum;

				fwrite(&iitem, 1, 1, fp);
				fwrite(&rrecnum, 1, 1, fp);
				item = info.B[i * info.width + now];
				recnum = 1;
			}
		}
	}
}

void RLCCompress::decompress()
{
	FILE *ofp = fopen((info.filename + ".RLC.bmp").c_str(), "wb");
	if (ofp == NULL) {
		printf("Sorry, cannot find output-original(*.RLC.bmp) file!\n");
		exit(0);
	}
	fseek(ofp, 54, SEEK_SET);			// 56 is the total BMP head size

	FILE *ifp = fopen((info.filename + ".RLC").c_str(), "r");
	if (ofp == NULL) {
		printf("Sorry, cannot find after-compression(*.RLC) file!\n");
		exit(0);
	}
	fseek(ifp, 54, SEEK_SET);			// 56 is the total BMP head size

	int color;							// the new color
	int nowcolor;						// the previous color
	int recnum;							// the new color recursion number
	int nowrecnum;						// the current recursion number
	
	unsigned char ccolor, rrecnum;

	int nowheight = 0;					// now process row
	int nowwidth = 0;					// now process column

	//int* R;
	//int* G;
	//int* B;
	//R = new int[info.height*info.width];
	//G = new int[info.height*info.width];
	//B = new int[info.height*info.width];
	//int step = 0;						// used to fill the RGB field

	////read R
	//while (1) {
	//	fread(&ccolor, 1, 1, ifp);
	//	fread(&rrecnum, 1, 1, ifp);

	//	color = (int)ccolor;
	//	recnum = (int)rrecnum;

	//	if (nowwidth == 0) {			// means the start of process
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//		nowwidth += recnum;
	//		continue;					// we take the first data as initial data
	//	}
	//									// otherwise, we have already read some data
	//	if (nowcolor == color) {		// if color is the same
	//		nowwidth += recnum;
	//	}
	//	else {							// otherwise color not same
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			R[i] = nowcolor;		// write previous color data
	//		}
	//		step += nowrecnum;
	//		nowwidth += recnum;
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//	}

	//	if (nowwidth == info.width) {	// if we process the whole line
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			R[i] = nowcolor;
	//		}

	//		step += nowrecnum;			// change the step
	//		nowwidth = 0;				// reset nowwidth
	//		nowheight++;

	//	}
	//	if (nowheight == info.height) {	// if we process one color field
	//		nowheight = 0;				// reset nowheight & nowwidth for next recursion
	//		nowwidth = 0;
	//		break;
	//	}
	//}

	////read G
	//while (1) {
	//	fread(&ccolor, 1, 1, ifp);
	//	fread(&rrecnum, 1, 1, ifp);

	//	color = (int)ccolor;
	//	recnum = (int)rrecnum;

	//	if (nowwidth == 0) {			// means the start of process
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//		nowwidth += recnum;
	//		continue;					// we take the first data as initial data
	//	}
	//	// otherwise, we have already read some data
	//	if (nowcolor == color) {		// if color is the same
	//		nowwidth += recnum;
	//	}
	//	else {							// otherwise color not same
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			G[i] = nowcolor;		// write previous color data
	//		}
	//		step += nowrecnum;
	//		nowwidth += recnum;
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//	}

	//	if (nowwidth == info.width) {	// if we process the whole line
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			G[i] = nowcolor;
	//		}

	//		step += nowrecnum;			// change the step
	//		nowwidth = 0;				// reset nowwidth
	//		nowheight++;

	//	}
	//	if (nowheight == info.height) {	// if we process one color field
	//		nowheight = 0;				// reset nowheight & nowwidth for next recursion
	//		nowwidth = 0;
	//		break;
	//	}
	//}

	////read B
	//while (1) {
	//	fread(&ccolor, 1, 1, ifp);
	//	fread(&rrecnum, 1, 1, ifp);

	//	color = (int)ccolor;
	//	recnum = (int)rrecnum;

	//	if (nowwidth == 0) {			// means the start of process
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//		nowwidth += recnum;
	//		continue;					// we take the first data as initial data
	//	}
	//	// otherwise, we have already read some data
	//	if (nowcolor == color) {		// if color is the same
	//		nowwidth += recnum;
	//	}
	//	else {							// otherwise color not same
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			B[i] = nowcolor;		// write previous color data
	//		}
	//		step += nowrecnum;
	//		nowwidth += recnum;
	//		nowcolor = color;
	//		nowrecnum = recnum;
	//	}

	//	if (nowwidth == info.width) {	// if we process the whole line
	//		for (int i = step; i < step + nowrecnum; i++) {
	//			B[i] = nowcolor;
	//		}

	//		step += nowrecnum;			// change the step
	//		nowwidth = 0;				// reset nowwidth
	//		nowheight++;

	//	}
	//	if (nowheight == info.height) {	// if we process one color field
	//		nowheight = 0;				// reset nowheight & nowwidth for next recursion
	//		nowwidth = 0;
	//		break;
	//	}
	//}

	//cout << "TEST:::::in lossless after compress" << endl;
	//for (int i = 0; i < 20; i++) {
	//	cout << R[i] << " " << G[i] << " " << B[i] << endl;
	//}

	int a = 0;
	unsigned char r, g, b;
	for (int i = 0; i < info.height; i++) {
		for (int j = 0; j < info.width; j++) {
			/*r = R[i*info.width + j];
			g = G[i*info.width + j];
			b = B[i*info.width + j];*/

			r = info.R[i*info.width + j];
			g = info.G[i*info.width + j];
			b = info.B[i*info.width + j];

			fwrite(&b, 1, 1, ofp);
			fwrite(&g, 1, 1, ofp);
			fwrite(&r, 1, 1, ofp);
		}
		if (info.offset != 0) fwrite(&a, info.offset, 1, ofp);
	}

}

