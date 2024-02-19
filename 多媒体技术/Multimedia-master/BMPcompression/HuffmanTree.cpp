
#include "HuffmanTree.h"
using namespace std;

HuffmanNode::HuffmanNode(int weight, char ch)
{
    this->isleaf = true;
    this->weight = weight;
    this->ch = ch;
    this->left = nullptr;
    this->right = nullptr;
}

HuffmanNode::HuffmanNode(HuffmanNode* left, HuffmanNode* right)
{
    this->isleaf = false;
    this->weight = left->weight + right->weight;
    this->ch = 0;
    this->left = left;
    this->right = right;
}

HuffmanNode::~HuffmanNode()
{
    delete left;
    delete right;
}

bool HuffmanNode::isLeaf(){
    return isleaf;
}

int HuffmanNode::getWeight()
{
    return weight;
}

unsigned char HuffmanNode::getCh()
{
    return ch;
}

HuffmanNode* HuffmanNode::getLeft()
{
    return left;
}

HuffmanNode* HuffmanNode::getRight()
{
    return right;
}

void HuffmanNode::setWeight(int weight)
{
    this->weight = weight;
}

void HuffmanNode::setCh(unsigned char ch)
{
    this->ch = ch;
}

void HuffmanNode::setLeft(HuffmanNode* left)
{
    this->left = left;
}

void HuffmanNode::setRight(HuffmanNode* right)
{
    this->right = right;
}

HuffmanNode* merge(HuffmanNode* a, HuffmanNode* b)
{
    return new HuffmanNode(a, b);
}

class compareWeight {
public:
    bool operator()(HuffmanNode* a, HuffmanNode* b)
    {
        return a->getWeight() > b->getWeight();
    }
};

HuffmanNode* buildHuffmanTree(int n, int* weight, unsigned char* ch)
{
    std::cout << "  Building HuffmanTree..." << std::endl;
    priority_queue<HuffmanNode*, vector<HuffmanNode*>, compareWeight> pq;
    for (int i = 0; i < n; i++) {
        pq.push(new HuffmanNode(weight[i], ch[i]));
    }
    for (int i = 0; i < n - 1; i++) {
        HuffmanNode* a = pq.top();
        pq.pop();
        HuffmanNode* b = pq.top();
        pq.pop();
        pq.push(merge(a, b));
    }

    std::cout << "    Building finished!" << std::endl;

    return pq.top();
    
}

void printHuffmanTree(HuffmanNode* root)
{
    if (root->isLeaf()) {
        cout << root->getCh() << endl;
    }
    else {
        printHuffmanTree(root->getLeft());
        printHuffmanTree(root->getRight());
    }
}

void printHuffmanCode(HuffmanNode* root, string &code)
{
    if (root->isLeaf()) {
        cout << root->getCh() << " " << code << endl;
    }
    else {
        code.push_back('0');
        printHuffmanCode(root->getLeft(), code);
        code.pop_back();
        code.push_back('1');
        printHuffmanCode(root->getRight(), code);
        code.pop_back();
    }
}

void printLevelOrder(HuffmanNode* root)
{
    queue<HuffmanNode*> q,n;
    q.push(root);
    while (!q.empty()) {
        q.front()->isLeaf() ? cout << q.front()->getCh() : cout << "x";
        cout << " ";
        if (q.front()->getLeft() != nullptr) {
            n.push(q.front()->getLeft());
        }
        if (q.front()->getRight() != nullptr) {
            n.push(q.front()->getRight());
        }
        q.pop();
        if (q.empty()) {
            cout << endl;
            swap(q, n);
        }

    }
    cout << endl;
}

void record(HuffmanNode* root, unordered_map<unsigned char,string> &code, unordered_map<string, unsigned char> &anticode, string &s)
{
    if (root->isLeaf()) {
        code[root->getCh()] = s;
        anticode[s] = root->getCh();
    }
    else {
        s.push_back('0');
        record(root->getLeft(), code, anticode, s);
        s.pop_back();
        s.push_back('1');
        record(root->getRight(), code, anticode, s);
        s.pop_back();
    }
}

void outputCode(const char *filename, unordered_map<unsigned char,string> &code)
{
    ofstream fout(filename);
    for(unsigned int c=0; c<256; c++)
    {
        fout << (int)c << " " << code[c] << endl;
    }
    fout.close();
}
