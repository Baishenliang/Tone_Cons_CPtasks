function se=bsliang_getSE(DATA)
    %DATA(subjects,conditions)
    n=ones(1,size(DATA,2));
    for i=1:length(n)
        n(1,i)=sum(~isnan(DATA(:,i)));
    end
    se=std(DATA,'omitnan')./sqrt(n);