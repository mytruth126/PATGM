% �������
classdef Unit< handle
    properties
        % �����λ��
        position;
        % �������Ӧ��ֵ
        value;
        % ��¼���е�λ��,��ͼ��
        position_history_list;
    end
    
    methods
        function self = Unit()
        end
        
        % ����ǰλ�ñ��浽position_history_list��
        function save(self)
            self.position_history_list=[self.position_history_list;self.position];
        end
    end
    
end