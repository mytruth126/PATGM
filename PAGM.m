function [mape,X0F]=PAGM(r)
global  model_equation n nf X0
% 幂级数累加
XR=cumsum(X0.^r);
% 构建模型
model_equation='传统GM(1,1)';
[ XRF] = model( XR );
% 还原观测值
X0F=[XRF(1);diff(XRF)].^(1/r);
% 计算误差
mape=mean(abs((X0(1:n,:)-X0F(1:n,:))./X0(1:n,:)));
end






















