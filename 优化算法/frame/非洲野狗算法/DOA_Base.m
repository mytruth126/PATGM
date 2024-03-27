% ����Ұ���㷨
classdef DOA_Base  < Algorithm_Impl
    
    properties
        % �㷨����
        name = 'DOA';
        
        P = 0.5;
    
        Q = 0.7;
    
        % ���id����
        na_ini;
        na_end;
      
    end
    
    % �ⲿ�ɵ��õķ���
    methods
        function self = DOA_Base(dim,size,iter_max,range_min_list,range_max_list)
            % ���ø��๹�캯��
            self@Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list);
            self.name ='DOA';
            self.na_ini = 2;
            self.na_end = floor(self.size/2);
        end
    end
    
    % �̳���д����ķ���
    methods (Access = protected)
        % ��ʼ����Ⱥ
        function init(self)
            init@Algorithm_Impl(self)
            %��ʼ����Ⱥ
            for i = 1:self.size
                unit = DOA_Unit();
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
            
            % ���´����
            self.update_survival_rate();
            
            self.update_position();
        end
        
        % ��������
        function update_survival_rate(self)
            [value,index] = sort([self.unit_list.value],'descend');
            for i = 1:self.size
                % ��������Ӧ�Ⱥ�����������
                survival_rate = abs(value(1) - self.unit_list(i).value)/abs(value(1)-value(end))+realmin('double');
                self.unit_list(i).survival_rate=survival_rate;
            end
        end
        
        function update_position(self)
            % ��ȡ�������
            na = randi([self.na_ini,self.na_end]);
            for i = 1:self.size
                beta1 = unifrnd(-2, 2);
                beta2 = unifrnd(-1, 1);
                if rand<self.P
                    if rand<self.Q
                        pos_sumatory = self.get_sumatory(na,i);
                        new_pos = pos_sumatory*beta1 - self.position_best;
                    else
                        % ���ѡ��1������
                        r_id = randi(self.size);
                        new_pos = self.position_best + beta1*exp(beta2)*(self.unit_list(r_id).position-self.unit_list(i).position);
                    end
                else
                    % ���ѡ��1������
                    r_id = randi(self.size);
                    binary = 1;
                    if rand<0.5
                        binary = -1;
                    end
                    new_pos = (exp(beta2)*self.unit_list(r_id).position+binary*self.unit_list(i).position)/2;
                end
                
                if(self.unit_list(i).survival_rate<0.3)
                    % ���ѡ��2������
                    r_id1 = randi(self.size);
                    r_id2 = randi(self.size);
                    binary = 1;
                    if rand<0.5
                        binary = -1;
                    end
                    new_pos = self.position_best + (self.unit_list(r_id1).position+binary*self.unit_list(r_id2).position)/2;
                end
                 % Խ���飬Խ����ٽ�ռ����
                new_pos = self.get_out_bound_value(new_pos);
                new_value = self.cal_fitfunction(new_pos);
                if new_value > self.unit_list(i).value
                    self.unit_list(i).position = new_pos;
                    self.unit_list(i).value = new_value;
                end
            end
        end
        
        
        % ��ȡȺ���ƽ��λ��
        function pos_sumatory = get_sumatory(self,na,id)
            % �������id
            A = randperm(self.size);
            % ȡǰna+1��id
            r_ids = A(1:na+1);
            % �Ƴ��б���ֵΪid��Ԫ��
            r_ids(r_ids==id)=[];
            pos_sumatory = zeros(1,self.dim);
            for i = 1:length(r_ids)
                pos_sumatory = pos_sumatory + self.unit_list(id).position-self.unit_list(r_ids(i)).position;
            end  
            pos_sumatory = pos_sumatory/length(r_ids);
        end
        
        % ��ȡ��ǰ���Ÿ����id
        function best_id=get_best_id(self)
            % �����ֵ��������
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