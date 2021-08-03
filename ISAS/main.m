%%��Ͽˮ���Ŀ�����
% ע���޸ĵ�����
% ע���޸ı�����ļ���

clc;
clear;
close all;

%% Problem Definition
global VarMin_B; % ��ʱ�γ���ˮ��ˮλԼ����������=WLQS���������һ�¡�
global VarMax_B;
global qinsanxia;
global day;
global nVar;

CostFunction=@(x) MOP2(x);      % Cost Function Ŀ�꺯��
day=[5 5 5 5 5 6, 5 5 5 5 5 5, 5 5 5 5 5 6, 5 5 5 5 5 6, 5 5 5 5 5 3, 5 5 5 5 5 6]; % ÿ������ʱ�ΰ���������
nVar=36+1;             % Number of Decision Variables %ˮ���10�¿�ʼ������3�£�5��Ϊһ��ʱ�Σ���36��ʱ�Σ�ˮλ��37����
VarSize=[1 nVar];    % Size of Decision Variables Matrix
ConditionYear=3;     % ѡ������ꡣ1=��ˮ�꣬2=ƽˮ�꣬3=��ˮ��,4=2005-2005��
load DataInSanxia.mat
qinsanxia=Qinsanxia(:,ConditionYear);% ��Ͽˮ�����������WLQS�����л��õ�������Ϊʱ��ƽ��ֵ����36����
VarMin_B=VarMin;VarMax_B=VarMax;% VarMinΪˮλ������Լ����VarMin_BΪˮλ�ı߽�Լ��,��ʵ��Լ��
a=zeros(nVar,1);
% a(1:19)=[154.5	158.2	161.8	165.5	169.1	172.8	175	175	175	175	175	175	175	175	175	175	175	175	175]; % 10-12��ˮλ�̶���ֻ��1-3��
delt=1.8;% ����ʱ�μ�����ˮλ��
NIt=2000; %��������

% Number of Objective Functions
a=[154.5	158.2	161.8	165.5	169.1	172.8	175	175	175	175	175	175	175	175	175	175	175	175	175	174.2647059	173.5294118	172.7941176	172.0588235	171.3235294	170.4411765	169.3877551	167.8571429	166.3265306	164.7959184	163.2653061	162.3469388	160.8163265	159.2857143	157.755102	156.2244898	155	155]'; 
nObj=numel(CostFunction(a)); %����Ԫ�ظ��� % ����Ŀ�꺯��������Ŀ�꺯���ĸ���


%% NSGA-II Parameters

MaxIt=NIt;      % Maximum Number of Iterations ����������

nPop=30;        % Population Size ��Ⱥ��С

pCrossover=0.7;                         % Crossover Percentage  �������
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings) % ��������ȡ��

pMutation=0.4;                          % Mutation Percentage  �������
nMutation=round(pMutation*nPop);        % Number of Mutants

mu=0.01;                    % Mutation Rate ͻ����  �ر�˵������Ϊ���̶ȵ����ʱֻ����һ�����죬���mu*nVar<1,���Դ˴�ȡ0.01

sigma=0.1*(max(VarMax)-min(VarMin));  % Mutation Step Size


%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];


pop=repmat(empty_individual,nPop,1);% �ѵ�����

a=[154.5	158.2	161.8	165.5	169.1	172.8	175	175	175	175	175	175	175	175	175	175	175	175	175	174.2647059	173.5294118	172.7941176	172.0588235	171.3235294	170.4411765	169.3877551	167.8571429	166.3265306	164.7959184	163.2653061	162.3469388	160.8163265	159.2857143	157.755102	156.2244898	155	155]';
[~,~,s1,s2]=WLQS(a); %���������ǰ������������й����������ˮλ����Ҫ�������á�~����ʾʡ��
for k=1:nPop
    pop(k).Position=a;
    pop(k).Cost=CostFunction(pop(k).Position);%����Ŀ�꺯�������� pop(i).Cost��
end

% Non-Dominated Sorting �������ĳ�ʼȺ���з�֧������
[pop, F]=NonDominatedSorting(pop);

% Calculate Crowding Distance  ����ӵ����
pop=CalcCrowdingDistance(pop,F);

% Sort Population ���� 
[pop, F]=SortPopulation(pop);


%% NSGA-II Main Loop

for it=1:MaxIt
    
  % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
      
    for k=1:nCrossover/2
         
        i1=randi([1 nPop]);% �ڿ����䣨1,nPop�����ɾ��ȷֲ���α�������
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);% ���һά������
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,mu,sigma);
        popm(k).Cost=CostFunction(popm(k).Position);        
    end
    
    % Merge
    pop=[pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    pop=SortPopulation(pop);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    numel(F1);
    F1.Cost;
   
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    pause(0.01); 
    pop(F{1}).Cost
    pop(F{1}).Position    %���ˮλ�Ż����   
end

%% Results
save result0503
