#include <iostream>
#include <vector>
#include <algorithm>

#include "StripPack.h"

int main()
{
    int width, n;
    int rect_width, rect_height;
    int height;
    std::vector<Rect> rect_list; // store all the textures
    std::cout << "Please input width of the bin." << std::endl;
    std::cin >> width; // read in width of bin
    std::cout << "Please input number of texture." << std::endl;
    std::cin >> n; // number of texture
    std::cout << "Please input textures with width first and height second" << std::endl;

    for (int i = 0; i < n; ++i) // read in texture information
    {
        std::cin >> rect_width >> rect_height;
        rect_list.push_back(Rect{rect_width, rect_height});
    }

    // output height taken by NFDH algorithm
    height = NFDH(width, rect_list);
    std::cout << "NFDH: " << height << std::endl;

    // output height taken by BFDH algorithm
    height = BFDH(width, rect_list);
    std::cout << "BFDH: " << height << std::endl;

    // output height taken by BL algorithm
    height = BL(width, rect_list);
    std::cout << "BL: " << height << std::endl;

    // output height taken by RF algorithm
    height = RF(width, rect_list);
    std::cout << "RF: " << height << std::endl;
}
