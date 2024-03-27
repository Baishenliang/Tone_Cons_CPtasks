function bsliang_plot_SNRdata(par_lst)

%% �����趨��˵��
getslopemethod='diff';
% 'beta_log10':ֱ�Ӵ����betaֵ��б�ʣ�������log10()ת����
% 'beta_100out':ֱ�Ӵ����betaֵ��б�ʣ����޳�����100�ģ�
% 'diff': ͨ���󵼷�������м���б�ʡ�

%*****ע�⣬�������ַ�����û�б�������ȷ֤����ȷ����Ч�ġ�

%% ���غ�����

load('DATA.mat');
load('input\SNRlst');
step_num=5;
ID_lst=nan(step_num,length(par_lst),length(SNRlst)+1,2); %ÿ�����Ե�ID���ߣ���ϣ�
% ID_lst(IDsteps,participants,SNRsteps,condition[T P]);
IDRT_lst=ID_lst;%ÿ�����Ե�ID��Ӧʱ����
IDRTdiff_lst=nan(length(par_lst),length(SNRlst)+1,2);%ÿ�����Ե�ID��Ӧʱ�������ߣ��м��ȥ���߾�ֵ��
% ID_lst(participants,SNRsteps,condition[T P]);
IDQS_lst=IDRTdiff_lst;%ÿ�����Ե�ID�Ѷ��ʾ����ߣ�
IDBETA_lst=IDRTdiff_lst;%ÿ�����Ե�ID������ߵ�betaֵ��б�ʣ�
xsteps(1,:)=DATA(1).Id_Di.data(1).half_threshold(:,1)';%���Ե�ID��steps(tone)�������������ڵİٷֱȱ�ʾ��
xsteps(2,:)=DATA(1).Id_Di.data(2).half_threshold(:,1)';%���Ե�ID��steps(phon)�������������ڵİٷֱȱ�ʾ��

for par=1:length(par_lst)
    for SNRstep=1:length(SNRlst)+1
        try
            data_temp=DATA(par_lst(par)).Id_Di.data;
            [ID_lst(:,par,SNRstep,1),IDBETA_lst(par,SNRstep,1)]=bsliang_plot_SNRdata_fitIDcurve(data_temp(2*SNRstep-1).rawdata,step_num,xsteps(1,:),getslopemethod); %T
            [ID_lst(:,par,SNRstep,2),IDBETA_lst(par,SNRstep,2)]=bsliang_plot_SNRdata_fitIDcurve(data_temp(2*SNRstep).rawdata,step_num,xsteps(2,:),getslopemethod); %P
            [IDRT_lst(:,par,SNRstep,1),IDRTdiff_lst(par,SNRstep,1)]=bsliang_plot_SNRdata_RT(data_temp(2*SNRstep-1).rawdata,step_num);
            [IDRT_lst(:,par,SNRstep,2),IDRTdiff_lst(par,SNRstep,2)]=bsliang_plot_SNRdata_RT(data_temp(2*SNRstep).rawdata,step_num);
            if SNRstep==1
                IDQS_lst(par,SNRstep,1)=0;
                IDQS_lst(par,SNRstep,2)=0;
            else
                IDQS_lst(par,SNRstep,1)=data_temp(2*SNRstep-1).diff_judge;
                IDQS_lst(par,SNRstep,2)=data_temp(2*SNRstep).diff_judge;
            end
        catch
        end
    end
end

%һЩ��ͼ�Ĳ�����
SNRx=1:length(SNRlst)+1;
SNRx_Tag=cell(1,length(SNRx));
SNRx_Tag{1,1}='NN';
for snrx=2:length(SNRx)
    SNRx_Tag{1,snrx}=num2str(SNRlst(1,snrx-1));
end
pti={'����','��λ'};
color_mat={[159,53,58]/255,'��֬(��ɫ)';...
           [15,76,58]/255,'�����ɲ�(����ɫ)';...
           [177,120,68]/255,'���ò�(��ɫ)';...
           [147,150,80]/255,'����(����ɫ)'};

%% ��ͼ
       
%1_б�ʷֲ�ͼ
figure;
histogram(reshape(IDBETA_lst,1,[]));
title('б�ʷֲ�ֱ��ͼ');
xlabel('б��');
ylabel('block��');


%2_1_�ʾ�÷֣�
figure;
% ID_lst(participants,SNRsteps,condition[T P]);
errorbar(SNRx,mean(IDQS_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDQS_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDQS_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDQS_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDQS_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDQS_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7,'Ytick',1:5);
set(gca,'Xticklabel',SNRx_Tag,'Yticklabel',{'1-�Ѷ�û��','2-���һЩ','3-���Ա��','4-����̫��','5-��������'});
legend('����','��λ');
title('���������Ѷ��ж���SNR')
xlabel('SNR(dB)')
ylabel('�Ѷ��ж�')

%2_2/3_SNR=-4 -8���Ѷ��жϷֲ�ֱ��ͼ
for pt=1:2
    figure;
    histogram(IDQS_lst(:,6,pt),'FaceColor',color_mat{3,1})
    hold on
    histogram(IDQS_lst(:,7,pt),'FaceColor',color_mat{4,1})
    ylim([0 9]);
    set(gca,'Xtick',1:5);
    set(gca,'Xticklabel',{'1-�Ѷ�û��','2-���һЩ','3-���Ա��','4-����̫��','5-��������'});
    legend('SNR = -4dB','SNR = -8dB');
    title([pti{pt},'����������µı����Ѷ��жϷ���ֱ��ͼ'])
    xlabel('�Ѷ��ж�')
    ylabel('����')
end


%3_��Ӧʱ��
figure;
% ID_lst(IDsteps,participants,SNRsteps,condition[T P]);
errorbar(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,1),1,'omitnan'),2,'omitnan')),bsliang_getSE(squeeze(mean(IDRT_lst(:,:,:,1),1,'omitnan'))),'Color',color_mat{1,1});
hold on
errorbar(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,2),1,'omitnan'),2,'omitnan')),bsliang_getSE(squeeze(mean(IDRT_lst(:,:,:,2),1,'omitnan'))),'Color',color_mat{2,1});
plot(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,1),1,'omitnan'),2,'omitnan')),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,2),1,'omitnan'),2,'omitnan')),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('����','��λ');
title('�����жϷ�Ӧʱ��SNR')
xlabel('SNR(dB)')
ylabel('��Ӧʱ(s)')

%3_�������t���飺-4dB��-8dB�Ա�8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(squeeze(mean(IDRT_lst(:,:,snr,pt),1,'omitnan')),squeeze(mean(IDRT_lst(:,:,2,pt),1,'omitnan')));
        disp([pti{pt},'��Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end


%4_��Ӧʱpeak��Է��ȣ�
% ID_lst(participants,SNRsteps,condition[T P]);
figure;
errorbar(SNRx,mean(IDRTdiff_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDRTdiff_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDRTdiff_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDRTdiff_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDRTdiff_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDRTdiff_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('����','��λ');
title('�����жϷ�Ӧʱpeak��ֵ(step3-step1/5)��SNR')
xlabel('SNR(dB)')
ylabel('��Ӧʱpeak��ֵ(s)')

%4_�������t���飺-4dB��-8dB�Ա�8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(IDRTdiff_lst(:,snr,pt),IDRTdiff_lst(:,2,pt));
        disp([pti{pt},'��Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end

%���ֲ�ͬб�ʣ�С��100��Ϊ��������300��Ϊ��
IDBETA_lst_bad=IDBETA_lst>100;
for par=1:length(par_lst)
    for SNRstep=1:length(SNRlst)+1
        for pt=1:2
            if IDBETA_lst_bad(par,SNRstep,pt)
                plot(ID_lst(:,par,SNRstep,pt),'r-');
                hold on
            else
                plot(ID_lst(:,par,SNRstep,pt),'b-');
            end
        end
    end
end
hold off


%5_��б�ʵľ�ֵͼ
figure;
% ID_lst(participants,SNRsteps,condition[T P]);
errorbar(SNRx,mean(IDBETA_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDBETA_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDBETA_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDBETA_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDBETA_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDBETA_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('����','��λ');
title('�����ж����߽߱�б����SNR')
xlabel('SNR(dB)')
ylabel('�����ж����߽߱�б��')

%5_�������t���飺-4dB��-8dB�Ա�8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(IDBETA_lst(:,snr,pt),IDBETA_lst(:,2,pt));
        disp([pti{pt},'��Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end


%���ֲ�ͬSNR��Խ������Խ�ͣ�Խ������Խ�ߣ�SNRԽ�ͣ�
%red_dim=linspace(0,1,length(SNRlst)+1);
red_dim=[0 0 0 0 0 1 1];
for pt=1:2
    figure;
    for par=1:length(par_lst)
        for SNRstep=1:length(SNRlst)+1
            plot(ID_lst(:,par,SNRstep,pt),'color',[red_dim(SNRstep) 0 0]);
            hold on
        end
    end
    title(pt);
end

%�Ա�SNRǰ5��steps��67steps�ľ�ֵ
for pt=1:2
    figure;
    errorbar(mean(mean(ID_lst(:,:,1:5,pt),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,1:5,pt),3,'omitnan')'),'k-');
    hold on
    errorbar(mean(mean(ID_lst(:,:,6:7,pt),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,6:7,pt),3,'omitnan')'),'r-');
    title(pt);
end

%���䣺�����֪����
figure;
errorbar(1:5,mean(mean(ID_lst(:,:,:,1),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,:,1),3,'omitnan')'),'Color',color_mat{1,1});
hold on
errorbar(1:5,mean(mean(ID_lst(:,:,:,2),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,:,2),3,'omitnan')'),'Color',color_mat{2,1});
plot(1:5,mean(mean(ID_lst(:,:,:,1),3,'omitnan'),2,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(1:5,mean(mean(ID_lst(:,:,:,2),3,'omitnan'),2,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:5);
legend('����','��λ');
title('���Է����֪����')
xlabel('steps')

%���䣺�о��ǲ��Ǹ������¼��˸�б�ʵ����ݻ���ࣺ
IDBETA_lst([1:8,12:21],:,1);
IDBETA_lst([1:8,12:21],:,2);

%�����ͼ��
ACC_RT_QS={'б��',IDBETA_lst;...
           '��Ӧʱ',squeeze(mean(IDRT_lst,1,'omitnan'));...
           '�����Ѷ�',IDQS_lst
           '��Ӧʱ��ֵ',IDRTdiff_lst};
%(participants,SNRsteps,condition[T P])
snrcolor={[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],color_mat{3,1},color_mat{4,1}};
cor_combs=nchoosek(1:size(ACC_RT_QS,1),2);
for pt=1:2
    for corc=1:nchoosek(size(ACC_RT_QS,1),2)
        figure;
        xi=cor_combs(corc,1);
        yi=cor_combs(corc,2);
        for snr=SNRx(2:end) %�ų���������������������Ϊ�Ǹ���ϰЧӦû�б��ų���
            XY=[ACC_RT_QS{xi,2}(:,snr,pt),ACC_RT_QS{yi,2}(:,snr,pt)];
            if snr>=6
                scatter(XY(:,1),XY(:,2),30,snrcolor{1,snr},'filled');
            else
                scatter(XY(:,1),XY(:,2),30,snrcolor{1,snr});
            end
            hold on;
        end
        XYa=[reshape(ACC_RT_QS{xi,2}(:,2:end,pt),[],1),reshape(ACC_RT_QS{yi,2}(:,2:end,pt),[],1)];
        [rrr,ppp]=corr(XYa,'Rows','pairwise');
        title([pti{pt},':',ACC_RT_QS{xi,1},'��',ACC_RT_QS{yi,1},'ɢ��ͼ�����ϵ��R = ',num2str(round(rrr(2),2)),' p = ',num2str(round(ppp(2),5))]);
        xlabel(ACC_RT_QS{xi,1});
        ylabel(ACC_RT_QS{yi,1});
    end
end