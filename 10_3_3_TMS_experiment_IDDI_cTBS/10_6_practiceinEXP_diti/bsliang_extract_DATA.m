%��DATA�ľ������ȡ���Ե���Ϊidentification����

load('DATA_20190510.mat');
raw_data=[];
% DIM1: participant
% DIM2: step
for par=1:8
    for step=1:4
        step_data=STUDY(2).participant(par).result_struct.experiment.session(2).steps(step).rawdata;
        raw_data(par,step).data=step_data(step_data(:,1)>0,:);
    end
end
