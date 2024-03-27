function [ mape, X0F, W ] = PATGM( param )
global n nf X0
r=param(1);
p=param(2);
q=param(3);
%% 幂级数累加
XR=cumsum(X0.^r);
%% 构建模型
Y=[XR(2:end,1)-XR(1:end-1,1)]; % n-1×1矩阵
tmp1=unique([0,p-floor(p):p]);
tmp2=[q-floor(q):q];
tmp2(:,all(tmp2==0,1))=[];
for i=1:n-1
    B(i,:)=[((i+1).^tmp1*XR(i+1,1)+(i).^tmp1*XR(i,1))/2,((i+1).^tmp2+(i).^tmp2)/2];
end
%% 求解参数
[W2,FitInfo] = lasso(B,Y,'CV',min(10,floor(length(Y)/2)),'Alpha',0.5);
idxLambdaMinMSE = FitInfo.IndexMinMSE; % 选择最小MSE的参数组
W=W2(:,idxLambdaMinMSE);
W=[W;FitInfo.Intercept(idxLambdaMinMSE)];
%% 求解微分方程
% 定义ODE
ode = @(t, y) [t.^tmp1*y,t.^tmp2,1]*W;
% 设置初始条件
initial_condition = XR(1);
% 定义时间范围
time_span = [1:n+nf];
% 使用ode45求解ODE
[~, XRF] = ode45(ode, time_span, initial_condition);
% 还原观测值
X0F=[XRF(1);diff(XRF)].^(1/r);
% 计算误差
mape=mean(abs((X0(1:n,:)-X0F(1:n,:))./X0(1:n,:)));
end

