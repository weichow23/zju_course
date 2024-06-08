#include <fstream>
#include <iomanip>
#include <string>
#include <random>

using namespace std;

int sizeN[] = {80, 160, 320, 640, 1280, 2560, 5120, 10240, 20480};

int main(){
    int fileNum = sizeof(sizeN) / sizeof(sizeN[0]);

    for(int T = 0; T < fileNum; ++T){
        ofstream fout("./data/" + to_string(T + 1) + ".in");
        int n = sizeN[T];
        fout << n << endl;
        
        random_device rd;
        mt19937 e(rd());
        uniform_int_distribution<int> getInt(1, n);
        uniform_int_distribution<int> getOp(1, 3);

        for(int i = 1; i <= n; ++i){
            int operate = getOp(e); // 1: insert, 2: find, 3: delete
            int operand = getInt(e);
            if(i < n / 10) operate = 1;
            fout << operate << ' ' << operand << endl;
        }
        fout.close();
    }
    return 0;
}