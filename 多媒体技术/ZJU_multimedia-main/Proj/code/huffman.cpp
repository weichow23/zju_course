//
// Created by Yile Liu on 2023/4/15.
//

#include <iostream>
#include <queue>
#include <unordered_map>
#include <vector>

struct HuffmanNode {
    int val;
    int freq;
    HuffmanNode *left;
    HuffmanNode *right;

    HuffmanNode(int v, int f) : val(v), freq(f), left(nullptr), right(nullptr) {}

    HuffmanNode(int v, int f, HuffmanNode *l, HuffmanNode *r) : val(v), freq(f), left(l), right(r) {}
};

struct CompareNodes {
    bool operator()(HuffmanNode *a, HuffmanNode *b) {
        return a->freq > b->freq;
    }
};

void buildFrequencyMap(const vector<int> &vec1, const vector<int> &vec2, std::unordered_map<int, int> &freqMap) {
    for (const int &i: vec1) {
        freqMap[i]++;
    }
    for (const int &i: vec2) {
        freqMap[i]++;
    }
}

HuffmanNode *buildHuffmanTree(const std::unordered_map<int, int> &freqMap) {
    std::priority_queue<HuffmanNode *, std::vector<HuffmanNode *>, CompareNodes> pq;
    for (const auto &p: freqMap) {
        pq.push(new HuffmanNode(p.first, p.second));
    }

    while (pq.size() > 1) {
        HuffmanNode *left = pq.top();
        pq.pop();
        HuffmanNode *right = pq.top();
        pq.pop();
        HuffmanNode *parent = new HuffmanNode(-1, left->freq + right->freq, left, right);
        pq.push(parent);
    }

    return pq.top();
}

void buildCodeTable(HuffmanNode *root, std::unordered_map<int, std::string> &codeTable, std::string code = "") {
    if (root == nullptr) {
        return;
    }

    if (root->left == nullptr && root->right == nullptr) {
        codeTable[root->val] = code;
        return;
    }

    buildCodeTable(root->left, codeTable, code + "0");
    buildCodeTable(root->right, codeTable, code + "1");
}

std::string encode(const int *arr, int size, const std::unordered_map<int, std::string> &codeTable) {
    std::string encoded;
    for (int i = 0; i < size; i++) {
        encoded += codeTable.at(arr[i]);
    }
    return encoded;
}

void writeCodeTable(const std::unordered_map<int, std::string> &code_table, FILE *fp) {
    fprintf(fp, "%lu ", code_table.size());

    for (const auto &p: code_table) {
        fprintf(fp, "%d %s ", p.first, p.second.c_str());
    }
}

size_t writeBitStream(const vector<int> &vec, const std::unordered_map<int, std::string> &codeTable, FILE *fp) {
    // 根据CodeTable生成01字符串
    vector<char> buff;
    for (auto data: vec) {
        const char *temp = codeTable.at(data).c_str();
        while (*temp != '\0') {
            buff.emplace_back(*temp);
            temp++;
        }
    }

    // 将01字符串转化到二进制流
    unsigned char bit_buff = 0;
    int cnt = 0;
    for (char c: buff) {
        bit_buff <<= 1;
        bit_buff |= (c == '1' ? 1 : 0);
        cnt++;
        if (cnt == 8) {
            fprintf(fp, "%c", bit_buff);
            cnt = 0;
        }
    }

    // 结尾补0到整字节长度
    if (cnt != 0) {
        for (; cnt != 8; cnt++) {
            bit_buff <<= 1;
        }
        fprintf(fp, "%c", bit_buff);
    }

    return buff.size();
}

void
writeHuffmanCode(vector<int> &vec1, vector<int> &vec2, const unordered_map<int, std::string> &code_table, FILE *fp) {
    // 1. 生成各自的二进制串，放在临时文件中
    FILE *temp_file1 = tmpfile();
    FILE *temp_file2 = tmpfile();
    size_t size1 = writeBitStream(vec1, code_table, temp_file1);
    size_t size2 = writeBitStream(vec2, code_table, temp_file2);

    // 2. 先将二进制串的长度写进文件
    fprintf(fp, "%lu %lu ", size1, size2);

    // 3. 写MagicNumber作为分隔
    fprintf(fp, "%c%c", 0x27, 0x08);

    // 4. 再从临时文件拷贝二进制串到目标文件
    rewind(temp_file1);
    rewind(temp_file2);

    unsigned char c;
    int cnt = 0;
    while (cnt++ < ceil(size1 / 8.0)) {
        c = std::fgetc(temp_file1);
        fputc(c, fp);
    }
    cnt = 0;
    while (cnt++ < ceil(size2 / 8.0)) {
        c = std::fgetc(temp_file2);
        fputc(c, fp);
    }

    fclose(temp_file1);
    fclose(temp_file2);
}

void huffmanEncode(vector<int> &vec1, vector<int> &vec2, FILE *fp) {
    // 统计数据的出现频率
    std::unordered_map<int, int> freqMap;
    buildFrequencyMap(vec1, vec2, freqMap);

    // 建Huffman树
    HuffmanNode *root = buildHuffmanTree(freqMap);

    // 根据树生成编码表
    std::unordered_map<int, std::string> code_table;
    buildCodeTable(root, code_table);

    // 写文件
    // 1. 写码表
    writeCodeTable(code_table, fp);
    // 2. 将数据根据CodeTable生成二进制流并写入
    writeHuffmanCode(vec1, vec2, code_table, fp);
}

HuffmanNode *buildHuffmanTree(const std::unordered_map<int, std::string> &code_table) {
    HuffmanNode *root = new HuffmanNode(-1, -1);
    for (auto &p: code_table) {
        HuffmanNode *curr_node = root;
        for (char c: p.second) {
            if (c == '0') {
                if (curr_node->left == nullptr) {
                    curr_node->left = new HuffmanNode(-1, -1);
                }
                curr_node = curr_node->left;
            } else {
                if (curr_node->right == nullptr) {
                    curr_node->right = new HuffmanNode(-1, -1);
                }
                curr_node = curr_node->right;
            }
        }
        curr_node->val = p.first;
    }
    return root;
}

void decodeBitStream(HuffmanNode *root, FILE *fp, vector<int> &vec1, vector<int> &vec2) {
    size_t sizes[2];
    fscanf(fp, "%lu %lu ", sizes, sizes + 1);

    // 校验魔数
    char magic1 = fgetc(fp);
    char magic2 = fgetc(fp);
    assert(magic1 == 0x27 && magic2 == 0x08);

    for (int i = 0; i < 2; i++) {
        vector<int> &target = i == 0 ? vec1 : vec2;
        unsigned char temp;
        HuffmanNode *pNode = root;
        for (int cnt = 0; cnt < sizes[i]; cnt++) {
            if (cnt % 8 == 0) {
                temp = fgetc(fp);
            }

            if (temp & 0b10000000) {
                pNode = pNode->right;
            } else {
                pNode = pNode->left;
            }
            temp <<= 1;

            if (!pNode->left && !pNode->right) {
                target.emplace_back(pNode->val);
                pNode = root;
            }
        }
    }
}

void readCodeTable(std::unordered_map<int, std::string> &code_table, FILE *fp) {
    unsigned long code_table_size;
    fscanf(fp, "%lu ", &code_table_size);

    int data;
    char buff[code_table_size];

    for (int i = 0; i < code_table_size; i++) {
        fscanf(fp, "%d %s ", &data, buff);
        code_table[data] = buff;
    }
}

void huffmanDecode(FILE *fp, vector<int> &vec1, vector<int> &vec2) {
    // 读编码表
    unordered_map<int, std::string> code_table;
    readCodeTable(code_table, fp);

    // 还原Huffman树结构
    HuffmanNode *root = buildHuffmanTree(code_table);

    // 根据Huffman树进行解码
    decodeBitStream(root, fp, vec1, vec2);
}


