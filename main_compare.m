clear;clc;close all;warning off;
global X0 accumulation_method model_equation error_style n nf;
nf=2;
X=Input_data();X=X(:);X0=X(1:end-nf,:);
n=length(X)-nf;
X0F_ALL=[];
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
%% 画图
%plot(X0F_ALL)
for i=1:size(X0F_ALL,2)
    mape(1,i)=[calculate_error(X(1:end-nf,:),X0F_ALL(2:end-nf,i))];
    mape(2,i)=[calculate_error(X(end-nf+1:end,:),X0F_ALL(end-nf+1:end,i))];
end    
result_all=[X0F_ALL(2:end,:);mape];