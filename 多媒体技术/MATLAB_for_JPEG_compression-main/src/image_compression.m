%% 1.读取bmp位图，并将图像的长宽补全为8的倍数
originBMP = imread('..\img\1.bmp'); % 输入需要压缩的图像路径
figure(),imshow(originBMP),title("origin bitmap image");
[origin_height,origin_width,~] = size(originBMP);
resizeBMP = resize(originBMP);

%% 2.RGB转换为YCbCr, 并进行颜色下采样
imgYCbCr = rgb2ycbcr(resizeBMP);     
[imgY,imgCb,imgCr] = downSample(imgYCbCr);

%% 3.图像分成8*8的小块分别进行dct变换处理
[dctY,dctCb,dctCr] = blockdct(imgY,imgCb,imgCr);

%% 4.根据量化表进行量化
[qdctY,qdctCb,qdctCr] = quantify(dctY,dctCb,dctCr);
% %反量化
% [iqdctY,iqdctCb,iqdctCr] = inv_quantify(qdctY,qdctCb,qdctCr);
% %反dct
% [iy,icb,icr] = inv_blockdct(iqdctY,iqdctCb,iqdctCr);
% iYCbCr = regenerate_Ycbcr(iy,icb,icr);
% figure(),imshow(iYCbCr),title("YCbCr image(after 4:2:0 downsample and quantify)");
% irgb = ycbcr2rgb(iYCbCr);
% figure(),imshow(irgb),title("RGB image(after 4:2:0 downsample and quantify)");
% imwrite(irgb,'down_and_quan.bmp');

%% 5.zigzag一维化
zigY = zigzag(qdctY);
zigCb = zigzag(qdctCb);
zigCr = zigzag(qdctCr);

%% 6.DC系数使用DPCM编码
dcY = dpcm(zigY);
dcCb = dpcm(zigCb);
dcCr = dpcm(zigCr);

%% 7.AC系数使用RLC编码
acY = rlc(zigY);
acCb = rlc(zigCb);
acCr = rlc(zigCr);

%% 8.对DC系数和AC系数应用霍夫曼编码
[dcY_comp, dcY_dict] = huffman(dcY);
[dcCb_comp, dcCb_dict] = huffman(dcCb);
[dcCr_comp, dcCr_dict] = huffman(dcCr);
[acY_comp, acY_dict] = huffman(acY);
[acCb_comp, acCb_dict] = huffman(acCb);
[acCr_comp, acCr_dict] = huffman(acCr);

%% 9.将压缩后的数据保存
origin_width = uint16(origin_width);
origin_height = uint16(origin_height);
% 输入要保存压缩图像的路径
save('..\img\compressed_image1.mat','dcY_comp','dcCb_comp','dcCr_comp','acY_comp','acCb_comp','acCr_comp','dcY_dict','dcCb_dict','dcCr_dict','acY_dict','acCb_dict','acCr_dict','origin_width','origin_height');

%% 函数功能：将图像补全为长宽都为8的倍数
function new_img = resize(img)
[m,n,~] = size(img);
new_m = ceil(m/8) * 8; % 获得向上取的8的倍数
new_n = ceil(n/8) * 8;
for i=m+1:new_m
    img(i,:,:)=img(m,:,:);
end
for j=n+1:new_n
    img(:,j,:)=img(:,n,:);
end
new_img = img;
end

%% 函数功能：对得到的YCbCr进行4:2:0颜色下采样
function [y,cb,cr] = downSample(I)
    [imgHeight,imgWidth,~] = size(I);
    y = double(I(:,:,1));                             % y分量不压缩
    cb = double(I(1:2:imgHeight-1,1:2:imgWidth-1,2)); % cb分量每个2×2小方块都取左上角
    cr = double(I(2:2:imgHeight,2:2:imgWidth,3));     % cr分量每个2×2小方块都取左下角
end

%% 函数功能：将图像以8*8的小块为单位进行dct变换后返回
function [y,cb,cr] = blockdct(imgY,imgCb,imgCr)
    fun = @(block_struct) dct2(block_struct.data);
    y=blockproc(imgY,[8 8],fun);
    cb=blockproc(imgCb,[8 8],fun);
    cr=blockproc(imgCr,[8 8],fun);
end

%% 函数功能：通过已有的亮度和色度量化表，对矩阵进行量化
function [qy,qcb,qcr] = quantify(y,cb,cr)
    %亮度量化表
    LumiTable=[
        16 11 10 16 24 40 51 61 ;
        12 12 14 19 26 58 60 55 ;
        14 13 16 24 40 57 69 56 ;
        14 17 22 29 51 87 80 62 ;
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
    
    fun1 = @(block_struct) round(block_struct.data ./ LumiTable);
    fun2 = @(block_struct) round(block_struct.data ./ ChromiTable);
    qy=blockproc(y,[8,8],fun1);
    qcb=blockproc(cb,[8,8],fun2);
    qcr=blockproc(cr,[8,8],fun2);
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
    zigx = reshape(tzigx',64,a*b/64);   % 将zigzag处理后的矩阵格式调整为64×n，便于接下来对DC系数和AC系数分别处理
end

%% 函数功能：对DC系数进行DPCM编码
function en = dpcm(x)
    f = x(1,:);
    [~,cnt] = size(f);
    f_pre = zeros(1,cnt);
    f_rec = zeros(1,cnt);
    e = zeros(1,cnt);
    en = zeros(1,cnt);
    f_pre(1) = f(1); % 预测信号的前两个初始化为原始信号的第一个信号
    f_pre(2) = f(1);
    f_rec(1) = f(1); % 重构信号的第一个值也初始化为原始信号的第一个信号
    en(1) = f(1); % 原本的en(1)应该总是0，但这里赋值为f(1)，这样函数返回en时就包含了f(1)的值以及后续的差值，便于解码
    for i=2:cnt
        if(i ~= 2)
            f_pre(i) = (f_rec(i-1) + f_rec(i-2))/2;
            %f_pre(i) = (f(i-1) + f(i-2))/2;
        end
        e(i) = f(i) - f_pre(i);
        %en(i) = 16 * floor((255 + e(i))/16) - 256 + 8; %此处选择不同的式子可以调整对DC系数的量化程度
        %en(i) = 8 * floor((255 + e(i))/8) - 256 + 4;
        %en(i) = 4 * floor((255 + e(i))/4) - 256 + 2;
        en(i) = 2 * floor((255 + e(i))/2) - 256 + 1;    
        %en(i) = e(i);
        f_rec(i) = f_pre(i) + en(i);        
    end
    
end

%% 函数功能：对AC系数进行RLC编码
function rlc_table = rlc(x)
    ac = x(2:64,:);
    [m,n] = size(ac);
    cnt = m * n;
    zero_cnt = 0;
    rlc_table = [];
    for i=1:cnt
        %if ac(i) == 0  %此处选择不同的式子可以调整对AC系数的量化程度
        if ac(i) >= -1 && ac(i) <= 1
        %if ac(i) >= -2 && ac(i) <= 2
        %if ac(i) >= -4 && ac(i) <= 4
            zero_cnt = zero_cnt + 1;
        else
            rlc_table = [rlc_table;[zero_cnt,ac(i)]];
            zero_cnt = 0;
        end
    end
    rlc_table = [rlc_table;[0,0]];  % 表的末行为[0,0]
end

%% 函数功能：对传入的参数进行huffman编码并返回码字和字典
function [comp,dict] = huffman(x)
    [m,n] = size(x);
    xx = reshape(x, 1, m*n);     %将输入转换为行向量
    table = tabulate(xx(:));     %统计输入中各个字符出现的概率
    symbols = table(:,1);        %字符保存到symbols中
    p = table(:,3) ./ 100;       %对应的概率保存到p中
    dict = huffmandict(symbols,p);  %调用huffmandict函数生成字典
    comp = huffmanenco(xx,dict);    %调用huffmanenco函数根据已有的字典将输入编码
    comp = uint8(comp);          %默认的huffmanenco得到的comp是用double存储的，这里改为uint8节省空间
end