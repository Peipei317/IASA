% ���㳤����۶����ˮ������ 

function y=Exchange(QJiujiang,HXingzi)
    % ���ݼ�����Ԥ����
    load('model_exchange.mat')
    data_in = [QJiujiang HXingzi];
    minmax=[9030 7.32;58400 20.28]; % ѵ��ʱ�������ݵ����ֵ����Ӧ��һ����1
    [~,ps]=mapminmax(minmax',0,1);
    scenario_in=mapminmax('apply',data_in',ps)';
    %% Ԥ����
    tmp_2 = ones(size(QJiujiang,1),1);
    [test_pre,~,~] = svmpredict(tmp_2,scenario_in,model);

    y=test_pre;
end