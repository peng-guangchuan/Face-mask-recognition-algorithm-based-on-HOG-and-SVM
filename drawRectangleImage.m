% function drawRectangleImage(p1,p2)%画框程序，分别是左边竖线，右边竖线，上面横线，下面横线
function drawRectangleImage(xColMin,xColMax,yRowMin ,yRowMax,color)%画框程序，分别是左边竖线，右边竖线，上面横线，下面横线
% xColMin = p1(2);
% xColMax = p2(2); 
% yRowMin = p1(1);
% yRowMax = p2(1);
hold on 
plot([xColMin xColMax],[yRowMin yRowMin],color)
plot([xColMin xColMax],[yRowMax yRowMax],color)
plot([xColMin xColMin],[yRowMin yRowMax],color)
plot([xColMax xColMax],[yRowMin yRowMax],color)
end

