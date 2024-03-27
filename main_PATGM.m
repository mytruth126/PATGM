clear;clc;close all;warning off;
global nf n X0 error_style
nf=2; % Verification set size
X=Input_data();X=X(:);X0=X(1:end-nf,:);
n=length(X)-nf;
%% PATGM by Dingo
addpath(genpath('�Ż��㷨'))
tic
lb=[0,0,0];ub=[4,n/3,n/3];dim=3;fobj=@PATGM;
% ��Ⱥ����
po_size = 30;
% ����������
iter_max = 30;
% ȡֵ��Χ�Ͻ�
range_max_list = ones(1,dim).*ub;
% ȡֵ��Χ�½�
range_min_list = ones(1,dim).*lb;
% ʵ��������Ұ���㷨��
base = DOA_Impl(dim,po_size,iter_max,range_min_list,range_max_list);
base.is_cal_max = false; %�����ֵ����Сֵ
% ȷ����Ӧ�Ⱥ���
base.fitfunction = fobj;
% ����
base.run();
disp(base.cal_fit_num);
% save base;
toc
[ mape2, X0F2, W ] = PATGM( base.position_best );
%%
X0F_ALL=[X0F2];
%plot(X0F_ALL)
error_style='MAPE';
for i=1:size(X0F_ALL,2)
    mape(1,i)=[calculate_error(X(1:end-nf,:),X0F_ALL(1:end-nf,i))];
    mape(2,i)=[calculate_error(X(end-nf+1:end,:),X0F_ALL(end-nf+1:end,i))];
end    
result_all=[X0F_ALL(1:end,:);mape];



