#include "utils.cpp"
#include "huffman.cpp"

using namespace std;

int main(int argc, char *argv[]) {
    if (argc < 3) {
        cout << "Too few arguments." << endl
             << "Usage: ./encode2708 [source pic path] [saved file name]" << endl;
        exit(1);
    }

    const char *src_file = argv[1];
    const char *dst_file = argv[2];
    Mat src_img = cv::imread(src_file);

    if (src_img.empty()) {
        cout << "Source file: " << src_file << " does not exist." << endl;
        exit(2);
    } else {
        cout << "Start compress:" << endl;
    }

    initDctTable();

    int orig_cols = src_img.cols;
    int orig_rows = src_img.rows;

    // Encode0 将图像长宽补齐到16的倍数
    int right_remain = src_img.cols % 16;
    int bottom_remain = src_img.rows % 16;
    int right_border = right_remain ? 16 - right_remain : 0;
    int bottom_border = bottom_remain ? 16 - bottom_remain : 0;

    if (right_border || bottom_border) {
        copyMakeBorder(src_img, src_img, 0, bottom_border, 0, right_border, BORDER_REFLECT);
    }

    // Encode1 RGB -> YCbCr 并分离通道
    // 为了便于下一步DCT变换，这里输出的channel的类型均为CV_32FC1
    cout << "\tChannel separation" << endl;
    Mat y_channel, cb_channel, cr_channel;
    rgb2YCbCr(src_img, y_channel, cb_channel, cr_channel);


    // Encode2 对彩色通道做420下采样
    cout << "\tColor subsampling" << endl;
    resize(cb_channel, cb_channel, Size(cb_channel.cols / 2, cb_channel.rows / 2), 0, 0, INTER_LINEAR);
    resize(cr_channel, cr_channel, Size(cr_channel.cols / 2, cr_channel.rows / 2), 0, 0, INTER_LINEAR);


    // Encode3 进行DCT变换
    cout << "\tDCT" << endl;
    dct8x8(y_channel, y_channel);
    dct8x8(cb_channel, cb_channel);
    dct8x8(cr_channel, cr_channel);


    // Encode4 需要先将通道转为CV_32SC1 然后进行基于整数除法的量化
    cout << "\tQuantification" << endl;
    y_channel.convertTo(y_channel, CV_32SC1);
    cb_channel.convertTo(cb_channel, CV_32SC1);
    cr_channel.convertTo(cr_channel, CV_32SC1);

    quant(y_channel, y_channel, y_table);
    quant(cb_channel, cb_channel, c_table);
    quant(cr_channel, cr_channel, c_table);


    // Encode5 ZigZag序列化
    cout << "\tZigzag serialization" << endl;
    vector<vector<int>> y_vec, cb_vec, cr_vec;

    zigzag8X8(y_channel, y_vec);
    zigzag8X8(cb_channel, cb_vec);
    zigzag8X8(cr_channel, cr_vec);


    // Encode6 DC分量使用差分编码 AC分量使用RLC编码
    cout << "\tDPCM & RLC" << endl;
    vector<int> dpcm_vec, rlc_vec;
    dpcm(y_vec, cb_vec, cr_vec, dpcm_vec);
    rlc(y_vec, cb_vec, cr_vec, rlc_vec);


    // Encode7 HuffmanCode并写文件
    cout << "\tHuffman encoding" << endl;
    FILE *fp = fopen(dst_file, "wb");
    fprintf(fp, "%d %d ", orig_rows, orig_cols);

    huffmanEncode(dpcm_vec, rlc_vec, fp);
    fclose(fp);
}

