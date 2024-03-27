% 麻雀搜索算法
classdef SSA_Base  < Algorithm_Impl
    
    properties
        % 算法名称
        name = 'SSA';

        ST = 0.8;
        % 发现者比例
        PROD_rate = 1.0;
        % 侦察者比例
        SD_rate = 0.2;
        % 当前群体中最差位置
        position_worst;
        % 当前群体中最差适应度
        value_worst;
    end
    
    % 外部可调用的方法
    methods
        function self = SSA_Base(dim,size,iter_max,range_min_list,range_max_list)
            % 调用父类构造函数
            self@Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list);
            self.name ='SSA';
        end
    end
    
    % 继承重写父类的方法
    methods (Access = protected)
        % 初始化种群
        function init(self)
            init@Algorithm_Impl(self)
            %初始化种群
            for i = 1:self.size
                unit = SSA_Unit();
                % 随机初始化位置：rand(0,1).*(max-min)+min
                unit.position = unifrnd(self.range_min_list,self.range_max_list);
                % 计算适应度值
                unit.value = self.cal_fitfunction(unit.position);
                % 将个体加入群体数组
                self.unit_list = [self.unit_list,unit];
            end
        end
        
        % 每一代的更新
        function update(self,iter)
            update@Algorithm_Impl(self,iter)
            
            % 从优到劣排序
            [value,index] = sort([self.unit_list.value],'descend');
            self.position_worst = self.unit_list(index(end)).position;
            self.value_worst = self.unit_list(index(end)).value;
            
            for i = 1:self.size
                if(i<self.size*self.PROD_rate)
                    % 较好的个体作为发现者
                    self.update_producer(i,index);
                else
                    % 其余作为跟随者
                    self.update_scrounger(i,index);
                end
            end
            
            % 随机乱序id
            id_list = randperm(self.size);
            for i = 1:floor(self.size*self.SD_rate)
                % 取一定比例的作为侦察者
                self.update_perceive_danger(id_list(i))
            end
        end     
        
        % 更新发现者
        function update_producer(self,i,index_list)
            id = index_list(i);
            if rand<self.ST
                new_pos = self.unit_list(id).position.*exp(-i./(unifrnd(0,1,1,self.dim)*self.iter_max));
                new_pos = self.get_out_bound_value(new_pos);
            else
                new_pos = self.unit_list(id).position + normrnd(0,1,1 ,self.dim);
                new_pos = self.get_out_bound_value(new_pos);
            end
            % 保留更优的位置
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        % 更新跟随者
        function update_scrounger(self,i,index_list)
            id = index_list(i);
            if i > self.size/2
                new_pos = normrnd(0,1,1 ,self.dim).*exp((self.position_worst-self.unit_list(id).position)/(i^2));
                new_pos = self.get_out_bound_value(new_pos);
            else
                % 随机选择一个发现者
                p_i = randperm(floor(self.size*self.SD_rate));
                p_id = index_list(p_i(1));
                rnd = unidrnd(2,1,self.dim)*2-3;
                sum_rnd = sum(rnd);
                new_pos = self.unit_list(p_id).position+(self.unit_list(id).position-self.unit_list(p_id).position)*sum_rnd/self.dim;
            end
             % 保留更优的位置
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        % 更新侦察者
        function update_perceive_danger(self,id)
            if self.unit_list(id).value < self.value_best
                new_pos = self.position_best+normrnd(0,1,1 ,self.dim).*self.unit_list(id).position;
                new_pos = self.get_out_bound_value(new_pos);
            else
                new_pos = self.unit_list(id).position + unifrnd(-1,1,1,self.dim).*(self.unit_list(id).position-self.position_worst)/(self.unit_list(id).value-self.value_worst+realmin('double'));
                new_pos = self.get_out_bound_value(new_pos);
            end

            % 保留更优的位置
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        
        % 获取当前最优个体的id
        function best_id=get_best_id(self)
            % 求最大值则降序排列
            [value,index] = sort([self.unit_list.value],'descend');
            best_id = index(1);
        end
        
    end
end