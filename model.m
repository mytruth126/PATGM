function [ XRF] = model( XR )
global model_equation n nf B Y P chuchu2;
switch model_equation
    case '选择模型结构'
        errordlg('请选择模型结构','File Open Error');%建立一个默认参数的错误对话框
        return
    case '传统GM(1,1)'
        [XRF B Y P]=EGM(XR, n, nf);
        chuchu2='刘思峰, 党耀国, 方志耕, 等. 灰色系统理论及其应用[M]. 北京：科学出版社.';
    case 'DGM(1,1)'
        [XRF B Y P]=DGM(XR, n, nf);
         chuchu2='谢乃明, 刘思峰. 离散GM(1,1)模型与灰色预测模型建模机理[J]. 系统工程理论与实践, 2005, 25(1): 93-99.';
    case 'NDGM'
        [XRF B Y P]=NDGM(XR, n, nf);
         chuchu2='朱超余, 谢乃明. NDGM模型的性质及预测效果分析[J]. 系统工程与电子技术, 2010, 32(09): 1915-1918.';
    case 'Verhulst'
        [XRF B Y P]=Verhulst(XR, n, nf);
        chuchu2='刘思峰, 党耀国, 方志耕, 等. 灰色系统理论及其应用[M]. 北京：科学出版社.';
    case '离散Verhulst'
        [XRF B Y P]=New_Discrete_Verhulst(XR, n, nf);
        chuchu2='邹国焱,魏勇.新离散verhulst模型的建模机理及其优化[J].系统工程,2019,37(06):139-147.';
    case '灰色幂模型'
        [XRF B Y P]=GPM(XR, n, nf);
        chuchu2='GM(1,1)幂模型求解方法及其解的性质_王正新.';
    case '灰色时间幂模型'
        [XRF B Y P]=GTPM(XR, n, nf);
        chuchu2='基于可重复性分数阶灰色时间幂模型的中国水电消费预测研究_周伟杰.';
    
end
end

function [XRF B Y P]=EGM(XR, n, nf)
%计算Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% 最小二乘法
% B和Y矩阵
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%计算系数
a=P(1);b=P(2);
%% 拟合
XRF(1,1)=XR(1);
for k=2:n+nf
    XRF(k,1)=(XRF(1)-b/a)*exp(-a*(k-1))+b/a;
end
end

function [XRF B Y P]=DGM(XR, n, nf)
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=XR(1:n-1,:);
Y(:,1)=XR(2:n,:);
P=inv(B'*B)*B'*Y;
a=P(1);b=P(2);
XRF(1,1)=XR(1);
u1=XRF(1)-b/(1-a);
u2=b/(1-a);
for i=2:n+nf
    XRF(i,1)=u1*a^(i-1)+u2;
end
end

function [XRF B Y P]=NDGM(XR, n, nf)
B=ones(n-1,3);
Y=ones(n-1,1);
B(:,1)=XR(1:n-1,:);
B(:,2)=[1:n-1]';
Y(:,1)=XR(2:n,:);
P=inv(B'*B)*B'*Y;
a=P(1);b=P(2);c=P(3);
XRF(1,1)=XR(1);
for i=2:n+nf
    XRF(i,1)=a*XRF(i-1)+b*(i-1)+c;
end
end

function [XRF B Y P]=Verhulst(XR, n, nf)
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
B(:,2)=Zr(:,1).^2;
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
a=P(1);b=P(2);
XRF(1,1)=XR(1);
for i=2:n+nf
    XRF(i,1)=a*XRF(1)/(b*XRF(1)+(a-b*XRF(1))*exp(a*(i-1)));
end
end

function [XRF B Y P]=New_Discrete_Verhulst(XR, n, nf)
XR=XR(:);
Y_k=1./XR;
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=Y_k(1:n-1,1);
Y(:,1)=Y_k(2:n,1);
P=inv(B'*B)*B'*Y;
a=P(1);b=P(2);
XRF(1,1)=XR(1);
for i=2:n+nf
    XRF(i,1)=1/(a^(i-1)*Y_k(1)+(1-a^(i-1))/(1-a)*b);
end
end

function [XRF B Y P]=GPM(XR, n, nf)
global Alpha1
%计算Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% 最小二乘法
% B和Y矩阵
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
B(:,2)=power(Zr(:,1),Alpha1);
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%计算系数
%% 拟合
a=P(1);b=P(2);
XRF(1,1)=XR(1);
for k=2:n+nf
    XRF(k,1)=power((power(XRF(1),(1-Alpha1))-b/a)*exp(-a*(k-1)*(1-Alpha1))+b/a,1/(1-Alpha1));
end
end

function [XRF B Y P]=GTPM(XR, n, nf)
global Alpha1
%计算Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% 最小二乘法
% B和Y矩阵
B=ones(n-1,3);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
B(:,2)=[2:n]'.^Alpha1;
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%计算系数
%% 拟合
a=P(1);b=P(2);c=P(3);
XRF(1,1)=XR(1);
F = @(x)exp(a.*x).*power(x,Alpha1);
%Q=@(x)(x^Alpha1*igamma(Alpha1 + 1, -a*x))/(a*(-a*x)^Alpha1);
for k=1:n+nf
    XRF(k,1)=b*exp(-a*k)*quad(F,1,k)+c/a*(1-exp(-a*(k-1)))+XR(1)*exp(-a*(k-1));
    %XRF(k,1)=b*exp(-a*k)*(Q(k)-Q(1))+c/a*(1-exp(-a*(k-1)))+XR(1)*exp(-a*(k-1));
end
end

