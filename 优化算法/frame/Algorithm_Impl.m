% �Ż��㷨����
classdef Algorithm_Impl < handle
    properties

        %��ǰ����λ��
        position_best;
        %��ǰ������Ӧ��
        value_best;
        %��ʷ������Ӧ��
        value_best_history;
        %��ʷ����λ��
        position_best_history;
        %�Ƿ�Ϊ�����ֵ,Ĭ��Ϊ��
        is_cal_max;
        %��Ӧ�Ⱥ�������Ҫ��������
        fitfunction;
        % ������Ӧ�Ⱥ�������
        cal_fit_num = 0;
    end
    properties(Access = protected)
        %ά��
        dim;
        %��Ⱥ�и��������
        size;
        %����������
        iter_max;
        %��ռ��½�
        range_min_list;
        %��ռ��Ͻ�
        range_max_list;
        %��Ⱥ�б�
        unit_list;
    end
    
    methods
         % ���У��������
        function run(self)
            tic
            self.init()
            self.iteration()
            toc
            disp(['����ʱ��: ',num2str(toc)]);

        end
        
        % ���ƶ�̬ͼ,2άͼ��
        function draw2_gif(self,step,is_save,name)
            if self.dim < 2
                disp('ά��̫�ͣ��޷�����ͼ��');
                return
            end
            if step < 1
                step = 1;
            end
            f1 = figure;
            % ����ÿһ��
            for i = 1:self.iter_max
                % ��������㲽����������
                if mod(i,step) > 0 && i>1
                    % ����Ҫ���Ƶ�һ��������matlab�ᱨ��ԭ��δ֪
                    continue
                end
                % ����ÿһ������
                for s = 1:self.size
                    cur_position = self.unit_list(s).position_history_list(i,:);
                    scatter(cur_position(1),cur_position(2),10,'b','filled');
                    hold on;
                end

                % �����ֻ��������Ͻ�
                text(self.range_min_list(1),self.range_max_list(2),num2str(i),'FontSize',20);

                % ������ʾ����
                range_size_x = self.range_max_list(1)-self.range_min_list(1);
                range_size_y = self.range_max_list(2)-self.range_min_list(2);
                axis([self.range_min_list(1)-0.2*range_size_x,self.range_max_list(1)+0.2*range_size_x, self.range_min_list(2)-0.2*range_size_y, self.range_max_list(2)+0.2*range_size_y]);

                axis equal;

                % �̶�����������
                set(gca,'XLim',[self.range_min_list(1)-0.1*range_size_x self.range_max_list(1)+0.1*range_size_x]);
                set(gca,'YLim',[self.range_min_list(2)-0.1*range_size_y self.range_max_list(2)+0.1*range_size_y]);
                % ÿ0.1����һ��
                pause = 0.1;
                % ��Ҫ����git������is_save = true
                if is_save
                    %�����Ǳ���ΪGIF�ĳ���
                    frame=getframe(gcf);
                    % ���ص�֡��ɫͼ��
                    imind=frame2im(frame);
                    % ��ɫת��
                    [imind,cm] = rgb2ind(imind,256);
                    filename = [name,'_2d.gif'];
                    if i==1
                         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1e-2);
                    else
                         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',pause);
                    end
                end
                % ������������������һ��
                clf;
            end
            % ������ɹرմ���
            close(f1);    
        end
        
        % ���ƶ�̬ͼ,3άͼ��
        function draw3_gif(self,step,is_save,name)
            if self.dim < 3
                disp('ά��̫�ͣ��޷�������άͼ��');
                return
            end
            if step < 1
                step = 1;
            end
            f1 = figure;
            % ����ÿһ��
            for i = 1:self.iter_max
                % ��������㲽����������
                if mod(i,step) > 0 && i>1
                    % ����Ҫ���Ƶ�һ��������matlab�ᱨ��ԭ��δ֪
                    continue
                end
                % ����ÿһ������
                for s = 1:self.size
                    cur_position = self.unit_list(s).position_history_list(i,:);
                    scatter3(cur_position(1),cur_position(2),cur_position(3),10,'b','filled');
                    hold on;
                end

                % �����ֻ��������Ͻ�
                text(self.range_min_list(1),self.range_max_list(2),self.range_max_list(3),num2str(i),'FontSize',20);

                % ������ʾ����
                range_size_x = self.range_max_list(1)-self.range_min_list(1);
                range_size_y = self.range_max_list(2)-self.range_min_list(2);
                range_size_z = self.range_max_list(3)-self.range_min_list(3);
                axis([self.range_min_list(1)-0.2*range_size_x,self.range_max_list(1)+0.2*range_size_x, self.range_min_list(2)-0.2*range_size_y, self.range_max_list(2)+0.2*range_size_y,self.range_min_list(3)-0.2*range_size_z, self.range_max_list(3)+0.2*range_size_z]);

                axis equal;

                % �̶�����������
                set(gca,'XLim',[self.range_min_list(1)-0.1*range_size_x self.range_max_list(1)+0.1*range_size_x]);
                set(gca,'YLim',[self.range_min_list(2)-0.1*range_size_y self.range_max_list(2)+0.1*range_size_y]);
                set(gca,'ZLim',[self.range_min_list(3)-0.1*range_size_z self.range_max_list(3)+0.1*range_size_z])
                % ÿ0.1����һ��
                pause = 0.1;
                % ��Ҫ����git������is_save = true
                if is_save
                    %�����Ǳ���ΪGIF�ĳ���
                    frame=getframe(gcf);
                    % ���ص�֡��ɫͼ��
                    imind=frame2im(frame);
                    % ��ɫת��
                    [imind,cm] = rgb2ind(imind,256);
                    filename = [name,'_3d.gif'];
                    if i==1
                         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1e-2);
                    else
                         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',pause);
                    end
                end
                % ������������������һ��
                clf;
            end
            % ������ɹرմ���
            close(f1);    
        end
    end
    
    methods (Access = protected)
        % ���캯��
        function self = Algorithm_Impl(dim,size,iter_max,range_min_list,range_max_list)
            self.dim =dim;
            self.size = size;
            self.iter_max = iter_max;
            self.range_min_list = range_min_list;
            self.range_max_list = range_max_list;
            %Ĭ��Ϊ�����ֵ
            self.is_cal_max = true;
        end
        
        % ��ʼ��
        function init(self)
            self.position_best=zeros(1,self.dim);
            self.value_best_history=[];
            self.position_best_history=[];
            %���ó�ʼ����ֵ�������������ֵ��������������󸡵����ĸ�ֵ
            self.value_best = -realmax('double');
        end
        
        % ��ʼ����
        function iteration(self)
            for iter = 1:self.iter_max
                self.update(iter)
            end
        end
        
        % ����һ�ε���
        function update(self,iter)
            % ��¼����ֵ
            for i = 1:self.size
                if(self.unit_list(i).value>self.value_best)
                    self.value_best = self.unit_list(i).value;
                    self.position_best = self.unit_list(i).position;
                end
                % ����ÿһ����λ��
                self.unit_list(i).save();
            end
            disp(['��' num2str(iter) '��']);
            if(self.is_cal_max)
                self.value_best_history(end+1) = self.value_best;
                disp(['����ֵ=' num2str(self.value_best)]);
            else
                self.value_best_history(end+1) = -self.value_best;
                disp(['����ֵ=' num2str(-self.value_best)]);
            end
            self.position_best_history = [self.position_best_history;self.position_best];
            disp(['���Ž�=' num2str(self.position_best)]);
        end
        
        function value = cal_fitfunction(self,position)
            if(isempty(self.fitfunction))
                value = 0;
            else
                % �����Ӧ�Ⱥ�����Ϊ���򷵻���Ӧ��ֵ
                if(self.is_cal_max)
                    value = self.fitfunction(position);
                else
                    value = -self.fitfunction(position);
                end
            end
            self.cal_fit_num = self.cal_fit_num+1;
        end
        
        % Խ����,�����߽���ͣ���ڱ߽���
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
        
        % Խ����,�����߽����ڽ�ռ��������ʼ��
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