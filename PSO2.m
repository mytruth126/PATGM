function [r_best,ERROR]=PSO()
%��ʼ������
fobj=@GM;
c1=0.02; %ѧϰ����1            
c2=0.02; %ѧϰ����2            
w=0.8; %��������,���Ķ�w����0.5��0.9�ı任             
MaxDT=500; %����������           
Pmin=0;%�����ռ�xȡֵ��Χ
Pmax=2;          
N=50; %��ʼ��Ⱥ�������Ŀ 
eps=10^(-6);%����ֹͣ׼�������            
%��ʼ����Ⱥ�ĸ���
for i=1:N
    x(i)=Pmin+rand*(Pmax-Pmin);  %��ʼ��λ��
    pBest(i)=x(i);
    v(i)=-1+2*rand();  %��ʼ�ٶ�������xֵ��Χ�ڰ�
end
gBest=1;
%��ʼ����Ӧ��
for i=1:N
    r=pBest(i);
    p(i)=fobj(r);%��Ӧ��ֵ������һ���ű��ļ������
end
pmin=min(p(i));
%Ѱ�ҳ�ʼ��Ⱥ�����λ��
for i=1:N
   if p(i)<=pmin
       gBest=x(i);
   end
end
   
  %������ѭ��������ֱ�����㾫��Ҫ��
  k=0;%��ʾ�Ѿ������Ĵ���
for t=1:MaxDT
    for i=1:N
        v(i)=w*v(i)+c1*rand*(pBest(i)-x(i))+c2*rand*(gBest-x(i));
        x(i)=x(i)+v(i);
        %������ӷɳ�����������������Ӽ���
        if x(i)>=Pmax||x(i)<=Pmin
            x(i)=Pmin+rand*(Pmax-Pmin);            
        else
        end  
        M(t,i)=x(i);%��Ⱥ��t��i����λ��
        Vti(t,i)=v(i);%��Ⱥ��t��i�����ٶ�
        r=x(i);
        tmp=fobj(r);
        if tmp<p(i)
            p(i)=tmp;
            pBest(i)=x(i);
        end
        if p(i)<pmin
            gBest=x(i);
            pmin=tmp;
        else
        end
    end
    w=0.9-0.4*t/MaxDT;
    k=k+1;
    if abs(max(p(i))-pmin)<eps
        break;
    end
end
r_best=gBest;
ERROR=pmin;

end