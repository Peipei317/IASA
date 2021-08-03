% Copyright (c) 2016
% All rights reserved. 
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Developer: Dai Lingquan based on Yarpiz (www.yarpiz.com)
% Contact Info: dailingquan@163.com


function [y1, y2]=Crossover(x1,x2)
k=1;
  while(true)   %������ˮλ����ֵҲ��������ˮλ����й����Լ���� ����Ҫ
    alpha=rand(size(x1)) ; 
    a1=alpha.*x1+(1-alpha).*x2;
    a2=alpha.*x2+(1-alpha).*x1;
    [~,~,s1,s2]=WLQS(a1);
    b1=s1; b2=s2;
    [~,~,s3,s4]=WLQS(a2);
    b3=s3; b4=s4;
    
    if b1>0 && b2>0 && b3>0 && b4>0
        y1=a1;y2=a2; k=k+1;
    end
    
    if k==2 %˵���Ѿ�������һ������������ˮλ����ֵ
        break;
    end
  end  
end