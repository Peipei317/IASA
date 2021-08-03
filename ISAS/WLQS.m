% Copyright (c) 2016
% All rights reserved. 
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Developer: Dai Lingquan based on Yarpiz (www.yarpiz.com)
% Contact Info: dailingquan@163.com

% s1=n ˮλ����Լ���� s2=n ��������Լ��
% s1=-n ˮλ������Լ��
% s1=-15 ˮλ�ղ����
% s2=1 δ�ж������� s2=-5000 �����������±߽�q1�� s2=-1 �����������±߽�0��s2=-2 �����������ϱ߽�
% s2=3 ����������Լ��


function [qoutsanxia1,zdownsanxia1,s1,s2]=WLQS(x)  %ˮλWL������Q������Լ������S����һ������������й�������ڶ���������������ˮλ����3�������ж��Ƿ���������Լ��,��4�������ж��Ƿ�����ˮλԼ��
global VarMin_B;
global VarMax_B;
global qinsanxia;
global day;
n=size(x,1);
vsanxia1=zeros(1,n);
qoutsanxia=zeros(1,n-1);
qoutsanxia1=zeros(1,n-1);
zdownsanxia1=zeros(1,n-1);
N=zeros(1,n-1);
zmin=VarMin_B;
zmax=VarMax_B;
q1=3000;

%%��Ͽˮ��ˮλ-���ݹ�ϵ����
zsanxia=[53,56,59,62,65,68,71,74,77,80,83,86,89,92,95,98,101,104,107,110,113,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,176,179,182,185];
vsanxia=[0.1,0.2,0.5,0.9,1.4,2.0,2.6,3.6,5.1,7.0,9.2,11.5,14.1,16.9,20.0,23.4,27.3,31.9,37.1,43.0,49.6,56.9,65.1,74.0,84.0,95.3,107.3,119.7,132.9,147.0,161.6,176.4,191.6,208.6,228.0,248.1,269.2,292.2,317.0,344.0,373.0,403.2,434.8,468.4,505.0]*10^8;
%%��Ͽˮ������βˮλ-������ϵ
qdownsanxia=[0,6167.4,11894.3,19603.5,29074.9,36563.9,46916.3,59911.9,87224.7,101762];
zdownsanxia=[64.4015,64.7104,65.3282,66.2548,67.9537,69.2664,71.2741,73.8996,79.4595,82.3938];

k=0;
for i=1:n
    if x(i)>=zmin(i) && x(i)<=zmax(i)
        k=k+1;
    end
end

if k==n
     s1=n;%����һ����������
     for i=1:n
         vsanxia1(i)=interp1(zsanxia,vsanxia,x(i),'linear'); %ˮλ��Ӧ�Ŀ���
     end  
     
     % ����Ͽˮ�����й����
%      qoutsanxia(1)=qinsanxia(1);
%      qoutsanxia(n)=qinsanxia(n);
     for i=1:n-1
        qoutsanxia(i)=qinsanxia(i)-(vsanxia1(i+1)-vsanxia1(i))/(day(i)*24*3600); 
     end
     if  min(qoutsanxia)>=q1 && max(qoutsanxia)<=56700
         qoutsanxia1=qoutsanxia;
         s2=n; %��������Լ������
     elseif min(qoutsanxia)<q1 && min(qoutsanxia)>=0
         qoutsanxia1=qoutsanxia;
         s2=-5000;
         disp('�����������±߽�Լ��q1');
     elseif min(qoutsanxia)<0
         qoutsanxia1(i)=0;
         s2=-1;
         disp('�����������±߽�Լ��0');
     else
         s2=-2;
         disp('�����������ϱ߽�Լ��');
     end
     
     for i=1:n-1
         zdownsanxia1(i)=interp1(qdownsanxia,zdownsanxia,qoutsanxia1(i),'linear');%����ˮλ
     end
     
%      for i=1:n-1
%          N(i)=((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933;%��վ����
%          if N(i)<4990000||N(i)>224000000
%             s2=3;
%             disp('����������߽�Լ��');
%          end
%      end

else
    s1=-1*n;%ˮλ������Լ��
    s2=1;
    disp('ˮλ������߽�Լ��');
end

%%����ˮλ�ձ���ж�
deltZ=zeros(1,n-1);
for i=1:n-1
    deltZ(i)=abs(x(i+1)-x(i));
end
  b=max(deltZ);
if s1>0 && s2>0
    if b>15.0
       s1=-15;       
    end
end

end