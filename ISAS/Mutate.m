% Copyright (c) 2016
% All rights reserved. 
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Developer: Dai Lingquan based on Yarpiz (www.yarpiz.com)
% Contact Info: dailingquan@163.com
%

function y=Mutate(x,mu,sigma)

    nVar=numel(x);
    
    nMu=ceil(mu*nVar);%���ش��ڻ��ߵ���ָ�����ʽ����С����
   
    k=1;
    while (true)  %%������ˮλ����ֵҲ��������ˮλ����й����Լ���� ����Ҫ
            
    j=randsample(nVar,nMu); %��nVar �����ȡnMu������
    if numel(sigma)>1
        sigma = sigma(j);
    end
    y=x;
    y(j)=x(j)+sigma.*randn(size(j));
    [~,~,s1,s2]=WLQS(y);
          if s1>0 && s2>0
             a=y;y=a;k=k+1;
          end
        if k==2
            break;
        end
   end
 
end