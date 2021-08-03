%%��Ͽˮ��Ѵĩ��ˮ�ڶ�Ŀ�����
clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) MOP2(x);      % Cost Function Ŀ�꺯��

nVar=18;             % Number of Decision Variables %ˮ���7����Ѯ��ʼ��11����Ѯ��10��Ϊһ��ʱ�Σ���14��ʱ�Ρ�

VarSize=[1 nVar];   % Size of Decision Variables Matrix

%%Լ����������Ѯ��ˮλԼ��,��=WLQS�����У�Ҳ��Ҫ����Լ�����������ұ��뱣֤����һ��
VarMin=[145,145,145,145,145,145,145,150,150,150,150,150,150,151,152.8,159,168,175];
VarMax=[147.4455,147.433,147.7655,149.075,154.5485,154.3741667,154.8075,157.139,160.2435,162.8025,165.431,167.751,170.272,172.269,173.854,175.0025,175,175];


%VarMin=[145,145,145,145,145,145,145,145,145,145,145,145,145,146.3,152.8,159,164,175];
%VarMax=[147.4455,147.433,147.7655,149.075,154.5485,154.3741667,154.8075,157.139,160.2435,162.8025,165.431,167.751,170.272,172.269,173.854,175.0025,175,175];

% Number of Objective Functions
k=1;
while(true)  %��֤��������ˮλԼ��������Լ����ˮλ���У���ܹؼ�
    a=unifrnd(VarMin,VarMax,VarSize);
    [qoutsanxia1,zdownsanxia1,s1,s2]=WLQS(a);
    if s1>0 && s2>0
        nObj=numel(CostFunction(a)); %����Ŀ�꺯��������Ŀ�꺯���ĸ���
        k=k+1;
    end
     if k==2 %�Ѿ�������һ������Լ������ˮλ����
          break;
     end
end


%% NSGA-II Parameters

MaxIt=1000;      % Maximum Number of Iterations ����������

nPop=30;        % Population Size ��Ⱥ��С

pCrossover=0.7;                         % Crossover Percentage  �������
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

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


pop=repmat(empty_individual,nPop,1);

k=1;
while (true)   %��֤����nPop������Լ��������ˮλ���У��ؼ�����
     a=unifrnd(VarMin,VarMax,VarSize);
     [~,~,s1,s2]=WLQS(a); %���������ǰ������������й����������ˮλ����Ҫ�������á�~����ʾʡ��
     if s1>0 && s2>0  %s1>0��ʾ��������Լ����s2>0��ʾ����ˮλԼ������Ҫͬʱ����
        pop(k).Position=a;
        pop(k).Cost=CostFunction(pop(k).Position);%����Ŀ�꺯�������� pop(i).Cost��
        k=k+1;
     end
   
   if k==nPop+1  %��ʾ�Ѿ�������nPop�����������ĳ�ʼˮλ����ֵ������break
       break;
   end
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
         
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
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

