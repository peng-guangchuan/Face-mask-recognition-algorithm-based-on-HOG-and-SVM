function trainingImg()
    positive_path = 'D:/计算机学习/大三上/数字图像处理_庄家骏/课程设计/数据集/正样本2/';
    negative_path = 'D:/计算机学习/大三上/数字图像处理_庄家骏/课程设计/数据集/负样本2/';
    posExamples=dir(positive_path);%读取文件夹里的所有.jpg图片
    [posSampleNums , ~]=size(posExamples);
    negExamples=dir(negative_path);%读取文件夹里的所有.jpg图片
    [negSampleNums , ~]=size(negExamples);
%     negSampleNums=300;
%     PosSampleNums=90;
    trainData=zeros(posSampleNums+negSampleNums,9216);%用于保存训练数据的矩阵，其中列数即特征向量维数，改变cell和block以及图像的统一大小时需要改变
    trainLabel=zeros(posSampleNums+negSampleNums,1);
    trainLabel(1:posSampleNums)=ones(1,posSampleNums);%1是正例，0是负例
    for i=3:posSampleNums
        imgName=posExamples(i).name;
        ImgPath=strcat(positive_path,imgName); 
        current=imread(ImgPath);%读取图片
        result = HOGdescriptor(current,[128,128],4,2);
        trainData(i,:)=result;
    end
    for i=3:negSampleNums
        imgName=negExamples(i).name;
        ImgPath=strcat(negative_path,imgName); 
        current=imread(ImgPath);%读取图片
        result = HOGdescriptor(current,[128,128],4,2);
        trainData(i+posSampleNums,:)=result;    
    end
    %SVM训练
    model = fitsvm(trainLabel,trainData);%线性分割
    save('lower2.mat','model');
end

