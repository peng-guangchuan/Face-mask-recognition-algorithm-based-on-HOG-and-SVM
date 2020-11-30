function [face_num , masked] = dection(img,model)
faceDetector = vision.CascadeObjectDetector();%级联对象检测器,官方分类器使用 haar 特征来编码面部特征模型
%加上xml文件为添加自定义模型，提高自身某种特定场合的识别率
% faceDetector.ClassificationModel='FrontalFaceLBP'; %使用本地二进制模式 (lbp) 来编码面部特征
faceDetector.MergeThreshold=7;%多次尝试后筛选的理想检测阈值，能在抑制错误和检测成功图像数量平衡
%级联训练器trainCascadeObjectDetector() ， ROI为感兴趣区域，主要有四个参数，起始点x 起始点y 宽width 高height （类似bbox）
% lo = load('model.mat');
% model = lo.model;
% file_path='E:\Desktop\口罩检测\新建文件夹\';
save_path='C:/Users/川川/Desktop/数字图像处理课程设计/数据集/头像裁剪集合/';
% path_list=dir(strcat(file_path,'*.jpg'));
% img_num=length(path_list);
label = zeros();%结果数组
result = 1;
% if img_num>0
%     for j=1:img_num
%         image_name=path_list(j).name;
%         I=imread(strcat(file_path,image_name));
I = img;
%faceDetector.ScaleFactor = size(I)/(size(I)-0.5);
bbox=step(faceDetector,I);%bbox的参数分布表示[x y width height]，step函数使用faceDetector特征多图像I进行多尺度的对象检测
faceOut = insertObjectAnnotation(I,'rectangle',bbox,'face'); %根据bbox数据对检测到的人脸画框，
face_num = length(bbox(:,1));%检测到的人脸数量
masked = 0;%带口罩人脸数量
for k = 1:face_num
    %
    faceout1=imcrop(I,bbox(k,:));%根据bbox中的数据截取人脸头像
    faceout2=imresize(faceout1,[128,128]);%扩大图片尺寸
    resultHog = HOGdescriptor(faceout2,[128,128],4,2);
    %             [labelpre,~,~] = svmpredict(1,resultHog,model);
    labelpre = predict(model,resultHog);%根据model分类器对处理后的图像数据进行预测分类，使用默认步长
    %label
    if labelpre == 1 %1表示该图片带了口罩
        drawRectangleImage(bbox(k,1),bbox(k,1)+bbox(k,3),bbox(k,2),bbox(k,2)+bbox(k,4),'g');%绿框
        masked = masked + 1;
    else
        drawRectangleImage(bbox(k,1),bbox(k,1)+bbox(k,3),bbox(k,2),bbox(k,2)+bbox(k,4),'r');%红框
    end
    label(result)=labelpre; %存储结果矩阵
    imwrite(faceout2,strcat(save_path,strcat(num2str(result),'.tif'))); % 将截取到的人脸图片保存本地
    result = result+1;
end

end
% end
% end