#pragma warning(disable:4996)

#include"huffmanTree.h"

HuffmanTNode* initial(int *size, string huffmanTreeFile, string SetFile)
{
	int setsize = 0;
	int treesize;
	char *set;					//array with changeable length
	int *chweight;				//array with changeable length
	int min1,min2;				//the index with min weight
	int i;						//counter
	HuffmanTNode *p;
	HuffmanTNode *tree;			//array with changeable length
	ifstream inf;
	inf.open(SetFile);

	if (!inf)
	{
		cout << "ERROR! opening SetFile!" << endl;
		return nullptr;
	}
	//read setsize from SetFile
	inf >> setsize;
	*size = setsize;
	treesize = 2 * setsize - 1;
	tree = (HuffmanTNode *)malloc((treesize + 1)
		* sizeof(HuffmanTNode));
	if (setsize > 0)
	{
		if (tree == NULL)
		{
			cout << "No memory available!\n" << endl;
			return nullptr;
		}
		if ((set = (char *)malloc(setsize * sizeof(char))) == NULL)
		{
			cout << "No memory available!\n" << endl;
			return nullptr;
		}
		if ((chweight = (int *)malloc(setsize * sizeof(int))) == NULL)
		{
			cout << "No memory available!\n" << endl;
			return nullptr;
		}
		for (i = 0; i < setsize; i++)
		{
			inf.get(set[i]);
			//cout << "test::" << set[i] << endl;;
		}

		for (i = 0; i < setsize; i++) {
			inf >> chweight[i];
			//cout << "test::" << chweight[i] << endl;;
		}	

		//initialize tree's primary character node
		for (p = tree + 1, i = 1; i <= setsize; ++i, ++p)
		{
			p->weight = chweight[i - 1];
			p->value = set[i - 1];
			p->parent = 0;
			p->lchild = 0;
			p->rchild = 0;
			p->size = 1;  //primary size is 1
		}
		//initialize tree's generated node
		for (; i <= treesize; ++i, ++p)
		{
			p->weight = 0;    //empty
			p->value = ' ';   //space
			p->parent = 0;
			p->lchild = 0;
			p->rchild = 0;
			p->size = 1;
		}

		for (i = setsize + 1; i <= treesize; i++)
		{
			//select the min and secondMin node from tree
			find(tree, i - 1, &min1, &min2);
			//generate new tree and update some information
			tree[min1].parent = i;
			tree[min2].parent = i;
			tree[i].size = tree[min1].size + tree[min2].size + 1;
			tree[i].lchild = min1;
			tree[i].rchild = min2;
			tree[i].weight = tree[min1].weight + tree[min2].weight;
		}

		ofstream outf;
		outf.open(huffmanTreeFile);
		if (!outf)
		{
			cout << "ERROR! opening huffmanTreeFile!" << endl;
			return nullptr;
		}
		//print tree's size for using of reading huffmanTreeFile
		outf << treesize << endl;
		//print all node's information
		for (i = 1; i <= treesize; i++)
			outf << i << "\t" << tree[i].weight<<"\t"<< tree[i].value << "\t" << tree[i].parent << "\t" << tree[i].lchild << "\t" << tree[i].rchild << "\t" << tree[i].size << "\n";
	}
	return tree;
}

void find(HuffmanTNode *tree, int sum, int *minid, int*mminid)
{
	int i, j;   //counter

	//find first item whose parent is 0
	for (j = 1; j <= sum && tree[j].parent != 0; j++)
		;
	*minid = i = j;
	//travel the part and update indexs
	for (i++; i <= sum; i++)
		//parent must be 0
		if (tree[i].parent == 0)
		{
			//compare rules: weight > size
			if (tree[i].weight < tree[*minid].weight)
			{
				*mminid = *minid;
				*minid = i;
			}
			//if weight equals, then compare their sizes
			else if (tree[i].weight == tree[*minid].weight)
			{
				if (tree[i].size < tree[*minid].size)
				{
					*mminid = *minid;
					*minid = i;
				}
				//update *mminid
				else
					*mminid = i;
			}
			else {}
		}

	//if *minid not changed, then *mminid is empty,
	//so travel from (j+1) and find the index.
	if (j == *minid)
	{
		//initialize its value with endIndex because endIndex's parent is 0 and endIndex isn't *minid
		*mminid = sum;
		//skip the *minid and travel
		for (j++; j < sum; j++)
		{
			if (tree[j].parent == 0)
			{
				//same compare rules.
				if (tree[j].weight < tree[*mminid].weight)
					*mminid = j;
				else if (tree[j].weight == tree[*mminid].weight)
				{
					if (tree[j].size < tree[*mminid].size)
						*mminid = j;
				}
				else
					;
			}
		}
	}
}

bool encode(HuffmanTNode *tree, int size, string fileRes, string fileDes)
{
	//ifstream inf;		//file stream for input
	FILE* inf;
	ofstream outf;		//file stream for output
	char c;				//character has read
	char temp[1000];	//temp string to save current character's huffman code
	int start;			//current character's huffman code's start position in string
	int parent;
	int child;
	int index;			//current character's index in tree

	if (tree == NULL)
	{
		cout << "tree is NULL!" << endl;
		getch();
		return false;
	}
	inf = fopen(fileRes.c_str(),"rb");
	if (inf==NULL)
	{
		cout << "Error! opening encodeFileRes!" << endl;
		return false;
	}
	outf.open(fileDes);
	if (!outf)
	{
		cout << "Error! caused by opening encodeFileRes!" << endl;
		return false;
	}
	//when error occurs or file is over, loop exits
	while (!feof(inf))
	{
		int i;
		fread(&c, 1, 1, inf);
		//cout << "test::c " << c << endl;
		//find current character's index

		for (i = 1; i <= size; i++)
			if (tree[i].value == c)
				break;
		//if the character is not in set
		if (i > size && !feof(inf))
		{
			cout << "Error! Invalid character!" << c << endl;
			return false;
		}
		index = i;
		start = size - 1;
		for (child = index, parent = tree[index].parent;
			parent != 0;
			child = parent, parent = tree[parent].parent)
		{
			if (tree[parent].lchild == child)
				temp[--start] = '0';
			else
				temp[--start] = '1';
		}
		for (int i = start; i < size - 1;i++) {
			outf << temp[i];
		}
	}
	return true;
}

bool decode(HuffmanTNode *tree, int size, string fileRes, string fileDes)
{
	FILE *fpIn;
	FILE *fpOut;
	char c;
	int cursor = size;

	if (tree == NULL)
	{
		cout << "huffmantree is NULL!" << endl;
		return false;
	}

	if ((fpIn = fopen(fileRes.c_str(), "rb")) == NULL)
	{
		cout << "Error! opening compression file!" << endl;
		return false;
	}
	if ((fpOut = fopen(fileDes.c_str(), "wb")) == NULL)
	{
		cout << "Error! opening decompression file!" << endl;
		return false;
	}
	while (!feof(fpIn) && !ferror(fpIn) && !ferror(fpOut))
	{
		c = fgetc(fpIn);
		//if cursor goes to leaf
		if (tree[cursor].lchild == 0 && tree[cursor].rchild == 0)
		{
			//print the value and move cursor to root
			fputc(tree[cursor].value, fpOut);
			cursor = size;

		}
		if (c == '0')
			cursor = tree[cursor].lchild;
		else if (c == '1')
			cursor = tree[cursor].rchild;
		else {}
	}

	return true;
}