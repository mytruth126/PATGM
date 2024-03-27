% 非洲野狗算法
classdef DOA_Base  < Algorithm_Impl
    
    properties
        % 算法名称
        name = 'DOA';
        
        P = 0.5;
    
        Q = 0.7;
    
        % 随机id区间
        na_ini;
        na_end;
      
    end
    
    % 外部可调用的方法
    methods
        function self = DOA_Base(dim,size,iter_max,range_min_list,range_max_list)
            % 调用父类构造函数
            self@Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list);
            self.name ='DOA';
            self.na_ini = 2;
            self.na_end = floor(self.size/2);
        end
    end
    
    % 继承重写父类的方法
    methods (Access = protected)
        % 初始化种群
        function init(self)
            init@Algorithm_Impl(self)
            %初始化种群
            for i = 1:self.size
                unit = DOA_Unit();
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
            
            % 更新存活率
            self.update_survival_rate();
            
            self.update_position();
        end
        
        % 计算存活率
        function update_survival_rate(self)
            [value,index] = sort([self.unit_list.value],'descend');
            for i = 1:self.size
                % 根据是适应度函数计算存活率
                survival_rate = abs(value(1) - self.unit_list(i).value)/abs(value(1)-value(end))+realmin('double');
                self.unit_list(i).survival_rate=survival_rate;
            end
        end
        
        function update_position(self)
            % 获取随机个体
            na = randi([self.na_ini,self.na_end]);
            for i = 1:self.size
                beta1 = unifrnd(-2, 2);
                beta2 = unifrnd(-1, 1);
                if rand<self.P
                    if rand<self.Q
                        pos_sumatory = self.get_sumatory(na,i);
                        new_pos = pos_sumatory*beta1 - self.position_best;
                    else
                        % 随机选择1个个体
                        r_id = randi(self.size);
                        new_pos = self.position_best + beta1*exp(beta2)*(self.unit_list(r_id).position-self.unit_list(i).position);
                    end
                else
                    % 随机选择1个个体
                    r_id = randi(self.size);
                    binary = 1;
                    if rand<0.5
                        binary = -1;
                    end
                    new_pos = (exp(beta2)*self.unit_list(r_id).position+binary*self.unit_list(i).position)/2;
                end
                
                if(self.unit_list(i).survival_rate<0.3)
                    % 随机选择2个个体
                    r_id1 = randi(self.size);
                    r_id2 = randi(self.size);
                    binary = 1;
                    if rand<0.5
                        binary = -1;
                    end
                    new_pos = self.position_best + (self.unit_list(r_id1).position+binary*self.unit_list(r_id2).position)/2;
                end
                 % 越界检查，越界后再解空间随机
                new_pos = self.get_out_bound_value(new_pos);
                new_value = self.cal_fitfunction(new_pos);
                if new_value > self.unit_list(i).value
                    self.unit_list(i).position = new_pos;
                    self.unit_list(i).value = new_value;
                end
            end
        end
        
        
        % 获取群体的平均位置
        function pos_sumatory = get_sumatory(self,na,id)
            % 随机排列id
            A = randperm(self.size);
            % 取前na+1个id
            r_ids = A(1:na+1);
            % 移除列表中值为id的元素
            r_ids(r_ids==id)=[];
            pos_sumatory = zeros(1,self.dim);
            for i = 1:length(r_ids)
                pos_sumatory = pos_sumatory + self.unit_list(id).position-self.unit_list(r_ids(i)).position;
            end  
            pos_sumatory = pos_sumatory/length(r_ids);
        end
        
        % 获取当前最优个体的id
        function best_id=get_best_id(self)
            % 求最大值则降序排列
            [value,index] = sort([self.unit_list.value],'descend');
            best_id = index(1);
        end

    end
end

function o=Levy(d)
beta=1.5;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
o=step;
end