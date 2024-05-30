#include "StripPack.h"

long long FFDH(int width, std::vector<Rect> rect_list){ // First-Fit Decreasing Height
	long long current_height = 0; // the whole height of the sum of the height each level
    int j;

    if (rect_list.empty()) return 0;
    
    std::sort(rect_list.begin(), rect_list.end(), HeightDescSort); // sort according to height in descending order
	std::vector <int> width_taken_list; // the already used width of each level
	for (int i = 0; i < rect_list.size(); i++) {
        if (rect_list[i].width > width){
            return -1;
        }

        for (j = 0; j < width_taken_list.size(); j++) {
			if (width_taken_list[j] + rect_list[i].width <= width) { // can  store the rectangular in this level which be pointed to by the pointer "point".
				width_taken_list[j] += rect_list[i].width; // renew the already used width of this level
				break;
			}
		}
		if (j == width_taken_list.size()) { // can't store the rectangular in all the level that has been existed
			current_height += rect_list[i].height; // renew the whole new Height and create a new level
			width_taken_list.push_back(rect_list[i].width);
		}
	}
    return current_height;
}

long long NFDH(int width, std::vector<Rect> rect_list) // Next-Fit Decreasing Height
{
    int current_width = 0;
    long long current_height = 0;
    int i = 0;

    if (rect_list.empty()) return 0;
    
    std::sort(rect_list.begin(), rect_list.end(), HeightDescSort); // sort according to height in descending order
    current_height += rect_list[0].height;
    
    while (i < rect_list.size())
    {
        if (rect_list[i].width > width) // can not be packed
        {
            return -1;
        }
        else if (current_width + rect_list[i].width <= width) // can still be packed in this level
        {
            current_width += rect_list[i].width;
        }
        else // can not be packed in this level, new a level
        {
            current_width = rect_list[i].width; // the width of this texture will be next level's current width
            current_height += rect_list[i].height; // add height to new a level
        }
        i++; // pack next texture
    }

    return current_height;
}

long long BFDH(int width, std::vector<Rect> rect_list) // Best-Fit Decreasing Height
{
    int min, max, max_index;
    long long current_height = 0;
    if (rect_list.empty()) return 0;

    std::sort(rect_list.begin(), rect_list.end(), HeightDescSort); // sort according to height in descending order
    
    std::vector<int> width_taken_list;
    for (int i = 0; i < rect_list.size(); ++i)
    {
        if (rect_list[i].width > width) // can not be packed
        {
            return -1;
        }
        else
        {
            // find the min and the max width left
            min = INF;
            max = -1;
            for (int j = 0; j < width_taken_list.size(); ++j)
            {
                int width_taken = width_taken_list[j] + rect_list[i].width;
                if (width_taken <= width && width_taken > max)
                {
                    max = width_taken;
                    max_index = j;
                }
                if (width_taken < min) min = width_taken;
            }
            if (min > width) // if even the min can not be placed in all the levels existing, new a level
            {
                width_taken_list.push_back(rect_list[i].width);
                current_height += rect_list[i].height; // update height as a new level is created
            }
            else // insert this texture into the level that will leave least width
            {
                width_taken_list[max_index] = max;
            }
        }
    }

    return current_height;
}

long long BL(int width, std::vector<Rect> rect_list) // Bottom-Left
{
    int bottom_y, top_y, left_x, right_x;
    std::vector<Point>::iterator j, k;
    if (rect_list.empty()) return 0;

    std::sort(rect_list.begin(), rect_list.end(), WidthDescSort);

    std::vector<Point> y_sorted_list; // in descending order of y ordinate
    std::vector<Point> x_sorted_list; // in descending order of x ordinate

    for (int i = 0; i < rect_list.size(); ++i)
    {
        if (rect_list[i].width > width)
        {
            return -1;
        }
        // Move the texture towards bottom from rightmost and upmost
        // Find the texture that will prevent this texture from moving lower
        for (j = y_sorted_list.begin(); j != y_sorted_list.end(); j += 2)
        {
            if (j[1].x > width - rect_list[i].width) // be blocked and cannot move down any more
            {
                break;
            }
        }
        if (j == y_sorted_list.end()) // can move to the bottom
        {
            bottom_y = 0;
            top_y = rect_list[i].height;
        }
        else // be blocked by some texture
        {
            bottom_y = (*j).y;
            top_y = (*j).y + rect_list[i].height;
        }

        // Move the texture to left
        for (k = x_sorted_list.begin(); k != x_sorted_list.end(); k += 2)
        {
            if (k[0].y < top_y && k[0].y > bottom_y || k[1].y < top_y && k[1].y > bottom_y || k[0].y <= bottom_y && k[1].y >= top_y) // be blocked and cannot move left any more
            {
                break;
            }
        }
        if (k == x_sorted_list.end()) // can move to the leftmost
        {
            left_x = 0;
            right_x = rect_list[i].width;
        }
        else // be blocked by some texture and cannot move to left any more
        {
            left_x = (*k).x;
            right_x = left_x + rect_list[i].width;
        }

        // Try to move down the texture again
        for (; j != y_sorted_list.end(); j += 2)
        {
            if (j[0].x > left_x && j[0].x < right_x || j[1].x > left_x && j[1].x < right_x || j[0].x <= left_x && j[1].x >= right_x) // be blocked by some texture
            {
                break;
            }
        }

        if (j == y_sorted_list.end()) // can be moved to the bottom
        {
            bottom_y = 0;
            top_y = rect_list[i].height;
        }
        else // be blocked by some texture
        {
            bottom_y = (*j).y;
            top_y = bottom_y + rect_list[i].height;
        }

        // Update y_sorted_list
        for (j = y_sorted_list.begin(); j != y_sorted_list.end(); j += 2)
        {
            if (top_y >= (*j).y) break;
        }
        y_sorted_list.insert(y_sorted_list.insert(j, Point{ right_x, top_y }), Point{ left_x, top_y });

        // Update x_sorted_list
        for (k = x_sorted_list.begin(); k != x_sorted_list.end(); k += 2)
        {
            if (right_x >= (*k).x) break;
        }
        x_sorted_list.insert(x_sorted_list.insert(k, Point{ right_x, top_y }), Point{ right_x, bottom_y });
    }

    return y_sorted_list[0].y;
}

long long RF(int width, std::vector<Rect> rect_list)
{
    // Stack texture wider than half at the bottom.
    // Repeat building first level and second level until all textures are packed
    // First level from left to right, second level from right to left. But for second level, each texture are directly dropped,
    // until width taken is no less than half. While dropping, record the heighest.
    // First level is then established on this heighest.
    int current_height = 0;
    std::vector<Rect>::iterator i;
    std::vector<Rect> rest_rect_list;
    std::vector<Point> first_level_list;
    int current_width, j, current_x;
    // 1. Stack textures with width more than half of the strip width
    for (i = rect_list.begin(); i != rect_list.end(); ++i)
    {
        if (i->width > width)
            return -1;
        else if (i->width > (double)width / 2)
        {
            current_height += i->height;
        }
        else
        {
            rest_rect_list.push_back(*i); // extract textures with width no greater than half
        }
    }
    // 2. Sort the rest texture in descending order of width
    std::sort(rest_rect_list.begin(), rest_rect_list.end(), HeightDescSort);

    i = rest_rect_list.begin();
    while (i != rest_rect_list.end())
    {
        current_width = 0;
        first_level_list.clear();
        // 3. First level from left to right
        // only the ordinates of rightmost and topmost points are necessary to store
        while (i != rest_rect_list.end() && current_width + i->width <= width) // texture can still be put in the first level
        {
            current_width += i->width;
            if (first_level_list.empty())
            {
                first_level_list.push_back(Point{i->width, current_height + i->height});
            }
            else
            {
                first_level_list.push_back(Point{first_level_list[first_level_list.size() - 1].x + i->width, current_height + i->height});
            }
            i++;
        }
        if (!first_level_list.empty())
        {
            current_height = first_level_list[0].y;
        }
        // 4. Second level from right to left
        // max_y should be recorded
        current_width = 0;
        while (i != rest_rect_list.end() && current_width < (double)width / 2)
        {
            current_x = width - current_width - i->width;
            // From right to left
            for (j = first_level_list.size() - 1; j >= 0; j--)
            {
                if (first_level_list[j].x <= current_x) // No possibility to be blocked by more left
                {
                    break;
                }
                if (j > 0)
                {
                    if ((first_level_list[j].x > current_x && first_level_list[j - 1].x <= current_x + i->width) ||
                        (first_level_list[j].x >= current_x + i->width && first_level_list[j - 1].x <= current_x)) // be blocked
                    {
                        current_height = current_height >= first_level_list[j].y + i->height ? current_height : first_level_list[j].y + i->height;
                    }
                }
                else
                {
                    if (first_level_list[j].x > current_x) // be blocked by the left most texture in the first level
                    {
                        current_height = current_height >= first_level_list[j].y + i->height ? current_height : first_level_list[j].y + i->height;
                    }
                }
            }
            current_width += i->width; // update width taken
            i++;
        }
    }
    return current_height;
}


bool HeightDescSort(Rect a, Rect b)
{
    return (a.height > b.height) || (a.height == b.height && a.width > b.width);
}

bool WidthDescSort(Rect a, Rect b)
{
    return (a.width > b.width) || (a.width == b.width && a.height > b.height);
}
