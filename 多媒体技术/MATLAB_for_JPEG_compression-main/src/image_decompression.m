%% 1.读取压缩后的数据
clear;
load('..\img\compressed_image1.mat');
origin_width = double(origin_width);
origin_height = double(origin_height);
resize_width = ceil(origin_width/8) * 8;
resize_height = ceil(origin_height/8) * 8;

%% 2.霍夫曼解码得到DPCM编码后的DC系数和RLC编码后的AC系数
dcY = myhuffmandeco(dcY_comp, dcY_dict);
dcCb = myhuffmandeco(dcCb_comp, dcCb_dict);
dcCr = myhuffmandeco(dcCr_comp, dcCr_dict);
acY = myhuffmandeco(acY_comp, acY_dict);
acCb = myhuffmandeco(acCb_comp, acCb_dict);
acCr = myhuffmandeco(acCr_comp, acCr_dict);

%% 3.DPCM解码得到DC系数
dcY_rec = dpcm_decode(dcY);
dcCb_rec = dpcm_decode(dcCb);
dcCr_rec = dpcm_decode(dcCr);

%% 4.RLC解码得到AC系数
[~,col_cnt] = size(dcY_rec);
acY_rec = rlc_decode(acY,col_cnt);
acCb_rec = rlc_decode(acCb,col_cnt/4);
acCr_rec = rlc_decode(acCr,col_cnt/4);

%% 5.AC系数和DC系数重新组合成完整的矩阵
zigY = [dcY_rec;acY_rec];
zigCb = [dcCb_rec;acCb_rec];
zigCr = [dcCr_rec;acCr_rec];

%% 6.逆zigzag变换
qdctY = inv_zigzag(zigY,resize_width);
qdctCb = inv_zigzag(zigCb,resize_width/2);
qdctCr = inv_zigzag(zigCr,resize_width/2);

%% 7.根据量化表进行反量化
[iqdctY,iqdctCb,iqdctCr] = inv_quantify(qdctY,qdctCb,qdctCr);

%% 8.逆dct变换
[iy,icb,icr] = inv_blockdct(iqdctY,iqdctCb,iqdctCr);

%% 9.根据颜色下采样后的结果重新生成YCbCr图像
iYCbCr = regenerate_Ycbcr(iy,icb,icr);

%% 10.YCbCr图像转换为RGB图像
irgb = ycbcr2rgb(iYCbCr);
irgb_origin = irgb(1:origin_height,1:origin_width,:);
figure(),imshow(irgb_origin),title("reconstructed image");
imwrite(irgb_origin,'..\img\reconstructed_1.bmp');  % 输入要保存重构图像的路径

%% 函数功能：huffman解码
function sig = myhuffmandeco(comp,dict)
    comp = double(comp);    %重新将comp还原成double类型，否则无法调用huffmandeco函数
    sig = huffmandeco(comp,dict);
end

%% 函数功能：对DC系数进行DPCM解码
function f_rec = dpcm_decode(en)
    [~,cnt] = size(en);
    f_pre = zeros(1,cnt);
    f_rec = zeros(1,cnt);
    f_pre(1) = en(1); %预测信号的前两个初始化为原始信号的第一个信号
    f_pre(2) = en(1);
    f_rec(1) = en(1); %重构信号的第一个值也初始化为原始信号的第一个信号
    for i=2:cnt
        if(i ~= 2)
            f_pre(i) = (f_rec(i-1) + f_rec(i-2))/2;
        end
        f_rec(i) = f_pre(i) + en(i);        
    end
    f_rec = double(uint8(f_rec));   %取整之后重新转换为double类型
end

%% 函数功能：对RLC编码后的AC系数进行解码
function out = rlc_decode(in,col_cnt)
    [~,cnt] = size(in);
    rlc_table = reshape(in,cnt/2,2);    %将输入还原为两列的rlc表的形式
    ac_vec = zeros(1,63 * col_cnt);
    j = 1;
    for i=1:cnt/2
        if(rlc_table(i,1) == 0)         %某行的第一个数为0，则直接将后一个数赋给ac_vec
            ac_vec(j) = rlc_table(i,2);
            j = j + 1;
        else                            %某行的第一个数不为0，则这个数即为0的个数，给ac_vec填充相应个数的0
            for k=1:rlc_table(i,1)
                ac_vec(j) = 0;
                j = j + 1;
            end
            ac_vec(j) = rlc_table(i,2); %然后将该行的后一个数赋给ac_vec
            j = j + 1;
        end
    end
    out = reshape(ac_vec,63,col_cnt);   %重新调整矩阵格式为63行的AC系数，便于后续与DC系数拼接
end

%% 函数功能：通过zigzag遍历8×8矩阵，产生一个1×64的向量
function zigx = block_zigzag(x)
    zigzag_table=[
        1 2 9 17 10 3 4 11;
        18 25 33 26 19 12 5 6;
        13 20 27 34 41 49 42 35; 
        28 21 14 7 8 15 22 29;
        36 43 50 57 58 51 44 37;
        30 23 16 24 31 38 45 52;
        59 60 53 46 39 32 40 47;
        54 61 62 55 48 56 63 64];
    
    v = reshape(x',1,64); % 将输入8×8矩阵变为1x64的向量
    vtable = reshape(zigzag_table',1,64);
    zigx = v(vtable); % 通过查表的方式模拟zigzag扫描
end

%% 函数功能：将输入矩阵分成8×8的小块，分别进行zigzag处理
function zigx = zigzag(x)
    fun = @(block_struct) block_zigzag(block_struct.data);
    tzigx = blockproc(x,[8,8],fun);
    [a,b] = size(tzigx);
    zigx = reshape(tzigx',64,a*b/64);   % 将zigzag处理后的矩阵格式调整为n×64，便于接下来对DC系数和AC系数分别处理
end

%% 函数功能：将一个64×1的列向量逆zigzag变换还原为8×8的矩阵
function invzigx = block_inv_zigzag(x)
    zigzag_table=[
        1 2 9 17 10 3 4 11;
        18 25 33 26 19 12 5 6;
        13 20 27 34 41 49 42 35; 
        28 21 14 7 8 15 22 29;
        36 43 50 57 58 51 44 37;
        30 23 16 24 31 38 45 52;
        59 60 53 46 39 32 40 47;
        54 61 62 55 48 56 63 64];
    
    vtable = reshape(zigzag_table',1,64);   
    invzigx = zeros(8,8);
    for i=1:64
        invzigx(vtable(i)) = x(i);  % 通过查表的方式进行逆向zigzag扫描
    end
    invzigx = invzigx';
end

%% 函数功能：将输入矩阵的每一列分别进行逆zigzag处理
function invzigx = inv_zigzag(x,resize_width)
    tzigx = reshape(x,resize_width*8,[]);
    tzigx = tzigx';
    fun = @(block_struct) block_inv_zigzag(block_struct.data);
    invzigx = blockproc(tzigx,[1,64],fun);
end

%% 函数功能：通过已有的亮度和色度量化表，对矩阵进行反量化
function [y,cb,cr] = inv_quantify(qy,qcb,qcr)
    %亮度量化表
    LumiTable=[
        16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62;
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
    %色度量化表
    ChromiTable=[
        17 18 24 47 99 99 99 99 ;
        18 21 26 66 99 99 99 99 ;
        24 26 56 99 99 99 99 99 ;
        47 66 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99 ;
        99 99 99 99 99 99 99 99];    
    
    fun1 = @(block_struct) block_struct.data .* LumiTable;
    fun2 = @(block_struct) block_struct.data .* ChromiTable;
    y = blockproc(qy,[8,8],fun1);
    cb = blockproc(qcb,[8,8],fun2);
    cr = blockproc(qcr,[8,8],fun2);
end

%% 函数功能：将图像以8*8的小块为单位进行逆dct变换后返回
function [y,cb,cr] = inv_blockdct(dcty,dctcb,dctcr)
    fun = @(block_struct) idct2(block_struct.data);
    y=blockproc(dcty,[8 8],fun);
    cb=blockproc(dctcb,[8 8],fun);
    cr=blockproc(dctcr,[8 8],fun);
end

%% 函数功能：利用颜色下采样后的结果重新生成图像
function down_imgYCbCr = regenerate_Ycbcr(imgY,imgCb,imgCr)
    [YH,YL] = size(imgY);
    [CbH,CbL] = size(imgCb);
    y = uint8(imgY);
    cb = zeros(YH,YL);
    cr = zeros(YH,YL);
    for i=1:CbH
        for j=1:CbL
            [cb(2*i,2*j),cb(2*i-1,2*j),cb(2*i,2*j-1),cb(2*i-1,2*j-1)] = deal(imgCb(i,j)); %每一个值都要填充一个2×2的小块
            [cr(2*i,2*j),cr(2*i-1,2*j),cr(2*i,2*j-1),cr(2*i-1,2*j-1)] = deal(imgCr(i,j));
        end
    end
    cb = uint8(cb);
    cr = uint8(cr);
    down_imgYCbCr = cat(3,y,cb,cr);
end
