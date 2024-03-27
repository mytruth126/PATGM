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
    % 种群数量
    po_size = 30;
    % 最大迭代次数
    iter_max = 20;
    % 取值范围上界
    range_max_list = ones(1,dim).*ub;
    % 取值范围下界
    range_min_list = ones(1,dim).*lb;
    % 实例化非洲野狗算法类
    base = DOA_Impl(dim,po_size,iter_max,range_min_list,range_max_list);
    base.is_cal_max = false; %求最大值或最小值
    % 确定适应度函数
    base.fitfunction = fobj;
    % 运行
    base.run();
    disp(base.cal_fit_num);
    [ MAPE,X0F, W ] = PATGM( base.position_best );
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% 模型1
    % 选择模型及误差标准
    accumulation_method='一阶累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='传统GM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% 模型2
    % 选择模型及误差标准
    accumulation_method='一阶累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='NDGM';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    
    %% 模型3
    % 选择模型及误差标准
    accumulation_method='分数阶累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='传统GM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% 模型4
    % 选择模型及误差标准
    accumulation_method='CF累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='传统GM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% 模型5
    % 选择模型及误差标准
    accumulation_method='阻尼累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='传统GM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    %% 模型6
    % 选择模型及误差标准
    accumulation_method='一阶累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
    model_equation='DGM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
    error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
    % 计算结果
    [r]=PSO2();
    [MAPE,X0F]=GM(r);
    X0F_ALL=[X0F_ALL,[MAPE;X0F]];
    result(i,:)=X0F_ALL(end,:);
end
error_style='MAPE';
for i=1:size(result,2)
    mape(1,i)=[calculate_error(X(n+1:end,:),result(1:end,i))];
end