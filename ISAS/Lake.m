% ۶����ˮλģ��
% ����Ԥ��

function y=Lake(station,FiveRivers,Jiujiang,Level0)

% ���ݼ�����Ԥ����
load([num2str(station) '.mat']); %վ��ѡ��, 1=����; 2=����; 3=����; 4=���; 5=����; 6=��ɽ
dat_change=zeros(182,7);
dat_change(:,1:6)=[FiveRivers Jiujiang];
dat_change(1,7)=Level0;
level=dat_change(:,7);
level_pre=level; % ����Ԥ��ˮλ�ĳ�ʼֵ

% ��һ������
[num_r,num_c] = size(dat_raw);
data_in_1=zeros(num_r-1,num_c);
for i=1:num_r-1
    data_in_1(i,:) = [dat_raw(i+1,1:num_c-1) dat_raw(i,num_c)];% �ӵ�2�쿪ʼ
end
maxmin = [max(data_in_1);min(data_in_1)]; % ѵ��ģ��ʱ�������ݵ������Сֵ
[~,ps]=mapminmax(maxmin',0,1); % ��ȡ��һ������

%�����������
[num_r,num_c] = size(dat_change);
data_inp=zeros(num_r-1,num_c);
for i=1:num_r-1
    data_inp(i,:) = [dat_change(i+1,1:num_c-1) dat_change(i,num_c)];% �ӵ�2�쿪ʼ
end
data_inp=mapminmax('apply',data_inp',ps)';

for i=1:num_r-1
    [level_temp,~,~]=svmpredict(1,data_inp(i,:),model);% ���i+1���ˮλ
    level_pre(i+1)=level_temp; 
    dat_change(i+1,num_c)=level_temp; 
    if i<num_r-1
        data_inp(i+1,:) = [dat_change(i+2,1:num_c-1) dat_change(i+1,num_c)];% �õ���i+2��ˮλ����Ҫ����������
        data_inp(i+1,:)=mapminmax('apply',data_inp(i+1,:)',ps)';
    end    
end
y=level_pre;
end
