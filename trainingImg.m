function trainingImg()
    positive_path = 'C:/Users/川川/Desktop/数字图像处理课程设计/数据集/svm训练负样本集/';
    negative_path = 'C:/Users/川川/Desktop/数字图像处理课程设计/数据集/svm训练正样本集/';
    posExamples=dir(positive_path);%读取文件夹里的所有.jpg图片
    [posSampleNums , ~]=size(posExamples);
    negExamples=dir(negative_path);%读取文件夹里的所有.jpg图片
    [negSampleNums , ~]=size(negExamples);
     negSampleNums=300;
     posSampleNums=90;
    trainData=zeros(posSampleNums+negSampleNums,34596);%用于保存训练数据的矩阵，其中列数即特征向量维数，改变cell和block以及图像的统一大小时需要改变
    trainLabel=zeros(posSampleNums+negSampleNums,1);
    trainLabel(1:posSampleNums)=ones(1,posSampleNums);%1是正例，0是负例
    for i=3:posSampleNums
        'pos'
        i
        imgName=posExamples(i).name;
        ImgPath=strcat(positive_path,imgName); 
        current=imread(ImgPath);%读取图片
        result = HOGdescriptor(current,[128,128],4,2);
        trainData(i,:)=result;
    end
    for i=3:negSampleNums
        'neg'
        i
        imgName=negExamples(i).name;
        ImgPath=strcat(negative_path,imgName); 
        current=imread(ImgPath);%读取图片
        result = HOGdescriptor(current,[128,128],4,2);
        trainData(i+posSampleNums,:)=result;    
    end
    %SVM训练
    model = fitcsvm(trainData,trainLabel);%线性分割
    save('lower_fitcsvm.mat','model');
end

