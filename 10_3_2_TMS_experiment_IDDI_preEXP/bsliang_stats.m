function bsliang_stats(ses2_cond,step_each_cond,cond_xticks,pair_nums)
% 
% NOconds=8; %��������Ŀ
% ses2_cond={'diti ���� ����','diti ��λ ����','diti ���� ����','diti ��λ ����','bapa ���� ����','bapa ��λ ����','bapa ���� ����','bapa ��λ ����'};
% %������������
% step_each_cond=[3,3,3,3,5,5,5,5]; %ÿ��������x��steps��
% cond_xticks={{'һ��','1-3','2-4','3-5','����'},...
%     {'di','1-3','2-4','3-5','ti'},...
%     {'һ��','1-3','2-4','3-5','����'},...
%     {'di','1-3','2-4','3-5','ti'},...
%     {'һ��','1-3','2-4','3-5','4-6','5-7','����'},...
%     {'ba','1-3','2-4','3-5','4-6','5-7','pa'},...
%     {'һ��','1-3','2-4','3-5','4-6','5-7','����'},...
%     {'ba','1-3','2-4','3-5','4-6','5-7','pa'},...
%     }; %ÿ��������xticks
% pair_nums={[1 3],[2 4],[5 7],[6 8]}; %����-�����������

load('DATA.mat');
pars=size(DATA,2);

for COND=1:size(pair_nums,2)
    COND_pair=pair_nums{1,COND};
    COND_C=COND_pair(1);
    COND_N=COND_pair(2);
    
    all_COND_C=zeros(pars,step_each_cond(COND_C));
    for par=1:pars
        all_COND_C(par,:)=DATA(par).Id_Di.data(COND_C).half_threshold;
    end
    se_COND_C=std(all_COND_C)/sqrt(pars);
    avg_COND_C=mean(all_COND_C,1);
    figure;
    plot(avg_COND_C,'b','LineWidth',3);
    
    hold on
    
    all_COND_N=zeros(pars,step_each_cond(COND_N));
    for par=1:pars
        all_COND_N(par,:)=DATA(par).Id_Di.data(COND_N).half_threshold;
    end
    se_COND_N=std(all_COND_N)/sqrt(pars);
    avg_COND_N=mean(all_COND_N,1);
    plot(avg_COND_N,'r','LineWidth',3);

    
    legend(ses2_cond{COND_C},ses2_cond{COND_N});
    errorbar(avg_COND_C,se_COND_C,'k.');
    errorbar(avg_COND_N,se_COND_N,'k.');

    xlabel('�̼���');
    ylabel('d''');
    ylim([0.4 0.9]);
    xlim([0 step_each_cond(COND_C)+1]);
    set(gca,'XTick',0:1:step_each_cond(COND_C)+1);
    set(gca,'XTickLabel',cond_xticks{COND_C});
    saveas(gca,['stats/',ses2_cond{COND_C}(1:7),'.png']);
    close(figure(1));
end