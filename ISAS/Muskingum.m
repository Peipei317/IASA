%Yangtze estimate

function y=Muskingum(Isx,Qqj,Qclj,Qhj,Qjj1)
% parameter setting
K=24*6; % h           �ٶ�
L=950; % km
x=0.421;              % �ٶ�
dt=24;
Kl=dt;
n=K/Kl; %�Ӷ���
Ll=L/n;
xl=0.5-n*(1-2*x)/2;

% tributaries
Dc=450;             % ��Ͽ����������
Dq=70;              % ��Ͽ���彭���� Դ�԰ٶȵ�ͼ����
Dh=70+88+67+225+240;% ��Ͽ�����ھ���
nc=round(Dc/Ll)+1; % ����������ĺӶ�
nq=round(Dq/Ll)+1;
nh=round(Dh/Ll)+1;

C0=(0.5*dt-Kl*xl)/(0.5*dt+Kl-Kl*xl);
C1=(0.5*dt+Kl*xl)/(0.5*dt+Kl-Kl*xl);
C2=(-0.5*dt+Kl-Kl*xl)/(0.5*dt+Kl-Kl*xl);

% compute I and Q
nj=size(Isx,2)-1;   %ʱ����
Isx=Isx(1:nj);
I=zeros(nj,n);    
Q=zeros(nj,n);
I(:,1)=Isx';
Q(1,n)=Qjj1;

% initial Q
j=1;
for i=1:n-1;
    Q(j,i)=I(j,1)+(Q(j,n)-I(j,1))*i/n;
end


for i=1:n
    for j=2:nj
        if i>1
            I(j,i)=Q(j,i-1);
            if i==nc
                I(j,i)=I(j,i)+Qclj(j);
            end
            if i==nq
                I(j,i)=I(j,i)+Qqj(j);
            end
            if i==nh
                I(j,i)=I(j,i)+Qhj(j);
            end
        end
        Q(j,i)=C0*I(j,i)+C1*I(j-1,i)+C1*Q(j-1,i);
    end
end

y=Q(:,n);
end


