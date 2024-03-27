function bsliang_plot_SNRdata(par_lst)

%% 参数设定和说明
getslopemethod='diff';
% 'beta_log10':直接从拟合beta值求斜率，并进行log10()转换；
% 'beta_100out':直接从拟合beta值求斜率，并剔除大于100的；
% 'diff': 通过求导方法求出中间点的斜率。

%*****注意，上面三种方法均没有被第三方确证过的确是有效的。

%% 加载和运算

load('DATA.mat');
load('input\SNRlst');
step_num=5;
ID_lst=nan(step_num,length(par_lst),length(SNRlst)+1,2); %每个被试的ID曲线（拟合）
% ID_lst(IDsteps,participants,SNRsteps,condition[T P]);
IDRT_lst=ID_lst;%每个被试的ID反应时曲线
IDRTdiff_lst=nan(length(par_lst),length(SNRlst)+1,2);%每个被试的ID反应时区分曲线（中间减去两边均值）
% ID_lst(participants,SNRsteps,condition[T P]);
IDQS_lst=IDRTdiff_lst;%每个被试的ID难度问卷曲线；
IDBETA_lst=IDRTdiff_lst;%每个被试的ID拟合曲线的beta值（斜率）
xsteps(1,:)=DATA(1).Id_Di.data(1).half_threshold(:,1)';%被试的ID的steps(tone)（用连续体所在的百分比表示）
xsteps(2,:)=DATA(1).Id_Di.data(2).half_threshold(:,1)';%被试的ID的steps(phon)（用连续体所在的百分比表示）

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

%一些作图的参数：
SNRx=1:length(SNRlst)+1;
SNRx_Tag=cell(1,length(SNRx));
SNRx_Tag{1,1}='NN';
for snrx=2:length(SNRx)
    SNRx_Tag{1,snrx}=num2str(SNRlst(1,snrx-1));
end
pti={'声调','音位'};
color_mat={[159,53,58]/255,'燕脂(红色)';...
           [15,76,58]/255,'蓝海松茶(深绿色)';...
           [177,120,68]/255,'琵琶茶(棕色)';...
           [147,150,80]/255,'柳茶(淡绿色)'};

%% 作图
       
%1_斜率分布图
figure;
histogram(reshape(IDBETA_lst,1,[]));
title('斜率分布直方图');
xlabel('斜率');
ylabel('block数');


%2_1_问卷得分：
figure;
% ID_lst(participants,SNRsteps,condition[T P]);
errorbar(SNRx,mean(IDQS_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDQS_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDQS_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDQS_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDQS_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDQS_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7,'Ytick',1:5);
set(gca,'Xticklabel',SNRx_Tag,'Yticklabel',{'1-难度没变','2-变大一些','3-明显变大','4-听不太清','5-听不清了'});
legend('声调','音位');
title('被试主观难度判断与SNR')
xlabel('SNR(dB)')
ylabel('难度判断')

%2_2/3_SNR=-4 -8的难度判断分布直方图
for pt=1:2
    figure;
    histogram(IDQS_lst(:,6,pt),'FaceColor',color_mat{3,1})
    hold on
    histogram(IDQS_lst(:,7,pt),'FaceColor',color_mat{4,1})
    ylim([0 9]);
    set(gca,'Xtick',1:5);
    set(gca,'Xticklabel',{'1-难度没变','2-变大一些','3-明显变大','4-听不太清','5-听不清了'});
    legend('SNR = -4dB','SNR = -8dB');
    title([pti{pt},'：低信噪比下的被试难度判断分数直方图'])
    xlabel('难度判断')
    ylabel('人数')
end


%3_反应时：
figure;
% ID_lst(IDsteps,participants,SNRsteps,condition[T P]);
errorbar(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,1),1,'omitnan'),2,'omitnan')),bsliang_getSE(squeeze(mean(IDRT_lst(:,:,:,1),1,'omitnan'))),'Color',color_mat{1,1});
hold on
errorbar(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,2),1,'omitnan'),2,'omitnan')),bsliang_getSE(squeeze(mean(IDRT_lst(:,:,:,2),1,'omitnan'))),'Color',color_mat{2,1});
plot(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,1),1,'omitnan'),2,'omitnan')),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,squeeze(mean(mean(IDRT_lst(:,:,:,2),1,'omitnan'),2,'omitnan')),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('声调','音位');
title('被试判断反应时与SNR')
xlabel('SNR(dB)')
ylabel('反应时(s)')

%3_配对样本t检验：-4dB和-8dB对比8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(squeeze(mean(IDRT_lst(:,:,snr,pt),1,'omitnan')),squeeze(mean(IDRT_lst(:,:,2,pt),1,'omitnan')));
        disp([pti{pt},'：Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end


%4_反应时peak相对幅度：
% ID_lst(participants,SNRsteps,condition[T P]);
figure;
errorbar(SNRx,mean(IDRTdiff_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDRTdiff_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDRTdiff_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDRTdiff_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDRTdiff_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDRTdiff_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('声调','音位');
title('被试判断反应时peak峰值(step3-step1/5)与SNR')
xlabel('SNR(dB)')
ylabel('反应时peak峰值(s)')

%4_配对样本t检验：-4dB和-8dB对比8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(IDRTdiff_lst(:,snr,pt),IDRTdiff_lst(:,2,pt));
        disp([pti{pt},'：Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end

%区分不同斜率，小于100的为蓝，大于300的为红
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


%5_画斜率的均值图
figure;
% ID_lst(participants,SNRsteps,condition[T P]);
errorbar(SNRx,mean(IDBETA_lst(:,:,1),1,'omitnan'),bsliang_getSE(IDBETA_lst(:,:,1)),'Color',color_mat{1,1});
hold on
errorbar(SNRx,mean(IDBETA_lst(:,:,2),1,'omitnan'),bsliang_getSE(IDBETA_lst(:,:,2)),'Color',color_mat{2,1});
plot(SNRx,mean(IDBETA_lst(:,:,1),1,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(SNRx,mean(IDBETA_lst(:,:,2),1,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:7);
set(gca,'Xticklabel',SNRx_Tag);
legend('声调','音位');
title('被试判断曲线边界斜率与SNR')
xlabel('SNR(dB)')
ylabel('被试判断曲线边界斜率')

%5_配对样本t检验：-4dB和-8dB对比8dB
for pt=1:2
    for snr=6:7
        [~,p,~,stats] = ttest(IDBETA_lst(:,snr,pt),IDBETA_lst(:,2,pt));
        disp([pti{pt},'：Paired t-test between SNR ',SNRx_Tag{snr},' and 8dB. p = ',num2str(p),'. T(',num2str(stats.df),') = ',num2str(stats.tstat),'.']);
    end
end


%区分不同SNR，越黑噪声越低，越红噪声越高（SNR越低）
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

%对比SNR前5个steps和67steps的均值
for pt=1:2
    figure;
    errorbar(mean(mean(ID_lst(:,:,1:5,pt),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,1:5,pt),3,'omitnan')'),'k-');
    hold on
    errorbar(mean(mean(ID_lst(:,:,6:7,pt),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,6:7,pt),3,'omitnan')'),'r-');
    title(pt);
end

%补充：范畴感知曲线
figure;
errorbar(1:5,mean(mean(ID_lst(:,:,:,1),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,:,1),3,'omitnan')'),'Color',color_mat{1,1});
hold on
errorbar(1:5,mean(mean(ID_lst(:,:,:,2),3,'omitnan'),2,'omitnan'),bsliang_getSE(mean(ID_lst(:,:,:,2),3,'omitnan')'),'Color',color_mat{2,1});
plot(1:5,mean(mean(ID_lst(:,:,:,1),3,'omitnan'),2,'omitnan'),'LineWidth',2,'Color',color_mat{1,1})
plot(1:5,mean(mean(ID_lst(:,:,:,2),3,'omitnan'),2,'omitnan'),'LineWidth',2,'Color',color_mat{2,1})
set(gca,'Xtick',1:5);
legend('声调','音位');
title('被试范畴感知曲线')
xlabel('steps')

%补充：研究是不是高噪声下极端高斜率的数据会更多：
IDBETA_lst([1:8,12:21],:,1);
IDBETA_lst([1:8,12:21],:,2);

%作相关图：
ACC_RT_QS={'斜率',IDBETA_lst;...
           '反应时',squeeze(mean(IDRT_lst,1,'omitnan'));...
           '主观难度',IDQS_lst
           '反应时峰值',IDRTdiff_lst};
%(participants,SNRsteps,condition[T P])
snrcolor={[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],color_mat{3,1},color_mat{4,1}};
cor_combs=nchoosek(1:size(ACC_RT_QS,1),2);
for pt=1:2
    for corc=1:nchoosek(size(ACC_RT_QS,1),2)
        figure;
        xi=cor_combs(corc,1);
        yi=cor_combs(corc,2);
        for snr=SNRx(2:end) %排除掉了无噪声的条件，因为那个练习效应没有被排除。
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
        title([pti{pt},':',ACC_RT_QS{xi,1},'与',ACC_RT_QS{yi,1},'散点图，相关系数R = ',num2str(round(rrr(2),2)),' p = ',num2str(round(ppp(2),5))]);
        xlabel(ACC_RT_QS{xi,1});
        ylabel(ACC_RT_QS{yi,1});
    end
end