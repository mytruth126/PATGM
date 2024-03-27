%% ����֮ǰ������
% �����������
clear all;
close all;
% ����������
clc;
%% ���Ŀ¼
% ���ϼ�Ŀ¼�е�frame�ļ��м���·��
addpath('../frame')
%% ѡ����Ժ���
Function_name='F1';
%[��Сֵ�����ֵ��ά�ȣ����Ժ���]
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
%% �㷨ʵ��
% ��Ⱥ����
size = 50;
% ����������
iter_max = 1000;
% ȡֵ��Χ�Ͻ�
range_max_list = ones(1,dim).*ub;
% ȡֵ��Χ�½�
range_min_list = ones(1,dim).*lb;
% ʵ��������Ұ���㷨��
base = DOA_Impl(dim,size,iter_max,range_min_list,range_max_list);
base.is_cal_max = false;
% ȷ����Ӧ�Ⱥ���
base.fitfunction = fobj;
% ����
base.run();
disp(base.cal_fit_num);
%% ����ͼ��
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
% �������ߣ������㷨�������ֵ����Ӧ�Ⱥ���Ϊ����Сֵ���ʳ���-1����ʱȥ��-1
semilogy((base.value_best_history),'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
% �����������Ϊ������
axis tight
% �������
grid on
% �ı߶���ʾ�̶�
box off
legend(base.name)
display(['The best solution obtained by ',base.name ,' is ', num2str(base.value_best)]);
display(['The best optimal value of the objective funciton found by ',base.name ,' is ', num2str(base.position_best)]);