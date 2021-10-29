# 基于HOG和SVM的人脸口罩识别算法

#### 介绍
基于HOG和SVM的人脸口罩识别算法

#### 文件架构
文件架构说明：
HOGdescriptor.m ： 获取图像的HOG方向直方图
computeGradient.m : 计算传入图像每个像素点在x，y轴的梯度

drawRectangleImage.m ：在图像上绘制方形框图
gamma1.m : gamma校正算法

dection.m ：预测算法运行入口

guiTest.m : MatlabGUI界面生成

#### 使用说明

1.  在进行预测之前需要先对样本进行训练，使用trainImg.m中的函数，修改正负样本文件夹路径
2.  训练完毕后matlab会得到一个svm分类器
3.  修改dection.m中的函数，修改需要进行预测的图片路径以及预测结果路径，将svm分类器传入该方法执行

> 本项目绝大部分训练集来自：https://github.com/X-zhangyang/Real-World-Masked-Face-Dataset , 感谢开源者的提供

#### 参与贡献

<a href="https://gitee.com/xiyeye/">Iner</a>

<a href="https://gitee.com/peng_guangchuan">阿川</a>


#### 特殊说明
1.  由于个人原因，此算法的准确率不高，对于一些较为特殊的人像可能无法识别，所以仅供学习使用
2.  所使用的训练集样本存在瑕疵，可以自行根据算法运行结果调整训练集，以优化算法识别率
