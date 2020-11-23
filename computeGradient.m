function [gradient_magnitude,gradient_angle] = computeGradient(img,model)
%%计算传入图像每个像素点在x，y轴的梯度,
%输入参数：
% model ：梯度算子的类型，0为Prewitt算子，1为sobel算子
%返回参数：
% gradient_magnitude：图像各个像素点的梯度幅值
% gradient_angle: 图像各个像素点的梯度方向
    [r,c] = size(img);
    img = double(img);
    prewitt_x = [-1,-1,-1;0,0,0;1,1,1];%Prewitt算子
    prewitt_y = [-1,0,1;-1,0,1;-1,0,1];
    sobel_x = [-1,-2,-1;0,0,0;1,2,1];%Sobel算子
    sobel_y = [-1,0,1;-2,0,2;-1,0,1];
    if model == 0
        operator_x = prewitt_x;
        operator_y = prewitt_y;
    else
        operator_x = sobel_x;
        operator_y = sobel_y;
    end
    gx = zeros(r,c);
    gy = gx;
    for i = 2:r-1
        for j = 2:c-1
            gx(i,j) = sum(sum(img(i-1:i+1,j-1:j+1).*operator_x));
            gy(i,j) = sum(sum(img(i-1:i+1,j-1:j+1).*operator_y));
        end
    end
    
    %对第一列和最后一列的梯度值进行特殊运算
    for i = 2:r-1
        gx(i,1) = 0;
        gx(i,c) = 0;
        gy(i,1) = img(i+1,1)-img(i-1,1);
        gy(i,c) = img(i+1,c)-img(i-1,c);
    end
    for i = 2:c-1
        gy(1,i) = 0;
        gy(r,i) = 0;
        gx(1,i) = img(1,i+1)-img(1,i-1);
        gx(r,i) = img(r,i+1)-img(r,i-1);
    end
    gradient_magnitude = abs(gx)+abs(gy);
    gradient_angle = atan(gy./(gx+eps));
    gradient_angle = gradient_angle*(180/pi);
end