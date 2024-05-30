#include <iostream>
#include <vector>
#include <algorithm>

#define INF 1000000
struct Rect
{
    int width;
    int height;
};

struct Point
{
    int x;
    long long y;
};

long long FFDH(int width, std::vector<Rect> rect_list); 
long long NFDH(int width, std::vector<Rect> rect_list);
long long BFDH(int width, std::vector<Rect> rect_list);
long long BL(int width, std::vector<Rect> rect_list);
long long RF(int width, std::vector<Rect> rect_list);

bool HeightDescSort(Rect a, Rect b);
bool WidthDescSort(Rect a, Rect b);
