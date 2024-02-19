#pragma warning(disable:4996)

#ifndef _HUFFMANTREE
#define _HUFFMANTREE

#include<iostream>
#include<stdlib.h>
#include<conio.h>
#include<string>
#include<fstream>
using namespace std;

#define HUFFMAN_TREE_H
#define MAX_FILE_NAME_LEN 20    //Max length of file's name in arguments of main function.

//struct to describe huffmanTreeNode
typedef struct
{
	int weight;
	char value;
	unsigned int parent;
	unsigned int lchild;
	unsigned int rchild;
	unsigned int size;    //all size of this node(include itself and its child)
} HuffmanTNode;

HuffmanTNode* initial(int *size, string huffmanTreeFile, string SetFile);
void find(HuffmanTNode *huffmanArray, int sum, int *minid, int* mminid);
bool encode(HuffmanTNode *huffmanArray, int size, string fileRes, string ileDes);
bool decode(HuffmanTNode *huffmanArray, int size, string fileRes, string fileDes);

#endif // !_HUFFMANTREE