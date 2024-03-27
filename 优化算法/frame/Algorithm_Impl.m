% 优化算法基类
classdef Algorithm_Impl < handle
    properties

        %当前最优位置
        position_best;
        %当前最优适应度
        value_best;
        %历史最优适应度
        value_best_history;
        %历史最优位置
        position_best_history;
        %是否为求最大值,默认为是
        is_cal_max;
        %适应度函数，需要单独传入
        fitfunction;
        % 调用适应度函数次数
        cal_fit_num = 0;
    end
    properties(Access = protected)
        %维度
        dim;
        %种群中个体的数量
        size;
        %最大迭代次数
        iter_max;
        %解空间下界
        range_min_list;
        %解空间上界
        range_max_list;
        %种群列表
        unit_list;
    end
    
    methods
         % 运行，调用入口
        function run(self)
            tic
            self.init()
            self.iteration()
            toc
            disp(['运行时间: ',num2str(toc)]);

        end
        
        % 绘制动态图,2维图像
        function draw2_gif(self,step,is_save,name)
            if self.dim < 2
                disp('维度太低，无法绘制图像');
                return
            end
            if step < 1
                step = 1;
            end
            f1 = figure;
            % 遍历每一代
            for i = 1:self.iter_max
                % 如果不满足步长，则跳过
                if mod(i,step) > 0 && i>1
                    % 必须要绘制第一代，否则matlab会报错，原因未知
                    continue
                end
                % 遍历每一个个体
                for s = 1:self.size
                    cur_position = self.unit_list(s).position_history_list(i,:);
                    scatter(cur_position(1),cur_position(2),10,'b','filled');
                    hold on;
                end

                % 将文字绘制在左上角
                text(self.range_min_list(1),self.range_max_list(2),num2str(i),'FontSize',20);

                % 绘制显示区域
                range_size_x = self.range_max_list(1)-self.range_min_list(1);
                range_size_y = self.range_max_list(2)-self.range_min_list(2);
                axis([self.range_min_list(1)-0.2*range_size_x,self.range_max_list(1)+0.2*range_size_x, self.range_min_list(2)-0.2*range_size_y, self.range_max_list(2)+0.2*range_size_y]);

                axis equal;

                % 固定横纵坐标轴
                set(gca,'XLim',[self.range_min_list(1)-0.1*range_size_x self.range_max_list(1)+0.1*range_size_x]);
                set(gca,'YLim',[self.range_min_list(2)-0.1*range_size_y self.range_max_list(2)+0.1*range_size_y]);
                % 每0.1绘制一次
                pause = 0.1;
                % 需要保存git则设置is_save = true
                if is_save
                    %下面是保存为GIF的程序
                    frame=getframe(gcf);
                    % 返回单帧颜色图像
                    imind=frame2im(frame);
                    % 颜色转换
                    [imind,cm] = rgb2ind(imind,256);
                    filename = [name,'_2d.gif'];
                    if i==1
                         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1e-2);
                    else
                         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',pause);
                    end
                end
                % 绘制完就清除，绘制下一代
                clf;
            end
            % 绘制完成关闭窗口
            close(f1);    
        end
        
        % 绘制动态图,3维图像
        function draw3_gif(self,step,is_save,name)
            if self.dim < 3
                disp('维度太低，无法绘制三维图像');
                return
            end
            if step < 1
                step = 1;
            end
            f1 = figure;
            % 遍历每一代
            for i = 1:self.iter_max
                % 如果不满足步长，则跳过
                if mod(i,step) > 0 && i>1
                    % 必须要绘制第一代，否则matlab会报错，原因未知
                    continue
                end
                % 遍历每一个个体
                for s = 1:self.size
                    cur_position = self.unit_list(s).position_history_list(i,:);
                    scatter3(cur_position(1),cur_position(2),cur_position(3),10,'b','filled');
                    hold on;
                end

                % 将文字绘制在左上角
                text(self.range_min_list(1),self.range_max_list(2),self.range_max_list(3),num2str(i),'FontSize',20);

                % 绘制显示区域
                range_size_x = self.range_max_list(1)-self.range_min_list(1);
                range_size_y = self.range_max_list(2)-self.range_min_list(2);
                range_size_z = self.range_max_list(3)-self.range_min_list(3);
                axis([self.range_min_list(1)-0.2*range_size_x,self.range_max_list(1)+0.2*range_size_x, self.range_min_list(2)-0.2*range_size_y, self.range_max_list(2)+0.2*range_size_y,self.range_min_list(3)-0.2*range_size_z, self.range_max_list(3)+0.2*range_size_z]);

                axis equal;

                % 固定横纵坐标轴
                set(gca,'XLim',[self.range_min_list(1)-0.1*range_size_x self.range_max_list(1)+0.1*range_size_x]);
                set(gca,'YLim',[self.range_min_list(2)-0.1*range_size_y self.range_max_list(2)+0.1*range_size_y]);
                set(gca,'ZLim',[self.range_min_list(3)-0.1*range_size_z self.range_max_list(3)+0.1*range_size_z])
                % 每0.1绘制一次
                pause = 0.1;
                % 需要保存git则设置is_save = true
                if is_save
                    %下面是保存为GIF的程序
                    frame=getframe(gcf);
                    % 返回单帧颜色图像
                    imind=frame2im(frame);
                    % 颜色转换
                    [imind,cm] = rgb2ind(imind,256);
                    filename = [name,'_3d.gif'];
                    if i==1
                         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1e-2);
                    else
                         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',pause);
                    end
                end
                % 绘制完就清除，绘制下一代
                clf;
            end
            % 绘制完成关闭窗口
            close(f1);    
        end
    end
    
    methods (Access = protected)
        % 构造函数
        function self = Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list)
            self.dim =dim;
            self.size = size;
            self.iter_max = iter_max;
            self.range_min_list = range_min_list;
            self.range_max_list = range_max_list;
            %默认为求最大值
            self.is_cal_max = true;
        end
        
        % 初始化
        function init(self)
            self.position_best=zeros(1,self.dim);
            self.value_best_history=[];
            self.position_best_history=[];
            %设置初始最优值，由于是求最大值，所以设置了最大浮点数的负值
            self.value_best = -realmax('double');
        end
        
        % 开始迭代
        function iteration(self)
            for iter = 1:self.iter_max
                self.update(iter)
            end
        end
        
        % 处理一次迭代
        function update(self,iter)
            % 记录最优值
            for i = 1:self.size
                if(self.unit_list(i).value>self.value_best)
                    self.value_best = self.unit_list(i).value;
                    self.position_best = self.unit_list(i).position;
                end
                % 保存每一代的位置
                self.unit_list(i).save();
            end
            disp(['第' num2str(iter) '代']);
            if(self.is_cal_max)
                self.value_best_history(end+1) = self.value_best;
                disp(['最优值=' num2str(self.value_best)]);
            else
                self.value_best_history(end+1) = -self.value_best;
                disp(['最优值=' num2str(-self.value_best)]);
            end
            self.position_best_history = [self.position_best_history;self.position_best];
            disp(['最优解=' num2str(self.position_best)]);
        end
        
        function value = cal_fitfunction(self,position)
            if(isempty(self.fitfunction))
                value = 0;
            else
                % 如果适应度函数不为空则返回适应度值
                if(self.is_cal_max)
                    value = self.fitfunction(position);
                else
                    value = -self.fitfunction(position);
                end
            end
            self.cal_fit_num = self.cal_fit_num+1;
        end
        
        % 越界检查,超出边界则停留在边界上
        function s=get_out_bound_value(self,position,min_list,max_list)
          if(~exist('min_list','var'))
              min_list = self.range_min_list;
          end
          if(~exist('max_list','var'))
              max_list = self.range_max_list;
          end
          % Apply the lower bound vector
          position_tmp=position;
          I=position_tmp<min_list;
          position_tmp(I)=min_list(I);

          % Apply the upper bound vector
          J=position_tmp>max_list;
          position_tmp(J)=max_list(J);
          % Update this new move
          s=position_tmp;
        end
        
        % 越界检查,超出边界则在解空间内随机初始化
        function s=get_out_bound_value_rand(self,position,min_list,max_list)
          if(~exist('min_list','var'))
              min_list = self.range_min_list;
          end
          if(~exist('max_list','var'))
              max_list = self.range_max_list;
          end
          position_rand = unifrnd(self.range_min_list,self.range_max_list);
          % Apply the lower bound vector
          position_tmp=position;
          I=position_tmp<min_list;
          position_tmp(I)=position_rand(I);

          % Apply the upper bound vector
          J=position_tmp>max_list;
          position_tmp(J)=position_rand(J);
          % Update this new move
          s=position_tmp;
        end
        
        
    end

    events
    end
end