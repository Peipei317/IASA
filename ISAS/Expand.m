% 将调度时段的三峡下泄流量x扩展为每日流量y

function y=Expand(x)

% 日期编号
k=size(x,2);% 时段平均流量共36个
n1=1:k;% 调度时段的编号
day=[5 5 5 5 5 6, 5 5 5 5 5 5, 5 5 5 5 5 6, 5 5 5 5 5 6, 5 5 5 5 5 3, 5 5 5 5 5 6];
n2=zeros(1,k+1);% 调度时段初天数的编号，共37个，最后一个为时段末的值
n2(1)=n1(1);
for i=2:k+1
    n2(i)=n2(i-1)+day(i-1);
end

% 平均流量x转化为时段初的时刻流量x1
x1=zeros(1,k+1);
x1(1)=22075;                                                % 下泄流量初始值
for i=2:k+1
    x1(i)=2*x(i-1)-x1(i-1);
end

% 插值
n3=1:n2(k+1);% 天数的编号
y=interp1(n2,x1,n3,'linear');
end




