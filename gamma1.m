function res = gamma1(faceout2,a,g)

faceout2 = im2double(faceout2);
faceout2 = rgb2gray(faceout2);
res = a * (faceout2 .^ g);

subplot(121);
imshow(faceout2);
subplot(122);
imshow(res);



end
