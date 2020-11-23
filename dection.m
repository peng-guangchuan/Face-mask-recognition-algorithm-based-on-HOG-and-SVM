function [face_num , masked] = dection(img,model)
faceDetector = vision.CascadeObjectDetector();
% faceDetector.ClassificationModel='FrontalFaceLBP';
faceDetector.MergeThreshold=7;
% lo = load('model.mat');
% model = lo.model;
% file_path='E:\Desktop\口罩检测\新建文件夹\';
save_path='D:/计算机学习/大三上/数字图像处理_庄家骏/课程设计/数据集/结果/';
% path_list=dir(strcat(file_path,'*.jpg'));
% img_num=length(path_list);
label = zeros();
result = 1;
% if img_num>0
%     for j=1:img_num
%         image_name=path_list(j).name;
%         I=imread(strcat(file_path,image_name));
        I = img;
        %faceDetector.ScaleFactor = size(I)/(size(I)-0.5);
        bbox=step(faceDetector,I);
        faceOut = insertObjectAnnotation(I,'rectangle',bbox,'face');
        face_num = length(bbox(:,1));
        masked = 0;
        for k = 1:face_num
%             
            faceout1=imcrop(I,bbox(k,:));
            faceout2=imresize(faceout1,[128,128]);
            resultHog = HOGdescriptor(faceout2,[128,128],4,2);
%             [labelpre,~,~] = svmpredict(1,resultHog,model);
            labelpre = predict(model,resultHog);
            %label
            if labelpre == 1
              drawRectangleImage(bbox(k,1),bbox(k,1)+bbox(k,3),bbox(k,2),bbox(k,2)+bbox(k,4),'g');
              masked = masked + 1;
            else
              drawRectangleImage(bbox(k,1),bbox(k,1)+bbox(k,3),bbox(k,2),bbox(k,2)+bbox(k,4),'r');  
            end
            label(result)=labelpre;
            imwrite(faceout2,strcat(save_path,strcat(num2str(result),'.tif')));
            result = result+1;
        end
        
    end
% end 
% end