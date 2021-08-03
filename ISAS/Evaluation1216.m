
% ����Ч����������������Ŀ�꺯��MOP2
% ������Ҫ�����վ���޸�station��level0�ĸ�ֵ

% ���ڹ��������� x=0; Ȼ��x��ֵΪˮ��ˮλ���
% ���ݵ������޸�Conditionyear

x=[154.5
159.9600959
163.9788538
166.8230544
170.9554321
172.9237815
175
175
174.9437687
174.9991434
175
174.9702677
174.9986815
174.901454
174.9734804
174.9304837
175
174.9527132
174.985154
174.8686283
174.9956447
174.831612
174.9399392
173.9597671
172.977819
171.9597385
170.9679686
168.9398756
167.8670076
165.8820952
164.8420624
163.9702116
161.9818974
160.9333414
158.9864035
157.9390497
155
    ];

global VarMin_B;
global VarMax_B;
global qinsanxia;
global day;

day=[5 5 5 5 5 6, 5 5 5 5 5 5, 5 5 5 5 5 6, 5 5 5 5 5 6, 5 5 5 5 5 3, 5 5 5 5 5 6]; % ÿ������ʱ�ΰ���������
nVar=36+1;             % Number of Decision Variables %ˮ���10�¿�ʼ������3�£�5��Ϊһ��ʱ�Σ���36��ʱ�Σ�ˮλ��37����
VarSize=[1 nVar];    % Size of Decision Variables Matrix
ConditionYear=1;     % ѡ������ꡣ1=��ˮ�꣬2=ƽˮ�꣬3=��ˮ��
load DataInSanxia.mat
qinsanxia=Qinsanxia(:,ConditionYear);% ��Ͽˮ�����������WLQS�����л��õ�������Ϊʱ��ƽ��ֵ����36����
VarMin_B=VarMin;VarMax_B=VarMax;% VarMinΪˮλ������Լ����VarMin_BΪˮλ�ı߽�Լ��,��ʵ��Լ��

load DataInM.mat; % ����ģ�ͱ߽�,��Ҫ����վ���޸ĵ��� station��level0
station=2;
level0=14.61;

[qoutsanxia1,zdownsanxia1,s1,s2]=WLQS(x); % ����ˮ�����й����������ˮλ

%% �������
%��Ͽ���鵥�������������966.0m3/s[190]��32̨���������й����Ϊ30912m3/s������������������30912m3/sʱ�����ಿ��Ϊ��ˮ���ο�����ȫ��ʿ����
N=zeros(36,1); %��ʱ�εĳ���
for i=1:36
    N(i)=((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933;
end

%% ����۶����ˮλ
qoutsanxia2=Expand(qoutsanxia1);% (1,36)ά����1,183��ά
QJiujiang=Muskingum(qoutsanxia2,Qingjiang,Chenglingji,Hanjiang,Qjj1); 
LakeLevel=Lake(station,FiveRivers,QJiujiang,Level0);
if station==2
    HXingzi=LakeLevel;
end

% �������̬Ŀ��
n=size(LakeLevel);
ZD=min(LakeLevel);
TD=0;
tD1=0;
for i=2:n
    if LakeLevel(i-1)>9 && LakeLevel(i)<9 && LakeLevel(i+1)<9.1 && LakeLevel(i+2)<9.1
        tD1=i;break;
    end
end
for i=2:n
    if LakeLevel(i)<9
        TD=TD+1;
    end
end
if tD1==0
        tD1=183;% 
end
%% ���㽭��ˮ������
LakeFlow=Exchange(QJiujiang,HXingzi);

plot(LakeLevel)
figure()
plot(LakeFlow)
