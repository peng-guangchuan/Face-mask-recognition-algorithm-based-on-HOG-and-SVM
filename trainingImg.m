function trainingImg()
    positive_path = './正样本/';
    negative_path = './负样本/';
    posExamples=dir(positive_path);%读取文件夹里的所有.jpg图片
    [PosSampleNums , ~]=size(posExamples);
    negExamples=dir(negative_path);%读取文件夹里的所有.jpg图片
    [negSampleNums , ~]=size(negExamples);
    TrainData=zeros(PosSampleNums+negSampleNums,9216);%输出的Hog特征值保存在这里
    TrainLabel=zeros(PosSampleNums+negSampleNums,1);
    TrainLabel(1:PosSampleNums)=ones(1,PosSampleNums);%1是正例，0是负例
    for i=3:PosSampleNums
        ImgN=posExamples(i).name;
        ImgPath=strcat(positive_path,ImgN); %图片的路径
        CurrentImg=imread(ImgPath);
        %imshow(CurrentImg)
        'pos:'
        i%输出当前进度
        img_gray = rgb2gray(CurrentImg);
        img_gray = imresize(img_gray,[128,128],'bilinear');%使用双线性插值算法将图片缩减到指定大小
        [r,c] = size(img_gray);
        [gradient_magnitude,gradient_angle] = computeGradient(img_gray,1);
        result = HOGdescriptor(gradient_magnitude,gradient_angle);
%     [result,tidutu,Dir,Cells] = Hog(grayImg);
        TrainData(i,:)=result;
    end
    for i=3:negSampleNums
        'neg:'
        i%输出当前进度
        ImgN=negExamples(i).name;
        ImgPath=strcat(negative_path,ImgN); %图片的路径
        CurrentImg=imread(ImgPath);
        img_gray = rgb2gray(CurrentImg);
        img_gray = imresize(img_gray,[128,128],'bilinear');%使用双线性插值算法将图片缩减到指定大小
        [r,c] = size(img_gray);
        [gradient_magnitude,gradient_angle] = computeGradient(img_gray,1);
        result = HOGdescriptor(gradient_magnitude,gradient_angle);
%     [result,tidutu,Dir,Cells] = Hog(grayImg);
        TrainData(i+PosSampleNums,:)=result;    
    end
        %SVM训练
    model = fitcsvm(TrainData,TrainLabel);%线性映射效果比rbf好，可能由于维数大于训练样本导致，详见模式识别第一次作业的分析
    positives;
    negatives;
end

% 比较三种线性插值的效果
% img = imread('./正样本/0_0_1.jpg');
% img_gray = rgb2gray(img);
% img_gray = imresize(img_gray,[128,128],'nearest');%使用双线性插值算法将图片缩减到指定大小
% subplot(131);
% imshow(img_gray);
% img_gray = imresize(img_gray,[128,128],'bilinear');%使用双线性插值算法将图片缩减到指定大小
% subplot(132);
% imshow(img_gray);
% img_gray = imresize(img_gray,[128,128],'bicubic');%使用双线性插值算法将图片缩减到指定大小
% subplot(133);
% imshow(img_gray);