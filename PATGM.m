function [ mape, X0F, W ] = PATGM( param )
global n nf X0
r=param(1);
p=param(2);
q=param(3);
%% �ݼ����ۼ�
XR=cumsum(X0.^r);
%% ����ģ��
Y=[XR(2:end,1)-XR(1:end-1,1)]; % n-1��1����
tmp1=unique([0,p-floor(p):p]);
tmp2=[q-floor(q):q];
tmp2(:,all(tmp2==0,1))=[];
for i=1:n-1
    B(i,:)=[((i+1).^tmp1*XR(i+1,1)+(i).^tmp1*XR(i,1))/2,((i+1).^tmp2+(i).^tmp2)/2];
end
%% ������
[W2,FitInfo] = lasso(B,Y,'CV',min(10,floor(length(Y)/2)),'Alpha',0.5);
idxLambdaMinMSE = FitInfo.IndexMinMSE; % ѡ����СMSE�Ĳ�����
W=W2(:,idxLambdaMinMSE);
W=[W;FitInfo.Intercept(idxLambdaMinMSE)];
%% ���΢�ַ���
% ����ODE
ode = @(t, y) [t.^tmp1*y,t.^tmp2,1]*W;
% ���ó�ʼ����
initial_condition = XR(1);
% ����ʱ�䷶Χ
time_span = [1:n+nf];
% ʹ��ode45���ODE
[~, XRF] = ode45(ode, time_span, initial_condition);
% ��ԭ�۲�ֵ
X0F=[XRF(1);diff(XRF)].^(1/r);
% �������
mape=mean(abs((X0(1:n,:)-X0F(1:n,:))./X0(1:n,:)));
end

