function [ XRF] = model( XR )
global model_equation n nf B Y P chuchu2;
switch model_equation
    case 'ѡ��ģ�ͽṹ'
        errordlg('��ѡ��ģ�ͽṹ','File Open Error');%����һ��Ĭ�ϲ����Ĵ���Ի���
        return
    case '��ͳGM(1,1)'
        [XRF B Y P]=EGM(XR, n, nf);
        chuchu2='��˼��, ��ҫ��, ��־��, ��. ��ɫϵͳ���ۼ���Ӧ��[M]. ��������ѧ������.';
    case 'DGM(1,1)'
        [XRF B Y P]=DGM(XR, n, nf);
         chuchu2='л����, ��˼��. ��ɢGM(1,1)ģ�����ɫԤ��ģ�ͽ�ģ����[J]. ϵͳ����������ʵ��, 2005, 25(1): 93-99.';
    case 'NDGM'
        [XRF B Y P]=NDGM(XR, n, nf);
         chuchu2='�쳬��, л����. NDGMģ�͵����ʼ�Ԥ��Ч������[J]. ϵͳ��������Ӽ���, 2010, 32(09): 1915-1918.';
    case 'Verhulst'
        [XRF B Y P]=Verhulst(XR, n, nf);
        chuchu2='��˼��, ��ҫ��, ��־��, ��. ��ɫϵͳ���ۼ���Ӧ��[M]. ��������ѧ������.';
    case '��ɢVerhulst'
        [XRF B Y P]=New_Discrete_Verhulst(XR, n, nf);
        chuchu2='�޹���,κ��.����ɢverhulstģ�͵Ľ�ģ�������Ż�[J].ϵͳ����,2019,37(06):139-147.';
    case '��ɫ��ģ��'
        [XRF B Y P]=GPM(XR, n, nf);
        chuchu2='GM(1,1)��ģ����ⷽ������������_������.';
    case '��ɫʱ����ģ��'
        [XRF B Y P]=GTPM(XR, n, nf);
        chuchu2='���ڿ��ظ��Է����׻�ɫʱ����ģ�͵��й�ˮ������Ԥ���о�_��ΰ��.';
    
end
end

function [XRF B Y P]=EGM(XR, n, nf)
%����Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% ��С���˷�
% B��Y����
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%����ϵ��
a=P(1);b=P(2);
%% ���
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
%����Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% ��С���˷�
% B��Y����
B=ones(n-1,2);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
B(:,2)=power(Zr(:,1),Alpha1);
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%����ϵ��
%% ���
a=P(1);b=P(2);
XRF(1,1)=XR(1);
for k=2:n+nf
    XRF(k,1)=power((power(XRF(1),(1-Alpha1))-b/a)*exp(-a*(k-1)*(1-Alpha1))+b/a,1/(1-Alpha1));
end
end

function [XRF B Y P]=GTPM(XR, n, nf)
global Alpha1
%����Z
Zr=(XR(1:n-1,:)+XR(2:n,:))/2;
%% ��С���˷�
% B��Y����
B=ones(n-1,3);
Y=ones(n-1,1);
B(:,1)=-Zr(:,1);
B(:,2)=[2:n]'.^Alpha1;
Y(:,1)=XR(2:n,:)-XR(1:n-1,:);
P=inv(B'*B)*B'*Y;
%����ϵ��
%% ���
a=P(1);b=P(2);c=P(3);
XRF(1,1)=XR(1);
F = @(x)exp(a.*x).*power(x,Alpha1);
%Q=@(x)(x^Alpha1*igamma(Alpha1 + 1, -a*x))/(a*(-a*x)^Alpha1);
for k=1:n+nf
    XRF(k,1)=b*exp(-a*k)*quad(F,1,k)+c/a*(1-exp(-a*(k-1)))+XR(1)*exp(-a*(k-1));
    %XRF(k,1)=b*exp(-a*k)*(Q(k)-Q(1))+c/a*(1-exp(-a*(k-1)))+XR(1)*exp(-a*(k-1));
end
end

