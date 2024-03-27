%% 清理之前的数据
% 清除所有数据
clear all;
close all;
% 清除窗口输出
clc;
%% 添加目录
% 将上级目录中的frame文件夹加入路径
addpath('../frame')
%% 选择测试函数
Function_name='F1';
%[最小值，最大值，维度，测试函数]
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
%% 算法实例
% 种群数量
size = 50;
% 最大迭代次数
iter_max = 1000;
% 取值范围上界
range_max_list = ones(1,dim).*ub;
% 取值范围下界
range_min_list = ones(1,dim).*lb;
% 实例化非洲野狗算法类
base = DOA_Impl(dim,size,iter_max,range_min_list,range_max_list);
base.is_cal_max = false;
% 确定适应度函数
base.fitfunction = fobj;
% 运行
base.run();
disp(base.cal_fit_num);
%% 绘制图像
figure('Position',[500 500 660 290])
%Draw search space
subplot(1,2,1);
func_plot(Function_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])
%Draw objective space
subplot(1,2,2);
% 绘制曲线，由于算法是求最大值，适应度函数为求最小值，故乘了-1，此时去掉-1
semilogy((base.value_best_history),'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
% 将坐标轴调整为紧凑型
axis tight
% 添加网格
grid on
% 四边都显示刻度
box off
legend(base.name)
display(['The best solution obtained by ',base.name ,' is ', num2str(base.value_best)]);
display(['The best optimal value of the objective funciton found by ',base.name ,' is ', num2str(base.position_best)]);