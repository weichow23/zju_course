#include <iostream>
#include <fstream>
#include <ctime>
#include <cmath>
#include <string>
#include <cstdlib>
#include <iomanip>

using namespace std;

template <class T>
struct SkipListNode {
    T value;
    SkipListNode<T> *next, *down;

    SkipListNode(T value) : value(value), next(nullptr), down(nullptr) {}

    bool operator<(const SkipListNode<T>& node) const {
        return value < node.value;
    }
    bool operator<=(const SkipListNode<T>& node) const {
        return value <= node.value;
    }
    bool operator==(const SkipListNode<T>& node) const {
        return value == node.value;
    }
};

template <class T>
class SkipList {
    private:
        SkipListNode<T> *head;
        int maxLevel, currentLevel;

        int generateRandomLevel() {
            int level = 0;
            while (rand() % 2 && level < maxLevel) {
                ++level;
            }
            return level;
        }

        void addLevel() {
            SkipListNode<T> *newNode = new SkipListNode<T>(T());
            newNode->down = head;
            head = newNode;
            ++currentLevel;
        }

    public:
        SkipList(int maxLevel = 5) : maxLevel(maxLevel), currentLevel(-1), head(nullptr) {}

        ~SkipList() {
            while (head) {
                SkipListNode<T> *current = head;
                head = head->down;
                while (current) {
                    SkipListNode<T> *temp = current;
                    current = current->next;
                    delete temp;
                }
            }
        }

        void insertNode(T value) {
            int level = generateRandomLevel();
            while (level > currentLevel) addLevel();

            SkipListNode<T> *current = head;
            SkipListNode<T> *lastInserted = nullptr;
            for (int i = currentLevel; i >= 0; --i) {
                while (current->next && current->next->value < value) {
                    current = current->next;
                }
                if (i <= level) {
                    SkipListNode<T> *newNode = new SkipListNode<T>(value);
                    newNode->next = current->next;
                    current->next = newNode;
                    if (lastInserted) {
                        lastInserted->down = newNode;
                    }
                    lastInserted = newNode;
                }
                current = current->down;
            }
        }

        SkipListNode<T>* findNode(T value) {
            if (!head) return nullptr;
            SkipListNode<T> *current = head;
            while (current) {
                while (current->next && current->next->value <= value) {
                    current = current->next;
                }
                if (current->value == value) return current;
                current = current->down;
            }
            return nullptr;
        }

        bool deleteNode(T value) {
            SkipListNode<T> *current = head;
            bool found = false;
            while (current) {
                while (current->next && current->next->value < value) {
                    current = current->next;
                }
                if (current->next && current->next->value == value) {
                    SkipListNode<T> *temp = current->next;
                    current->next = temp->next;
                    delete temp;
                    found = true;
                }
                current = current->down;
            }
            return found;
        }
};

void testSkipList() {
    SkipList<int> skipList(10);

    // test insert
    skipList.insertNode(3);
    skipList.insertNode(9);
    skipList.insertNode(10);
    skipList.insertNode(19);
    skipList.insertNode(7);

    // test find
    cout << (skipList.findNode(19) ? skipList.findNode(19)->value : -1) << endl;
    cout << (skipList.findNode(9) ? skipList.findNode(9)->value : -1) << endl;
    cout << (skipList.findNode(5) == nullptr) << endl;
    cout << (skipList.findNode(9) == nullptr) << endl;

    // test delete
    cout << skipList.deleteNode(9) << endl;
    cout << (skipList.findNode(9) == nullptr) << endl;
    cout << skipList.deleteNode(8) << endl;
}

int TestTime(const string &fileName) {
    ifstream fin(fileName);
    if (!fin.is_open()) {
        cerr << "Failed to open file: " << fileName << endl;
        return -1;
    }

    int n;
    fin >> n;
    srand(static_cast<unsigned>(time(nullptr)));
    SkipList<int> skipList(max(static_cast<int>(log2(n) * 2), 6));

    for (int i = 0; i < n; ++i) {
        int operate, operand;
        fin >> operate >> operand;
        switch (operate) {
            case 1:
                skipList.insertNode(operand);
                break;
            case 2:
                skipList.findNode(operand);
                break;
            case 3:
                skipList.deleteNode(operand);
                break;
            default:
                cerr << "Invalid operation code: " << operate << endl;
                break;
        }
    }

    fin.close();
    return n;
}

int main() {
    const int fileNum = 9; // test file number
    for (int T = 1; T <= fileNum; ++T) {
        string fileName = "./data/" + to_string(T) + ".in";
        int loop = 10;  // each run 10 times and get average time
        int num = -1;

        clock_t start = clock();
        for (int i = 0; i < loop; ++i) {
            num = TestTime(fileName);
        }
        clock_t end = clock();
        
        double elapsed_time = static_cast<double>(end - start) / CLOCKS_PER_SEC;
        cout << "Input Num: " << setw(6) << setfill(' ') << num << "   Average Time: " << fixed << setprecision(1) << (elapsed_time / loop * 1000) << " ms" << endl;
    }

    return 0;
}