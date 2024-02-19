//
// Created by Yile Liu on 2023/5/1.
//
#include "utils.cpp"
#include "huffman.cpp"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        cout << "Too few arguments." << endl
             << "Usage: ./decode2708 [source file path]" << endl;
        exit(1);
    }

    const char *src_file = argv[1];

    FILE *fpr = fopen(src_file, "rb");
    if (fpr == nullptr) {
        cout << "Source file: " << src_file << " does not exist." << endl;
        exit(3);
    } else {
        cout << "Start decompress:" << endl;
    }

    initDctTable();

    int orig_rows, orig_cols;
    fscanf(fpr, "%d %d ", &orig_rows, &orig_cols);

    // 将长宽补齐到16的倍数 并以此计算容器的大小
    int right_remain = orig_cols % 16;
    int bottom_remain = orig_rows % 16;
    int right_border = right_remain ? 16 - right_remain : 0;
    int bottom_border = bottom_remain ? 16 - bottom_remain : 0;

    int rows = orig_rows + bottom_border;
    int cols = orig_cols + right_border;
    int block_num = rows / 8 * cols / 8;


    // Decode7 读文件并反Huffman编码
    cout << "\tHuffman decoding" << endl;
    vector<int> dpcm_vec_out, rlc_vec_out;
    huffmanDecode(fpr, dpcm_vec_out, rlc_vec_out);


    // Decode6 从差分编码和RCL编码中还原每个64*1的Vec
    cout << "\tInverse DPCM & RLC" << endl;
    vector<vector<int>> y_vec_out(block_num, vector<int>(64));
    vector<vector<int>> cb_vec_out(block_num / 4, vector<int>(64));
    vector<vector<int>> cr_vec_out(block_num / 4, vector<int>(64));

    idpcm(dpcm_vec_out, y_vec_out, cb_vec_out, cr_vec_out);
    irlc(rlc_vec_out, y_vec_out, cb_vec_out, cr_vec_out);


    // Decode5 iZigZag反序列化
    cout << "\tZigzag deserialization" << endl;
    Mat y_channel_out(rows, cols, CV_32SC1);
    Mat cb_channel_out(rows / 2, cols / 2, CV_32SC1);
    Mat cr_channel_out(rows / 2, cols / 2, CV_32SC1);

    izigzag8x8(y_vec_out, y_channel_out);
    izigzag8x8(cb_vec_out, cb_channel_out);
    izigzag8x8(cr_vec_out, cr_channel_out);


    // Decode4 先进行反量化 再转回浮点类型
    cout << "\tInverse quantification" << endl;
    iquant(y_channel_out, y_channel_out, y_table);
    iquant(cb_channel_out, cb_channel_out, c_table);
    iquant(cr_channel_out, cr_channel_out, c_table);

    y_channel_out.convertTo(y_channel_out, CV_32FC1);
    cb_channel_out.convertTo(cb_channel_out, CV_32FC1);
    cr_channel_out.convertTo(cr_channel_out, CV_32FC1);


    // Decode3 进行反DCT变换
    cout << "\tInverse DCT" << endl;
    idct8x8(y_channel_out, y_channel_out);
    idct8x8(cb_channel_out, cb_channel_out);
    idct8x8(cr_channel_out, cr_channel_out);


    // Decode2 将下采样后的颜色通道大小还原
    resize(cb_channel_out, cb_channel_out, Size(cb_channel_out.cols * 2, cb_channel_out.rows * 2), 0, 0, INTER_NEAREST);
    resize(cr_channel_out, cr_channel_out, Size(cr_channel_out.cols * 2, cr_channel_out.rows * 2), 0, 0, INTER_NEAREST);


    // Decode1 从YCbCr转回RGB 并将分离的通道重新合成为图像
    cout << "\tPicture reconstruction" << endl;
    Mat out_img;
    yCbCr2Rgb(y_channel_out, cb_channel_out, cr_channel_out, out_img);

    // Decode0 将边缘填充裁去
    if (right_border || bottom_border) {
        out_img = out_img(Rect(0, 0, out_img.cols - right_border, out_img.rows - bottom_border));
    }

    imshow(src_file, out_img);
    fclose(fpr);
    waitKey(0);
}