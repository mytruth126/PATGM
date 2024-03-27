clear;clc;close all;warning off;
global X0 accumulation_method model_equation error_style n nf;
nf=1;
X=Input_data();X=X(:);
n=5;
for i=1:numel(X)-n-nf+1
    X0_all(:,i)=X(i:i+n+nf-1,:);
end
for i=1:size(X0_all,2)
    X0=X0_all(1:end-nf,i);
    X0F_ALL=[];
    %% PAGM
    [r,ERROR]=PSO(@PAGM,0,8);
    [MAPE,X0F]=PAGM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% PATGM
    lb=[0,0,0];ub=[4,n/3,n/3];dim=3;fobj=@PATGM;
    % ��Ⱥ����
    po_size = 30;
    % ����������
    iter_max = 20;
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
    [ MAPE,X0F, W ] = PATGM( base.position_best );
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
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
    result(i,:)=X0F_ALL(end,:);
end
error_style='MAPE';
for i=1:size(result,2)
    mape(1,i)=[calculate_error(X(n+1:end,:),result(1:end,i))];
end