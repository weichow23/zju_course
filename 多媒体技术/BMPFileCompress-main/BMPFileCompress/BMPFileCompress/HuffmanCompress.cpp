#include"HuffmanCompress.h"
#include<iostream>
#include<stdlib.h>
#include<stdio.h>
#include<vector>
#include<fstream>
using namespace std;

void HuffmanCompress::compress()
{
	unsigned char cch;
	char ch;
	vector<unsigned char> table;
	vector<int> weight;
	vector<unsigned char>::iterator i;
	vector<int>::iterator j;

	bool flag = false;
	ifstream inf;
	inf.open(info.filename);

	while (!inf.eof()) {
		inf.get(ch);
		cch = (unsigned char)ch;
		flag = false;
		
		for (i = table.begin(), j = weight.begin(); i !=table.end(); i++,j++) {
			if (*i == ch) {
				flag = true;
				(*j)=(*j)+1;
				break;
			}
		}
		if (!flag) {
			table.emplace_back(ch);
			weight.emplace_back(1);
		}
	}
	
	ofstream outputchtable;
	outputchtable.open("HuffmanTable.txt");
	outputchtable << table.size();
	
	
	for (i = table.begin(); i !=table.end(); i++) {
		outputchtable << *i;
	}
	outputchtable << endl;
	for (j = weight.begin(); j != weight.end(); j++) {
		outputchtable << *j << " ";
		//cout << "test::*j  " << *j << endl;
	}
	outputchtable << endl;

	HuffmanTree = initial(&chSetSize, "HuffmanTree.txt", "HuffmanTable.txt");
	encode(HuffmanTree, chSetSize, info.filename, "HuffmanCompression.HUF");
}

void HuffmanCompress::decompress()
{
	decode(HuffmanTree, 2 * chSetSize - 1, "HuffmanCompression.HUF", "HuffmanDecompression.bmp");
}