clear;clc;close all;warning off;
global X0 accumulation_method model_equation error_style n nf;
nf=2;
X=Input_data();X=X(:);X0=X(1:end-nf,:);
n=length(X)-nf;
X0F_ALL=[];
%% ģ��1
% ѡ��ģ�ͼ�����׼
accumulation_method='һ���ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='��ͳGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];
%% ģ��2
% ѡ��ģ�ͼ�����׼
accumulation_method='һ���ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='NDGM';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];

%% ģ��3
% ѡ��ģ�ͼ�����׼
accumulation_method='�������ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='��ͳGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];
%% ģ��4
% ѡ��ģ�ͼ�����׼
accumulation_method='CF�ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='��ͳGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];
%% ģ��5
% ѡ��ģ�ͼ�����׼
accumulation_method='�����ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='��ͳGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];
%% ģ��6
% ѡ��ģ�ͼ�����׼
accumulation_method='һ���ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='DGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
% ������
[r]=PSO2();
[MAPE,X0F]=GM(r);
X0F_ALL=[X0F_ALL,[MAPE;X0F]];
%% ��ͼ
%plot(X0F_ALL)
for i=1:size(X0F_ALL,2)
    mape(1,i)=[calculate_error(X(1:end-nf,:),X0F_ALL(2:end-nf,i))];
    mape(2,i)=[calculate_error(X(end-nf+1:end,:),X0F_ALL(end-nf+1:end,i))];
end    
result_all=[X0F_ALL(2:end,:);mape];