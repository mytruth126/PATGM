function [mape,X0F]=PAGM(r)
global  model_equation n nf X0
% �ݼ����ۼ�
XR=cumsum(X0.^r);
% ����ģ��
model_equation='��ͳGM(1,1)';
[ XRF] = model( XR );
% ��ԭ�۲�ֵ
X0F=[XRF(1);diff(XRF)].^(1/r);
% �������
mape=mean(abs((X0(1:n,:)-X0F(1:n,:))./X0(1:n,:)));
end






















