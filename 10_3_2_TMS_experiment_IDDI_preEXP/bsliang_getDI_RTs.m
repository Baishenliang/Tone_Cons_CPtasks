function [meanRT_Di,RTlst_Di,meanRT_Id,RTlst_Id]=bsliang_getDI_RTs(parnums)
% get reaction time matrix:
load('DATA.mat');
RTlst_Di=[];
RTlst_Id=[];
for par=parnums
    RTlst_Di=[RTlst_Di,DATA(par).Id_Di.data(1).rawdata(:,3)'];
    RTlst_Di=[RTlst_Di,DATA(par).Id_Di.data(2).rawdata(:,3)'];
    RTlst_Id=[RTlst_Id,DATA(par).def_range.data(1).rawdata(:,3)'];
    RTlst_Id=[RTlst_Id,DATA(par).def_range.data(2).rawdata(:,3)'];
end
meanRT_Di=mean(RTlst_Di);
meanRT_Id=mean(RTlst_Id);