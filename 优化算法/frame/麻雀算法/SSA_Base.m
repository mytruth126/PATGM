% ��ȸ�����㷨
classdef SSA_Base  < Algorithm_Impl
    
    properties
        % �㷨����
        name = 'SSA';

        ST = 0.8;
        % �����߱���
        PROD_rate = 1.0;
        % ����߱���
        SD_rate = 0.2;
        % ��ǰȺ�������λ��
        position_worst;
        % ��ǰȺ���������Ӧ��
        value_worst;
    end
    
    % �ⲿ�ɵ��õķ���
    methods
        function self = SSA_Base(dim,size,iter_max,range_min_list,range_max_list)
            % ���ø��๹�캯��
            self@Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list);
            self.name ='SSA';
        end
    end
    
    % �̳���д����ķ���
    methods (Access = protected)
        % ��ʼ����Ⱥ
        function init(self)
            init@Algorithm_Impl(self)
            %��ʼ����Ⱥ
            for i = 1:self.size
                unit = SSA_Unit();
                % �����ʼ��λ�ã�rand(0,1).*(max-min)+min
                unit.position = unifrnd(self.range_min_list,self.range_max_list);
                % ������Ӧ��ֵ
                unit.value = self.cal_fitfunction(unit.position);
                % ���������Ⱥ������
                self.unit_list = [self.unit_list,unit];
            end
        end
        
        % ÿһ���ĸ���
        function update(self,iter)
            update@Algorithm_Impl(self,iter)
            
            % ���ŵ�������
            [value,index] = sort([self.unit_list.value],'descend');
            self.position_worst = self.unit_list(index(end)).position;
            self.value_worst = self.unit_list(index(end)).value;
            
            for i = 1:self.size
                if(i<self.size*self.PROD_rate)
                    % �Ϻõĸ�����Ϊ������
                    self.update_producer(i,index);
                else
                    % ������Ϊ������
                    self.update_scrounger(i,index);
                end
            end
            
            % �������id
            id_list = randperm(self.size);
            for i = 1:floor(self.size*self.SD_rate)
                % ȡһ����������Ϊ�����
                self.update_perceive_danger(id_list(i))
            end
        end     
        
        % ���·�����
        function update_producer(self,i,index_list)
            id = index_list(i);
            if rand<self.ST
                new_pos = self.unit_list(id).position.*exp(-i./(unifrnd(0,1,1,self.dim)*self.iter_max));
                new_pos = self.get_out_bound_value(new_pos);
            else
                new_pos = self.unit_list(id).position + normrnd(0,1,1 ,self.dim);
                new_pos = self.get_out_bound_value(new_pos);
            end
            % �������ŵ�λ��
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        % ���¸�����
        function update_scrounger(self,i,index_list)
            id = index_list(i);
            if i > self.size/2
                new_pos = normrnd(0,1,1 ,self.dim).*exp((self.position_worst-self.unit_list(id).position)/(i^2));
                new_pos = self.get_out_bound_value(new_pos);
            else
                % ���ѡ��һ��������
                p_i = randperm(floor(self.size*self.SD_rate));
                p_id = index_list(p_i(1));
                rnd = unidrnd(2,1,self.dim)*2-3;
                sum_rnd = sum(rnd);
                new_pos = self.unit_list(p_id).position+(self.unit_list(id).position-self.unit_list(p_id).position)*sum_rnd/self.dim;
            end
             % �������ŵ�λ��
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        % ���������
        function update_perceive_danger(self,id)
            if self.unit_list(id).value < self.value_best
                new_pos = self.position_best+normrnd(0,1,1 ,self.dim).*self.unit_list(id).position;
                new_pos = self.get_out_bound_value(new_pos);
            else
                new_pos = self.unit_list(id).position + unifrnd(-1,1,1,self.dim).*(self.unit_list(id).position-self.position_worst)/(self.unit_list(id).value-self.value_worst+realmin('double'));
                new_pos = self.get_out_bound_value(new_pos);
            end

            % �������ŵ�λ��
            new_value = self.cal_fitfunction(new_pos);
            if(new_value > self.unit_list(id).value)
                self.unit_list(id).value = new_value;
                self.unit_list(id).position = new_pos;
            end
        end
        
        
        % ��ȡ��ǰ���Ÿ����id
        function best_id=get_best_id(self)
            % �����ֵ��������
            [value,index] = sort([self.unit_list.value],'descend');
            best_id = index(1);
        end
        
    end
end