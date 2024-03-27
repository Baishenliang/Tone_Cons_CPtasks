function [output,comb_index_selected,output_std] = bsliang_getmindiffcomb(list,combn)

    % 在一个list的数字里获取在所有combn和元素组合情况中差距最小（标准差）的组合
    
    comb_index = combntns(1:length(list),combn); % 所有组合情况(行：组合；列：每种组合的元素索引)
    % row: comb_type
    comb_std = zeros(size(comb_index,1),1); % 各种组合情况的标准差
    
    for step=1:size(comb_index,1) %计算标准差
        comb_std(step,1)= std(list(comb_index(step,:)));% list里被某一组合索引的元素的值的标准差
    end
    
    [~,comb_std_min] = bsliang_multimin(comb_std); %使得标准差为最小值的组合的索引（可能有几个）
    output=zeros(1,length(comb_std_min));
    output_std=zeros(1,length(comb_std_min));
    comb_index_selected=zeros(length(comb_std_min),combn);
    for min_i=1:length(comb_std_min)
        comb_index_selected(min_i,:) = comb_index(comb_std_min(min_i),:); %选中这一组合
        output(1,min_i) = mean(list(comb_index_selected(min_i,:))); %求出这一组合索引的元素值的均值
        output_std(1,min_i) = std(list(comb_index_selected(min_i,:))); %求出这一组合索引的元素值的标准差    
    end
    output=mean(output);
    output_std=mean(output_std);