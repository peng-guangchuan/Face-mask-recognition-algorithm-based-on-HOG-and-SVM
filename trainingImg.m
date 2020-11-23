function trainingImg()
    positive_path = 'D:/计算机学习/大三上/数字图像处理_庄家骏/课程设计/数据集/正样本2/';
    negative_path = 'D:/计算机学习/大三上/数字图像处理_庄家骏/课程设计/数据集/负样本2/';
    posExamples=dir(positive_path);%读取文件夹里的所有.jpg图片
    [PosSampleNums , ~]=size(posExamples);
    negExamples=dir(negative_path);%读取文件夹里的所有.jpg图片
    [negSampleNums , ~]=size(negExamples);
%     negSampleNums=300;
%     PosSampleNums=90;
    TrainData=zeros(PosSampleNums+negSampleNums,9216);%用于保存训练数据的矩阵，其中列数即特征向量维数，改变cell和block以及图像的统一大小时需要改变
    TrainLabel=zeros(PosSampleNums+negSampleNums,1);
    TrainLabel(1:PosSampleNums)=ones(1,PosSampleNums);%1是正例，0是负例
    for i=3:PosSampleNums
        ImgN=posExamples(i).name;
        ImgPath=strcat(positive_path,ImgN); %图片的路径
        CurrentImg=imread(ImgPath);
        %imshow(CurrentImg)
        'pos:'
        i%输出当前进度
        result = HOGdescriptor(CurrentImg,[128,128],4,2);
%     [result,tidutu,Dir,Cells] = Hog(grayImg);
        TrainData(i,:)=result;
    end
    for i=3:negSampleNums
        'neg:'
        i%输出当前进度
        ImgN=negExamples(i).name;
        ImgPath=strcat(negative_path,ImgN); %图片的路径
        CurrentImg=imread(ImgPath);
        result = HOGdescriptor(CurrentImg,[128,128],4,2);
%     [result,tidutu,Dir,Cells] = Hog(grayImg);
        TrainData(i+PosSampleNums,:)=result;    
    end
        %SVM训练
    model = fitsvm(TrainLabel,TrainData);
    save('lower2.mat','model');
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