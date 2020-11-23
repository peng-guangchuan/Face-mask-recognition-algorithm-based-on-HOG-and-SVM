function drawRectangleImage(xColMin,xColMax,yRowMin ,yRowMax,color)
%绘制框程序
hold on 
plot([xColMin xColMax],[yRowMin yRowMin],color)%第1行
plot([xColMin xColMax],[yRowMax yRowMax],color)%最后一行
plot([xColMin xColMin],[yRowMin yRowMax],color)%第一列
plot([xColMax xColMax],[yRowMin yRowMax],color)%最后一列
end

