function [ ERROR,X0F ] = GM( r )
%GM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global X0 n nf XR XRF;

%% �����ۼӾ���
D=accumulation(n+nf,r);

%% �����ۼ�����
if size(X0,1)==1
    X0=X0';
end
XR=D(1:n,1:n)*X0;

%% ��ϼ���
XRF=model(XR);

%% ��ԭԤ����
X0F=D\XRF;

%% ����������
ERROR=calculate_error(X0,X0F);

end

