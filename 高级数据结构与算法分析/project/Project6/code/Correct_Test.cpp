#include <ctime>
#include <fstream>
#include <string>
#include <vector>
#include "StripPack.h"

#define CASE_NUM 4
#define PATH "CorrectnessCases/"
#define RESULT_PATH "Result/"

int main()
{
    std::ifstream fin;
    std::ofstream fout;
    std::ifstream fans;
    int width, n;
    int texture_width, texture_height, ans;
    std::vector<Rect> rect_list; // store textures
    long long FFDH_height, NFDH_height, BFDH_height, BL_height, RF_height; // Used for storaging height computed by different approximation algorithms
    int wrong_count = 0; // count error cases

    fout.open(RESULT_PATH + (std::string)"CorrectTestResult.txt", std::ios::out | std::ios::trunc);
    if (fout.is_open())
    {
        for (int i = 0; i < CASE_NUM; ++i)
        {
            rect_list.clear(); // For each case, reinitialize list
            fin.open(PATH + (std::string)"case" + std::to_string(i) + ".txt", std::ios::in); // input test cases
            if (fin.is_open())
            {
                fin >> width >> n;
                for (int j = 0; j < n; j++)
                {
                    fin >> texture_width >> texture_height;
                    rect_list.push_back(Rect{texture_width, texture_height});
                }
                fin.close();

                // use each algorithm to get the height
                FFDH_height = FFDH(width, rect_list);
                NFDH_height = NFDH(width, rect_list);
                BFDH_height = BFDH(width, rect_list);
                BL_height = BL(width, rect_list);
                RF_height = RF(width, rect_list);
            }

            // Compare the result of FFDH with manually computed standard result
            fans.open(PATH + (std::string) "case" + std::to_string(i) + "_FFDH_out" + ".txt", std::ios::in);
            if (fans.is_open())
            {
                fans >> ans;
                if (ans != FFDH_height)
                {
                    // Print Error Message
                    std::cout << "case" + std::to_string(i) + " of FFDH wrong. Answer should be " + std::to_string(ans) + ", but the result is " + std::to_string(FFDH_height) << std::endl;
                    wrong_count++;
                }
                fans.close();
            }

            // Compare the result of NFDH with manually computed standard result
            fans.open(PATH + (std::string) "case" + std::to_string(i) + "_NFDH_out" + ".txt", std::ios::in);
            if (fans.is_open())
            {
                fans >> ans;
                if (ans != NFDH_height)
                {
                    // Print Error Message
                    std::cout << "case" + std::to_string(i) + " of NFDH wrong. Answer should be " + std::to_string(ans) + ", but the result is " + std::to_string(NFDH_height) << std::endl;
                    wrong_count++;
                }
                fans.close();
            }

            // Compare the result of BFDH with manually computed standard result
            fans.open(PATH + (std::string) "case" + std::to_string(i) + "_BFDH_out" + ".txt", std::ios::in);
            if (fans.is_open())
            {
                fans >> ans;
                if (ans != BFDH_height)
                {  
                    // Print Error Message
                    std::cout << "case" + std::to_string(i) + " of BFDH wrong. Answer should be " + std::to_string(ans) + ", but the result is " + std::to_string(BFDH_height) << std::endl;
                    wrong_count++;
                }
                fans.close();
            }
            
            // Compare the result of BL with manually computed standard result
            fans.open(PATH + (std::string) "case" + std::to_string(i) + "_BL_out" + ".txt", std::ios::in);
            if (fans.is_open())
            {
                fans >> ans;
                if (ans != BL_height)
                {
                    // Print Error Message
                    std::cout << "case" + std::to_string(i) + " of BL wrong. Answer should be " + std::to_string(ans) + ", but the result is " + std::to_string(BL_height) << std::endl;
                    wrong_count++;
                }
                fans.close();
            }
            
            // Compare the result of RF with manually computed standard result
            fans.open(PATH + (std::string) "case" + std::to_string(i) + "_RF_out" + ".txt", std::ios::in);
            if (fans.is_open())
            {
                fans >> ans;
                if (ans != RF_height)
                {
                    // Print Error Message
                    std::cout << "case" + std::to_string(i) + " of RF wrong. Answer should be " + std::to_string(ans) + ", but the result is " + std::to_string(RF_height) << std::endl;
                    wrong_count++;
                }
                fans.close();
            }
        }
        // Print total count of error cases
        std::cout << "Total wrong cases: " << wrong_count << std::endl;
    }
}