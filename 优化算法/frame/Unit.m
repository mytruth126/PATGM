% 个体基类
classdef Unit< handle
    properties
        % 个体的位置
        position;
        % 个体的适应度值
        value;
        % 记录所有的位置,画图用
        position_history_list;
    end
    
    methods
        function self = Unit()
        end
        
        % 将当前位置保存到position_history_list中
        function save(self)
            self.position_history_list=[self.position_history_list;self.position];
        end
    end
    
end