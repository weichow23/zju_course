//
// Created by Yile Liu on 2023/5/1.
//
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

const static int N = 8;

Mat dct_table(N, N, CV_32FC1);
Mat idct_table(N, N, CV_32FC1);

const static int zigzag_lut[8][8] = {0, 1, 8, 16, 9, 2, 3, 10,
                                     17, 24, 32, 25, 18, 11, 4, 5,
                                     12, 19, 26, 33, 40, 48, 41, 34,
                                     27, 20, 13, 6, 7, 14, 21, 28,
                                     35, 42, 49, 56, 57, 50, 43, 36,
                                     29, 22, 15, 23, 30, 37, 44, 51,
                                     58, 59, 52, 45, 38, 31, 39, 46,
                                     53, 60, 61, 54, 47, 55, 62, 63};

const Mat y_table = (Mat_<int>(8, 8) <<
                                     16, 11, 10, 16, 24, 40, 51, 61,
        12, 12, 14, 19, 26, 58, 60, 55,
        14, 13, 16, 24, 40, 57, 69, 56,
        14, 17, 22, 29, 51, 87, 80, 62,
        18, 22, 37, 56, 68, 109, 103, 77,
        24, 35, 55, 64, 81, 104, 113, 92,
        49, 64, 78, 87, 103, 121, 120, 101,
        72, 92, 95, 98, 112, 100, 103, 99
);

const Mat c_table = (Mat_<int>(8, 8) <<
                                     17, 18, 24, 47, 99, 99, 99, 99,
        18, 21, 26, 66, 99, 99, 99, 99,
        24, 26, 56, 99, 99, 99, 99, 99,
        77, 66, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99
);

void initDctTable() {
    float c[N];

    for (int i = 0; i < N; i++) {
        if (i == 0) {
            c[i] = sqrt(1.0 / N);
        } else {
            c[i] = sqrt(2.0 / N);
        };
    }

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            dct_table.at<float>(i, j) = c[i] * cos((2 * j + 1) * i * M_PI / (2 * N));
        }
    }

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            idct_table.at<float>(j, i) = dct_table.at<float>(i, j);
        }
    }
}

void zigzag8X8(Mat &src, vector<vector<int>> &v) {


    int rows = src.rows;
    int cols = src.cols;

    for (int r = 0; r < rows; r += 8) {
        for (int c = 0; c < cols; c += 8) {
            Mat target = src(Rect(c, r, 8, 8));
            vector<int> inside_vec(64);
            for (int i = 0; i < 8; i++) {
                for (int j = 0; j < 8; j++) {
                    inside_vec[zigzag_lut[i][j]] = target.at<int>(i, j);
                }
            }

            v.emplace_back(inside_vec);
        }
    }
}

void izigzag8x8(vector<vector<int>> &v, Mat &dst) {

    int rows = dst.rows;
    int cols = dst.cols;

    int cnt = 0;
    for (int r = 0; r < rows; r += 8) {
        for (int c = 0; c < cols; c += 8) {
            Mat target = dst(Rect(c, r, 8, 8));
            auto inside_vec = v[cnt++];
            for (int i = 0; i < 8; i++) {
                for (int j = 0; j < 8; j++) {
                    target.at<int>(i, j) = inside_vec[zigzag_lut[i][j]];
                }
            }
        }
    }
}

void quant(Mat &src, Mat &dst, const Mat &coeff) {
    int r_step = coeff.rows;
    int c_step = coeff.cols;

    int rows = dst.rows;
    int cols = dst.cols;

    for (int r = 0; r < rows; r += r_step) {
        for (int c = 0; c < cols; c += c_step) {
            Mat target = dst(Rect(c, r, c_step, r_step));
            cv::divide(target, coeff, target);
        }
    }
}

void iquant(Mat &src, Mat &dst, const Mat &coeff) {
    int r_step = coeff.rows;
    int c_step = coeff.cols;

    int rows = dst.rows;
    int cols = dst.cols;

    for (int r = 0; r < rows; r += r_step) {
        for (int c = 0; c < cols; c += c_step) {
            Mat target = dst(Rect(c, r, c_step, r_step));
            cv::multiply(target, coeff, target);
        }
    }
}

void dct8x8(Mat &src, Mat &dst) {
    int rows = src.rows;
    int cols = src.cols;

    for (int r = 0; r < rows; r += N) {
        for (int c = 0; c < cols; c += N) {
            Mat target = src(Rect(c, r, N, N));
            dst(Rect(c, r, N, N)) = dct_table * target * idct_table;
        }
    }
}

void idct8x8(Mat &src, Mat &dst) {
    int rows = src.rows;
    int cols = src.cols;

    for (int r = 0; r < rows; r += N) {
        for (int c = 0; c < cols; c += N) {
            Mat target = src(Rect(c, r, N, N));
            dst(Rect(c, r, N, N)) = idct_table * target * dct_table;
        }
    }
}

void dpcm(vector<vector<int>> &y_vec, vector<vector<int>> &cb_vec, vector<vector<int>> &cr_vec,
          vector<int> &dpcm_vec) {
    int prev = 0;
    for (vector<int> &inside_vec: y_vec) {
        dpcm_vec.emplace_back(inside_vec[0] - prev);
        prev = inside_vec[0];
    }
    for (vector<int> &inside_vec: cb_vec) {
        dpcm_vec.emplace_back(inside_vec[0] - prev);
        prev = inside_vec[0];
    }
    for (vector<int> &inside_vec: cr_vec) {
        dpcm_vec.emplace_back(inside_vec[0] - prev);
        prev = inside_vec[0];
    }
}

void
idpcm(const vector<int> &dpcm_vec, vector<vector<int>> &y_vec, vector<vector<int>> &cb_vec,
      vector<vector<int>> &cr_vec) {
    int base = 0;
    int ind = 0;

    for (vector<int> &inside_vec: y_vec) {
        base += dpcm_vec[ind++];
        inside_vec[0] = base;
    }
    for (vector<int> &inside_vec: cb_vec) {
        base += dpcm_vec[ind++];
        inside_vec[0] = base;
    }
    for (vector<int> &inside_vec: cr_vec) {
        base += dpcm_vec[ind++];
        inside_vec[0] = base;
    }
}

void rlc(vector<vector<int>> &y_vec, vector<vector<int>> &cb_vec, vector<vector<int>> &cr_vec,
         vector<int> &rlc_vec) {
    int val = 0;
    int cnt = 0;
    for (vector<int> &inside_vec: y_vec) {
        for (int i = 1; i < 64; i++) {
            int &d = inside_vec[i];
            if (d == val) {
                cnt++;
            } else {
                rlc_vec.emplace_back(val);
                rlc_vec.emplace_back(cnt);
                val = d;
                cnt = 1;
            }
        }
    }
    for (vector<int> &inside_vec: cb_vec) {
        for (int i = 1; i < 64; i++) {
            int &d = inside_vec[i];
            if (d == val) {
                cnt++;
            } else {
                rlc_vec.emplace_back(val);
                rlc_vec.emplace_back(cnt);
                val = d;
                cnt = 1;
            }
        }
    }
    for (vector<int> &inside_vec: cr_vec) {
        for (int i = 1; i < 64; i++) {
            int &d = inside_vec[i];
            if (d == val) {
                cnt++;
            } else {
                rlc_vec.emplace_back(val);
                rlc_vec.emplace_back(cnt);
                val = d;
                cnt = 1;
            }
        }
    }

    rlc_vec.emplace_back(val);
    rlc_vec.emplace_back(cnt);
}


void
irlc(const vector<int> &rlc_vec, vector<vector<int>> &y_vec, vector<vector<int>> &cb_vec,
     vector<vector<int>> &cr_vec) {
    int ind = 0;
    int val = rlc_vec[ind++];
    int cnt = rlc_vec[ind++];

    for (vector<int> &inside_vec: y_vec) {
        for (int i = 1; i < 64; i++) {
            if (cnt == 0) {
                val = rlc_vec[ind++];
                cnt = rlc_vec[ind++];
            }

            inside_vec[i] = val;
            cnt--;
        }
    }
    for (vector<int> &inside_vec: cb_vec) {
        for (int i = 1; i < 64; i++) {
            if (cnt == 0) {
                val = rlc_vec[ind++];
                cnt = rlc_vec[ind++];
            }

            inside_vec[i] = val;
            cnt--;
        }
    }
    for (vector<int> &inside_vec: cr_vec) {
        for (int i = 1; i < 64; i++) {
            if (cnt == 0) {
                val = rlc_vec[ind++];
                cnt = rlc_vec[ind++];
            }

            inside_vec[i] = val;
            cnt--;
        }
    }
}

void rgb2YCbCr(const Mat &src, Mat &y_channel, Mat &cb_channel, Mat &cr_channel) {
    int height = src.rows;
    int width = src.cols;
    y_channel = Mat(src.rows, src.cols, CV_32FC1);
    cb_channel = Mat(src.rows, src.cols, CV_32FC1);
    cr_channel = Mat(src.rows, src.cols, CV_32FC1);

    for (int r = 0; r < height; r++) {
        for (int c = 0; c < width; c++) {
            Vec3b src_pixel = src.at<Vec3b>(r, c);

            y_channel.at<float>(r, c) = 0.299f * src_pixel[2] + 0.587f * src_pixel[1] + 0.114f * src_pixel[0];
            cb_channel.at<float>(r, c) =
                    -0.169f * src_pixel[2] - 0.331f * src_pixel[1] + 0.500f * src_pixel[0];
            cr_channel.at<float>(r, c) =
                    0.500f * src_pixel[2] - 0.419f * src_pixel[1] - 0.081f * src_pixel[0];
        }
    }
}

uchar static inline round2Uchar(double input) {
    if (input > 255)
        return 255;
    if (input < 0)
        return 0;

    return round(input);
}

void yCbCr2Rgb(const Mat &y_channel, const Mat &cb_channel, const Mat &cr_channel, Mat &out_img) {
    int height = y_channel.rows;
    int width = y_channel.cols;

    out_img = Mat(height, width, CV_8UC3);

    for (int r = 0; r < height; r++) {
        for (int c = 0; c < width; c++) {
            float y = y_channel.at<float>(r, c);
            float cb = cb_channel.at<float>(r, c);
            float cr = cr_channel.at<float>(r, c);

            uchar red = round2Uchar(y + 1.403 * cr);
            uchar green = round2Uchar(y - 0.344 * cb - 0.714 * cr);
            uchar blue = round2Uchar(y + 1.773 * cb);

            out_img.at<Vec3b>(r, c) = {blue, green, red};
        }
    }
}