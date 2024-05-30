#include <iostream>
#include <fstream>
#include <string>
#include <ctime>

#define MAX_HEIGHT 100
#define MAX_WIDTH 10
#define PATH "PerformanceCases/"
int main()
{
	std::ofstream fout;
	srand((unsigned)time(NULL)); // set random seed
	int width, n;
	int texture_width;
	int texture_height;
	int i = 0;
	for (width = 10; width <= 100; width += 10)
	{
		for (n = 10; n <= 10000; n += 100)
		{
			fout.open(PATH +  (std::string)"case" + std::to_string(i++) + ".txt", std::ios::trunc | std::ios::out);
			fout << width << std::endl;
			fout << n << std::endl;

			if (fout.is_open())
			{
				for (int j = 0; j < n; ++j)
				{
					texture_width = rand() % MAX_WIDTH + 1;
					texture_height = rand() % MAX_HEIGHT + 1;

					fout << texture_width << " " << texture_height << std::endl;
				}
				fout.close();
			}
		}
	}
	// for (int i = 0; i < CASE_NUM; ++i)
	// {
	// 	width = rand() % 91 + 10;
	// 	n = rand() % 9991 + 10;
	// 	fout.open(PATH +  (std::string)"case" + std::to_string(i) + ".txt", std::ios::trunc | std::ios::out);
	// 	fout << width << std::endl;
	// 	fout << n << std::endl;

	// 	if (fout.is_open())
	// 	{
	// 		for (int j = 0; j < n; ++j)
	// 		{
	// 			texture_width = rand() % width + 1;
	// 			texture_height = rand() % MAX_HEIGHT + 1;

	// 			fout << texture_width << " " << texture_height << std::endl;
	// 		}

	// 		fout.close();
	// 	}
	// }
}