% 麻雀算法实现
classdef SSA_Impl < SSA_Base
    % 外部可调用的方法
    methods
        function self = SSA_Impl(dim,size,iter_max,range_min_list,range_max_list)
            % 调用父类构造函数设置参数
             self@SSA_Base(dim,size,iter_max,range_min_list,range_max_list);
        end
    end 
end 