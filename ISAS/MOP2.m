

%����Ŀ�꺯����ʹ����Ŀ�꺯�����
% Ҫע��仯��ֵ�У���1�������ڵĸ��£���2��2�·ݵ���������3��۶�����ĳ�ʼˮλ����4�� �ο�ָ��

% tD0�޸�Ϊ105����20200809

function z=MOP2(x)
    [qoutsanxia1,zdownsanxia1,s1,s2]=WLQS(x);
    
    z1=0;
    %%���㷢����
    %��Ͽ���鵥�������������966.0m3/s[190]��32̨���������й����Ϊ30912m3/s������������������30912m3/sʱ�����ಿ��Ϊ��ˮ���ο�����ȫ��ʿ����
    % 10�·�
    for i=1:5 % ʱ�α��
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*5;      %������
    end
    for i=6:6
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*6;      %������
    end
    % 11��12�·�
    for i=7:17
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*5;      
    end
    for i=18:18
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*6;      
    end
    % 1�·�
    for i=19:23
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*5;
    end
    for i=24:24
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*6;
    end
    % 2�·�
    for i=25:29
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*5;
    end
    for i=30:30
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*3; % 2�·ݵ�����
    end
    % 3�·�
    for i=31:35
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*5;
    end
    for i=36:36
        z1=z1+((x(i)+x(i+1))/2-zdownsanxia1(i))*min(30912,qoutsanxia1(i))*9.81*0.933*24*6;
    end
    
    
    %%������̬Ŀ��
    load DataInM.mat;
    qoutsanxia2=Expand(qoutsanxia1);% (1,36)ά����1,183��ά
    QJiujiang=Muskingum(qoutsanxia2,Qingjiang,Chenglingji,Hanjiang,Qjj1); 
    LakeLevel=Lake(station,FiveRivers,QJiujiang,Level0);
    ZD0=7.8; tD0=105; TD0=40;                                       % �ο�ָ��
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
        tD1=183;
    end
    % ��������̬Ŀ��
    z2=ZD/ZD0+tD1/tD0-TD/TD0;
    
    if s1==-n
        z1=-10;
    end
    if s1==-15
        z1=-2;
    end
    if s2==-5000
        z2=-1;
    end
    if s2==-1
        z2=-10;
    end
    if s2==-2
        z2=-100;
    end      
    
     
   z=[z1 z2]';
end