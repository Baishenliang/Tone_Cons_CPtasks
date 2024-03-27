function [output,comb_index_selected,output_std] = bsliang_getmindiffcomb(list,combn)

    % ��һ��list���������ȡ������combn��Ԫ���������в����С����׼������
    
    comb_index = combntns(1:length(list),combn); % ����������(�У���ϣ��У�ÿ����ϵ�Ԫ������)
    % row: comb_type
    comb_std = zeros(size(comb_index,1),1); % �����������ı�׼��
    
    for step=1:size(comb_index,1) %�����׼��
        comb_std(step,1)= std(list(comb_index(step,:)));% list�ﱻĳһ���������Ԫ�ص�ֵ�ı�׼��
    end
    
    [~,comb_std_min] = bsliang_multimin(comb_std); %ʹ�ñ�׼��Ϊ��Сֵ����ϵ������������м�����
    output=zeros(1,length(comb_std_min));
    output_std=zeros(1,length(comb_std_min));
    comb_index_selected=zeros(length(comb_std_min),combn);
    for min_i=1:length(comb_std_min)
        comb_index_selected(min_i,:) = comb_index(comb_std_min(min_i),:); %ѡ����һ���
        output(1,min_i) = mean(list(comb_index_selected(min_i,:))); %�����һ���������Ԫ��ֵ�ľ�ֵ
        output_std(1,min_i) = std(list(comb_index_selected(min_i,:))); %�����һ���������Ԫ��ֵ�ı�׼��    
    end
    output=mean(output);
    output_std=mean(output_std);