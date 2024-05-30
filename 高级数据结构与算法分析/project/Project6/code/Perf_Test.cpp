#include <ctime>
#include <fstream>
#include <string>
#include <vector>
#include "StripPack.h"

#define CASE_NUM 1000
#define PATH "PerformanceCases/"
#define RESULT_PATH "Result/"
#define ALGORITHM_NUM 5
int main()
{
    std::ifstream fin;
    std::ofstream fout;
    clock_t start, end;
    int width, n, count;
    int texture_width, texture_height;
    std::vector<Rect> rect_list;
    int height;
    std::string file;
    for (int k = 0; k < ALGORITHM_NUM; ++k)
    {
        // Open relevant file to record result
        if (k == 0)
        {
            file = "FFDHPerform.txt";
            std::cout << "Testing FFDH..." << std::endl; // Print progress prompt
        }
        else if (k == 1)
        {
            file = "NFDHPerform.txt";
            std::cout << "Testing NFDH..." << std::endl; // Print progress prompt
        }
        else if (k == 2)
        {
            file = "BFDHPerform.txt";
            std::cout << "Testing BFDH..." << std::endl; // Print progress prompt
        }
        else if (k == 3)
        {
            file = "BLPerform.txt";
            std::cout << "Testing BL..." << std::endl; // Print progress prompt
        }
        else if (k == 4)
        {
            file = "RFPerform.txt";
            std::cout << "Testing RF..." << std::endl; // Print progress prompt
        }

        fout.open(RESULT_PATH + file, std::ios::out | std::ios::trunc);
        if (fout.is_open())
        {
            for (int i = 0; i < CASE_NUM; ++i)
            {
                rect_list.clear(); // initialize vector
                count = 0; // initialize count to zero, used for get average when time is too small

                end = start = clock(); // initialize time
                while (end - start < 10) // If tick number is smaller than 10, repeat and get average to reduce time error
                {
                    count++;

                    fin.open(PATH + (std::string)"case" + std::to_string(i) + ".txt", std::ios::in); // open input file
                    if (fin.is_open())
                    {
                        fin >> width >> n; // read input width and n
                        for (int j = 0; j < n; j++)
                        {
                            fin >> texture_width >> texture_height; // read texture information
                            rect_list.push_back(Rect{texture_width, texture_height}); // construct texture
                        }
                        fin.close();

                        // Call relevant approximation function
                        if (k == 0) height = FFDH(width, rect_list);
                        else if (k == 1) height = NFDH(width, rect_list);
                        else if (k == 2) height = BFDH(width, rect_list);
                        else if (k == 3) height = BL(width, rect_list);
                        else if (k == 4) height = RF(width, rect_list);

                        rect_list.clear();
                        end = clock();
                    }
                }
                fout << width << " " << n << " " << (double)(end - start) / CLOCKS_PER_SEC/ count << " " << height << std::endl; // calculate average time taken and record it in the file
            }
            fout.close();
        }
    }
    std::cout << "Done! Results in Result/" << std::endl;
}