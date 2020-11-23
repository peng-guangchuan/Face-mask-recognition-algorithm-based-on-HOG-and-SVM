function ResultDescriptor = HOGdescriptor(img,imgSize,cellSize,blockSize)%,cell_x,cell_y,bolck_x,bolok_y)
% 获取图像的HOG方向直方图
%img：输入图像的uint8矩阵
%imgSize: 一个长度为2的一维矩阵，imgSize(1)表示统一大小的图片的行数，imgSize(1)表示统一大小的图片的列数
%cellSize: cell区域的大小，cell区域为size*size的矩阵区域
%blockSize: block区域的大小，block区域为size*size的矩阵区域
    img_gray = rgb2gray(img);
    r=imgSize(1);
    c=imgSize(2);
    img_gray = imresize(img_gray,[r,c],'bilinear');%使用双线性插值算法将图片缩减到指定大小
    [gradient_magnitude,gradient_angle] = computeGradient(img_gray,1);%获取图像每个点的梯度幅值以及角度
    
    %初始化cell和block的相关数据，由于输入图片会变换成128*128的方形，且cell和block的形状均为方形，因此仅通过r和大小可以计算出个数
    cellNum = r/cellSize();%cell个数
    blockNum = cellNum/blockSize();%cell个数
    
    orient=9;%方向直方图的方向个数
    jiao=180/orient;%每个方向包含的角度数
    
    [r,c] = size(gradient_magnitude);
    cells = zeros(cellNum,cellNum,orient);%前两个为cell的位置，第三个为cell内的角度值统计
    blocks = zeros(blockNum,blockNum,blockSize*blockSize*orient);%前两个为block的位置，第三个为cell内的角度值统计
    indexi = 1;
    for i = 1:cellSize:r
        indexj = 1;
        for j = 1:cellSize:c
            %遍历当前cell内的角度值
            for p = 0:cellSize-1
                for q = 0:cellSize-1
                    for angIndex = 1:orient
                        if gradient_angle(i+p,j+q)<(jiao*(angIndex)-90)
                            cells(indexi,indexj,angIndex) = cells(indexi,indexj,angIndex) + gradient_magnitude(i+p,j+q);
                            break;
                        end
                    end
                end
            end
            indexj = indexj +1;
        end
        indexi = indexi+1;
    end
    [xblockNum,yblockNum,wblockNum] = size(blocks);
    ResultDescriptor = zeros(xblockNum*yblockNum*wblockNum:1);
    blockindex = 1;
    for i = 1:xblockNum
        for j = 1:yblockNum
            xcell = blockSize*i-1;
            ycell = blockSize*j-1;
            temp = cat(2,cells(xcell,ycell,:),cells(xcell,ycell+1,:),cells(xcell+1,ycell,:),cells(xcell+1,ycell+1,:));
            temp = temp(:)';
            blocks(i,j,:) = temp/(abs(max(temp))+eps);%归一化
%             blocks(i,j,1:9) = cells(xcell,ycell,:);
%             blocks(i,j,10:18) = cells(xcell,ycell+1,:);
%             blocks(i,j,19:27) = cells(xcell+1,ycell,:);
%             blocks(i,j,28:36) = cells(xcell+1,ycell+1,:);
%             blocks(i,j,:) = blocks(i,j,:)./(abs(max(blocks(i,j,:)))+eps);
            ResultDescriptor((blockindex-1)*wblockNum+1:blockindex*wblockNum) = blocks(i,j,:);
            blockindex= blockindex+1;
        end
    end
end