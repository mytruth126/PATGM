function [ ERROR,X0F ] = GM( r )
%GM 此处显示有关此函数的摘要
%   此处显示详细说明
global X0 n nf XR XRF;

%% 计算累加矩阵
D=accumulation(n+nf,r);

%% 生成累加序列
if size(X0,1)==1
    X0=X0';
end
XR=D(1:n,1:n)*X0;

%% 拟合计算
XRF=model(XR);

%% 还原预测结果
X0F=D\XRF;

%% 计算拟合误差
ERROR=calculate_error(X0,X0F);

end

