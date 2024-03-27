function this_constant_score=bsliang_getDi_scores(ses2_stimcluster,memory_buffer)

%这里还有些问题：20190823
    this_constant_socre=zeros(size(ses2_stimcluster,1),2);
    this_constant_steps=1:size(ses2_stimcluster,1);
    this_constant_score(:,1)=this_constant_steps';%给矩阵的第一列赋值：每个step一行
    for step_type=1:size(ses2_stimcluster,1) %计算每个step的平均数，并且存到作图用的数据矩阵中
        mmbf=memory_buffer(:,1);
        mmbc=ses2_stimcluster(step_type,:);
        if ~isempty(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))+(mmbf==mmbc(3))+(mmbf==mmbc(4))),2))
            %20190512:检查到这里
            step_score_diff=mean(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))),2));
            step_score_same=mean(memory_buffer(logical((mmbf==mmbc(3))+(mmbf==mmbc(4))),2));
            step_score=step_score_diff*0.5+step_score_same*0.5;
        else
            step_score=0;
        end
        %上面那个if的意思是，如果已经做了某些steps的trials，那么就求出均值，如果没做过，那么这个trial的值先记为0.
        this_constant_score(step_type,2)=step_score;
    end