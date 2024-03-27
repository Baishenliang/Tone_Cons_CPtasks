function bsliang_check_stimulimatrix_forBEHAVEXP(phon_steps,tone_steps)
%This script is set for checking (1)RMS, (2)VOT, and (3)tone of the
%generated matrix, and make polts.

%Step 1: load the matrix:
load('output/par_EXPdata.mat');
par_num=size(par_EXPdata,2);
org_struct=[];
all_morphed_stim_norm_temp=cell(phon_steps,tone_steps);
for par=1:par_num
    for phon = 1:phon_steps
        for tone = 1:tone_steps
          all_morphed_stim_norm_temp{phon,tone} = par_EXPdata(par).T_old_BEHAV{1,(phon-1)*tone_steps+tone};
        end
    end
     org_struct(par).all_morphed_stim_norm = all_morphed_stim_norm_temp;
end

fs=44100;
audiowrite('output/checkP1T1.wav',all_morphed_stim_norm_temp{1,1},fs);
audiowrite(['output/checkP',num2str(phon_steps),'T1.wav'],all_morphed_stim_norm_temp{end,1},fs);
audiowrite(['output/checkP1T',num2str(tone_steps),'.wav'],all_morphed_stim_norm_temp{1,end},fs);
audiowrite(['output/checkP',num2str(phon_steps),'T',num2str(tone_steps),'.wav'],all_morphed_stim_norm_temp{end,end},fs);

%Also load the original 54*54 step matrix:
load('input/morphed_stim_test_struct.mat');
pre_F0_mat_org=morphed_stim_test_struct.F0;
pre_VOT_mat_org=morphed_stim_test_struct.VOT;

clear morphed_stim_test_struct
%load the ranges defined by pre experiments:
load('output/xs_perc_struct.mat');

check_struct=[];
for par=1:par_num
    
    all_morphed_stim_norm=org_struct(par).all_morphed_stim_norm;
    
    F0_perc=xs_perc_struct(par).xs_perc.tone_old;
    VOT_perc=xs_perc_struct(par).xs_perc.phon_old;

    len_pre_F0s = 50:300;

    pre_F0_mat_s=cell(phon_steps,tone_steps);
    pre_VOT_mat_s=cell(phon_steps,tone_steps);

    pre_F0_mat_s_lu=pre_F0_mat_org{round(VOT_perc(1)*(end-1)+1),1};
    pre_F0_mat_s_ru=pre_F0_mat_org{round(VOT_perc(1)*(end-1)+1),end};
    pre_F0_mat_s_ld=pre_F0_mat_org{round(VOT_perc(end)*(end-1)+1),1};
    pre_F0_mat_s_rd=pre_F0_mat_org{round(VOT_perc(end)*(end-1)+1),end};

    pre_F0_mat_s{1,1}=pre_F0_mat_s_lu(len_pre_F0s);
    pre_F0_mat_s{1,end}=pre_F0_mat_s_ru(len_pre_F0s);
    pre_F0_mat_s{end,1}=pre_F0_mat_s_ld(len_pre_F0s);
    pre_F0_mat_s{end,end}=pre_F0_mat_s_rd(len_pre_F0s);

    F0_u=pre_F0_mat_s{1,1}-pre_F0_mat_s{1,end};
    F0_d=pre_F0_mat_s{end,1}-pre_F0_mat_s{end,end};

    pre_VOT_mat_s{1,1}=pre_VOT_mat_org{1,round(F0_perc(1)*(end-1)+1)};
    pre_VOT_mat_s{1,end}=pre_VOT_mat_org{1,round(F0_perc(end)*(end-1)+1)};
    pre_VOT_mat_s{end,1}=pre_VOT_mat_org{end,round(F0_perc(1)*(end-1)+1)};
    pre_VOT_mat_s{end,end}=pre_VOT_mat_org{end,round(F0_perc(end)*(end-1)+1)};

    VOT_l=pre_VOT_mat_s{end,1}-pre_VOT_mat_s{1,1};
    VOT_r=pre_VOT_mat_s{end,end}-pre_VOT_mat_s{1,end};

    pre_F0_mat=cell(phon_steps,tone_steps);
    pre_VOT_mat=cell(phon_steps,tone_steps);
    
    pre_F0_mat{1,1}=pre_F0_mat_s{1,1}-F0_u*F0_perc(1);
    pre_F0_mat{1,end}=pre_F0_mat_s{1,1}-F0_u*F0_perc(end);
    pre_F0_mat{end,1}=pre_F0_mat_s{end,1}-F0_d*F0_perc(1);
    pre_F0_mat{end,end}=pre_F0_mat_s{end,1}-F0_d*F0_perc(end);
    
    pre_VOT_mat{1,1}=pre_VOT_mat_org{1,1}+VOT_l*VOT_perc(1);
    pre_VOT_mat{end,1}=pre_VOT_mat_org{1,1}+VOT_l*VOT_perc(end);
    pre_VOT_mat{1,end}=pre_VOT_mat_org{1,end}+VOT_r*VOT_perc(1);
    pre_VOT_mat{end,end}=pre_VOT_mat_org{1,end}+VOT_r*VOT_perc(end);

    %Step 2: RMS
    all_morphed_stim_RMS=[];
    for phon_step=1:phon_steps
        for tone_step=1:tone_steps
            all_morphed_stim_RMS(phon_step,tone_step)=rms(all_morphed_stim_norm{phon_step,tone_step});
        end
    end

    %Step 3: pitch
    all_morphed_stim_F0=[];
    for phon_step=1:phon_steps
        for tone_step=1:tone_steps
            disp(['phon = ',num2str(phon_step),'tone = ',num2str(tone_step)]);
            [f0_temp,~]=bsliang_getF0(all_morphed_stim_norm{phon_step,tone_step},[100 200]);
            all_morphed_stim_F0{phon_step,tone_step}=f0_temp;
        end
    end

    %Step 4: waveform
    all_morphed_stim_waveform=[];
    for phon_step=1:phon_steps
        for tone_step=1:tone_steps
            all_morphed_stim_waveform{phon_step,tone_step}=all_morphed_stim_norm{phon_step,tone_step};
            fig=figure;
            plot(1/44100:1/44100:length(all_morphed_stim_norm{phon_step,tone_step})/44100,all_morphed_stim_norm{phon_step,tone_step});
            disp([num2str(phon_step),' ',num2str(tone_step)]);
            ylim([-1 1]);
            xlim([0 0.45]);
            saveas(fig,['output/stim_check_waves\Par',num2str(par),'_P',num2str(phon_step),'_T',num2str(tone_step),'.png']);
            close(fig)
        end
    end
    
    %Step 5: VOT
    fs=44100;
    all_morphed_stim_VOT=[];
    for phon_step=1:phon_steps
        for tone_step=1:tone_steps
            disp(['phon = ',num2str(phon_step),' tone = ',num2str(tone_step)]);
            vot_temp=bsliang_getVOT(all_morphed_stim_norm{phon_step,tone_step},fs);
            all_morphed_stim_VOT{phon_step,tone_step}=vot_temp;
        end
    end

    morphed_stim_test_struct.RMS=all_morphed_stim_RMS;
    morphed_stim_test_struct.F0=all_morphed_stim_F0;
    morphed_stim_test_struct.waveform=all_morphed_stim_waveform;
    morphed_stim_test_struct.VOT=all_morphed_stim_VOT;

    check_struct(par).morphed_stim_test_struct=morphed_stim_test_struct;
    save('output/check_struct.mat','check_struct');

    %Now plot VOTs:
    % fs=44100;
    for tone_step=[1 tone_steps]
        fig=figure;
        
        % the orginal phon steps
        for phon_step=[1 phon_steps]
            plot([pre_VOT_mat{phon_step,tone_step} pre_VOT_mat{phon_step,tone_step}],[0 1],'k');
            hold on;
        end
        xlim([0 0.13]);
        
        % the steps that we need to generate determined by pre experiment
       % 算了，这个先不管了
%         VOT_perc=xs_perc_struct(par).xs_perc.phon_old;
%         min_pre_VOT = pre_VOT_mat{1,1};
%         max_pre_VOT = pre_VOT_mat{end,1};
%         phon_perc=min_pre_VOT + VOT_perc*(max_pre_VOT-min_pre_VOT); 
%         for perc_step=1:length(VOT_perc)
%             plot([phon_perc(perc_step) phon_perc(perc_step)],[0 1],'b');
%             hold on;
%         end
    
        % the steps that we actually generated
        for phon_step=1:size(morphed_stim_test_struct.RMS,1)
            plot(morphed_stim_test_struct.VOT{phon_step,tone_step},0.5,'ro');
            hold on
        end
        
        title('不送气-送气');
        xlabel('VOT');
        saveas(fig,['output/stim_check_VOTs\Par',num2str(par),'_T',num2str(tone_step),'.png']);
        close(fig);
    end
    
    %Now plot all VOTs:
    % fs=44100;
    fig=figure;
    
    for tone_step=1:tone_steps
        % the steps that we actually generated
        for phon_step=1:phon_steps
            plot(tone_step,morphed_stim_test_struct.VOT{phon_step,tone_step},'ro');
            hold on
        end
    end
    
    title('不送气-送气');
    xlabel('tone step');
    xlim([0 8]);
    ylim([0.02 0.08])
    saveas(fig,['output/stim_check_VOTs\ALLVOTs_Par',num2str(par),'.png']);
    close(fig);

    %Now plot F0s:
    % fs=44100;
    for phon_step=[1 phon_steps]
        fig=figure;
        
        
        % the steps that we need to generate determined by pre experiment
%         if phon_step ==1
%             min_pre_F0 = pre_F0_mat{1,1};
%             max_pre_F0 = pre_F0_mat{1,end};
%         else
%             min_pre_F0 = pre_F0_mat{end,1};
%             max_pre_F0 = pre_F0_mat{end,end};
%         end
%         tone_perc = zeros(length(len_pre_F0s),length(F0_perc));
        
%         for pp_perc=1:length(F0_perc)
%             tone_perc(:,pp_perc)=min_pre_F0(len_pre_F0s) + F0_perc(pp_perc)*(max_pre_F0(len_pre_F0s)-min_pre_F0(len_pre_F0s));  %【【【【【【【【20190714要改】】】】】】】】】】
%         end
        
                % the orginal tone steps
        for tone_step=[1 tone_steps]
%             if phon_step ==1
              pre_F0_mat_temp=pre_F0_mat{phon_step,tone_step};
%             else
%                 pre_F0_mat_temp=pre_F0_mat{end,tone_step};
%             end
            plot(len_pre_F0s,pre_F0_mat_temp,'k'); 
            hold on
        end
        
%         for perc_step=1:length(F0_perc)
% %             plot([0 length(pre_F0_mat{1,1})],[tone_perc(:,perc_step) tone_perc(:,perc_step)],'b');
%             plot(len_pre_F0s,tone_perc(:,perc_step),'b');
%             hold on;
%         end
        
        % the steps that we actually generated
        for tone_step=1:size(morphed_stim_test_struct.RMS,1)
            disp(tone_step);
            fff_temp=morphed_stim_test_struct.F0{phon_step,tone_step};
            plot(len_pre_F0s,fff_temp(len_pre_F0s),'r');
            hold on
        end
        
        ylim([300 330]);
        xlim([50 300]);
        title('/tone55/-/tone35/');
        xlabel('采样点');
        ylabel('F0(Hz)');
        saveas(fig,['output/stim_check_F0s\Par',num2str(par),'_P',num2str(phon_step),'.png']);
        close(fig);
    end
    
    %Now plot all F0s:
    fig=figure;
    for phon_step=1:phon_steps
        % the steps that we actually generated
        for tone_step=1:size(morphed_stim_test_struct.RMS,1)
            fff_temp=morphed_stim_test_struct.F0{phon_step,tone_step};
            col_k=(phon_step-1)/(phon_steps-1);
            plot(fff_temp,'Color',[0 0.7*(1-col_k) 0.7*col_k]);
            hold on
        end
    end
    ylim([300 340]);
    xlim([0 350]);
    title('/tone55/-/tone35/');
    xlabel('采样点');
    ylabel('F0(Hz)');
    saveas(fig,['output/stim_check_F0s\ALLF0s_Par',num2str(par),'.png']);
    close(fig);

end


end

%Now plot
% fs=44100;
% for col=1:size(morphed_stim_test_struct.RMS,1)
%     plot(morphed_stim_test_struct.F0{54,col},'k');
%     hold on
% end
% ylim([220 340]);
% title('/ti1/-/ti2/');
% xlabel('采样点');
% ylabel('F0(Hz)');

% %=====================================================================================
% %              现在是加载预实验的morphed_stim_test_struct，并且用于正式实验的5*5 check
% %              check_struct，并且加载DATA那个百分比（xs_perc_struct），三个比较一下，准不准
% %=====================================================================================
% load('morphed_stim_test_struct.mat');
% load('check_struct.mat');
% load('xs_perc_struct.mat');
% 
% load('di1_di2.mat');
% F0_range=bsliang_getvalue_F0range(stim_continuum{1},stim_continuum{end});
% [~,max_pre_F0]=bsliang_getF0(stim_continuum{1},F0_range);
% [~,min_pre_F0]=bsliang_getF0(stim_continuum{end},F0_range);
% 
% %================下面是plot预实验54steps声调的均值图，已经弃之不用=============================
% % pre_F0s=[];
% % for step_tone=1:size(stim_continuum,2)
% %     [~,pre_F0s(step_tone).F0]=bsliang_getF0(stim_continuum{step_tone},F0_range);    
% % end
% %============================================================================================
% 
% fs=44100;
% 
% load('di1_ti1.mat');
% pre_VOTs=zeros(1,size(stim_continuum,2));
% for step_phon=1:size(stim_continuum,2)
%     pre_VOTs(step_phon)=bsliang_getVOT(stim_continuum{step_phon},fs);
%     disp(['Now getting VOT:',num2str(step_phon)]);
% end
% 
% fs = 44100;
% for par=1:par_num
%     pre_F0_mat=morphed_stim_test_struct.F0;
%     exp_F0_mat=check_struct(par).morphed_stim_test_struct.F0;
%     F0_perc=xs_perc_struct(par).xs_perc.tone_old;
%     VOT_perc=xs_perc_struct(par).xs_perc.phon_old;
%     figure;
%     
% 
% %============================================================================================
% %                                       声调
% %============================================================================================
% subplot(1,2,1);
%     
%     %tone continuum:
%     for col=1:size(pre_F0_mat,2)
%         plot(pre_F0_mat{1,col},'k'); %预实验54steps矩阵
%         hold on
%     end
%     
%     tone_perc=min_pre_F0+(1-F0_perc)*(max_pre_F0-min_pre_F0); % 画出根据预实验得出的被试个体化F0均值图
%     for perc_step=1:length(F0_perc)
%         plot([0 length(pre_F0_mat{1,1})],[tone_perc(perc_step) tone_perc(perc_step)],'b');
%         hold on;
%     end
% %     plot([0 length(pre_F0_mat{1,1})],[min_pre_F0 min_pre_F0],'b')
% %     plot([0 length(pre_F0_mat{1,1})],[max_pre_F0 max_pre_F0],'b')
% 
% %     for perc_step=1:size(pre_F0s,2)
% %         plot([0 length(pre_F0_mat{1,1})],[pre_F0s(perc_step).F0 pre_F0s(perc_step).F0],'g');
% %         hold on;
% %     end
% 
%     for col=1:size(exp_F0_mat,2)
%         plot(exp_F0_mat{1,col},'r'); %新实验5steps矩阵
%         hold on
%     end    
%     ylim([220 340]);
%     title('/ti1/-/ti2/');
%     xlabel('采样点');
%     ylabel('F0(Hz)');
% 
% %============================================================================================
% %                                       音位
% %============================================================================================
%     %phon continuum:
%     subplot(1,2,2);
%     
%     for phon_step=1:length(pre_VOTs)
%         plot([pre_VOTs(phon_step) pre_VOTs(phon_step)],[0 1],'k');
%         hold on;
%     end
%     xlim([min(pre_VOTs),max(pre_VOTs)]);
%     
%     phon_perc=min(pre_VOTs)+ VOT_perc*(max(pre_VOTs)-min(pre_VOTs)); % 画出根据预实验得出的被试个体化F0均值图
%     for perc_step=1:length(VOT_perc)
%         plot([phon_perc(perc_step) phon_perc(perc_step)],[0 1],'b');
%         hold on;
%     end
%     
%     %20190627回来改这里
%     pre_VOTs=zeros(1,size(stim_continuum,2));
%     for step_phon=1:size(stim_continuum,2)
%         pre_VOTs(step_phon)=bsliang_getVOT(stim_continuum{step_phon},fs);
%         disp(['Now getting VOT:',num2str(step_phon)]);
%     end
% end
