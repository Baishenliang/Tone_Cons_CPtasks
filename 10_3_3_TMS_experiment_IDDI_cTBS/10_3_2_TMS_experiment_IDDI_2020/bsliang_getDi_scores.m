function this_constant_score=bsliang_getDi_scores(ses2_stimcluster,memory_buffer)

%���ﻹ��Щ���⣺20190823
    this_constant_socre=zeros(size(ses2_stimcluster,1),2);
    this_constant_steps=1:size(ses2_stimcluster,1);
    this_constant_score(:,1)=this_constant_steps';%������ĵ�һ�и�ֵ��ÿ��stepһ��
    for step_type=1:size(ses2_stimcluster,1) %����ÿ��step��ƽ���������Ҵ浽��ͼ�õ����ݾ�����
        mmbf=memory_buffer(:,1);
        mmbc=ses2_stimcluster(step_type,:);
        if ~isempty(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))+(mmbf==mmbc(3))+(mmbf==mmbc(4))),2))
            %20190512:��鵽����
            step_score_diff=mean(memory_buffer(logical((mmbf==mmbc(1))+(mmbf==mmbc(2))),2));
            step_score_same=mean(memory_buffer(logical((mmbf==mmbc(3))+(mmbf==mmbc(4))),2));
            step_score=step_score_diff*0.5+step_score_same*0.5;
        else
            step_score=0;
        end
        %�����Ǹ�if����˼�ǣ�����Ѿ�����ĳЩsteps��trials����ô�������ֵ�����û��������ô���trial��ֵ�ȼ�Ϊ0.
        this_constant_score(step_type,2)=step_score;
    end