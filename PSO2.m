function [r_best,ERROR]=PSO()
%初始化参数
fobj=@GM;
c1=0.02; %学习因子1            
c2=0.02; %学习因子2            
w=0.8; %惯性因子,下文对w进行0.5至0.9的变换             
MaxDT=500; %最大迭代次数           
Pmin=0;%搜索空间x取值范围
Pmax=2;          
N=50; %初始化群体个体数目 
eps=10^(-6);%设置停止准则即满意解            
%初始化种群的个体
for i=1:N
    x(i)=Pmin+rand*(Pmax-Pmin);  %初始化位置
    pBest(i)=x(i);
    v(i)=-1+2*rand();  %初始速度限制在x值范围内吧
end
gBest=1;
%初始化适应度
for i=1:N
    r=pBest(i);
    p(i)=fobj(r);%适应度值，在另一个脚本文件中求解
end
pmin=min(p(i));
%寻找初始种群的最好位置
for i=1:N
   if p(i)<=pmin
       gBest=x(i);
   end
end
   
  %进入主循环，迭代直到满足精度要求
  k=0;%表示已经迭代的次数
for t=1:MaxDT
    for i=1:N
        v(i)=w*v(i)+c1*rand*(pBest(i)-x(i))+c2*rand*(gBest-x(i));
        x(i)=x(i)+v(i);
        %如果粒子飞出区域，随机生成新粒子加入
        if x(i)>=Pmax||x(i)<=Pmin
            x(i)=Pmin+rand*(Pmax-Pmin);            
        else
        end  
        M(t,i)=x(i);%种群中t代i粒子位置
        Vti(t,i)=v(i);%种群中t代i粒子速度
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