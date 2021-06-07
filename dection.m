function [face_num , masked] = dection(model)
faceDetector = vision.CascadeObjectDetector();
faceDetector.MergeThreshold=7;
file_path='D:/计算机学习/大三上/数字图像处理/课程设计/数据集/测试集2/';
% file_path='C:/Users/川川/Desktop/数字图像处理课程设计/数据集/测试数据集/';

save_path='D:/计算机学习/大三上/数字图像处理/课程设计/数据集/结果/';
path_list=dir(strcat(file_path,'*.jpg'));
img_num=length(path_list);
label = zeros();

result = 1;
masked = 0;%带口罩人脸数量
unmasked = 0;
if img_num>0
    for j=1:img_num
        image_name=path_list(j).name;
        I=imread(strcat(file_path,image_name));
        bbox=step(faceDetector,I);%bbox的参数分布表示[x y width height]，step函数使用faceDetector特征多图像I进行多尺度的对象检测
        %faceOut = insertObjectAnnotation(I,'rectangle',bbox,'face'); %根据bbox数据对检测到的人脸画框，
        face_num = length(bbox(:,1));%检测到的人脸数量
        for k = 1:face_num
            faceout1=imcrop(I,bbox(k,:));%根据bbox中的数据截取人脸头像
            faceout2=imresize(faceout1,[128,128]);%缩放图片尺寸
            %图像预处理
            %Gamma归一化，输出为灰度图像，g为归一化系数
            faceout2 = gamma1(faceout2,2);

            [gradient_magnitude,gradient_angle] = computeGradient(faceout2,1);%获取图像每个点的梯度幅值以及角度
            resultHog = HOGdescriptor(gradient_magnitude,gradient_angle,4,2);
            
            % 使用libsvm预测并输出预测概率的方法 [labelpre,~,~] = svmpredict(1,resultHog,model);
            
            labelpre = predict(model,resultHog);%根据model分类器对处理后的图像数据进行预测分类，使用默认步长
            %label
            if labelpre == 1 %1表示该图片带了口罩
                masked = masked + 1;
            else
                unmasked = unmasked + 1;
            end
            label(result)=labelpre; %存储结果矩阵
            imwrite(faceout2,strcat(save_path,strcat(num2str(result),'.tif'))); % 将截取到的人脸图片保存本地
            result = result+1;
        end
    end
end
label
result
masked
unmasked
end