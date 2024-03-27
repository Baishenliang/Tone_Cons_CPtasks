function bsliang_indSNRandTEST_Main(par_code_in)
        %% 加载一些文件
         load DATA
         load(['ind_stimmat',filesep,num2str(par_code_in),'_par_EXPdata']);
         signalkk=par_EXPdata.T_old_BEHAV{1,1};
         [noisekk,~]=audioread(DATA(par_code_in).Id_Di.noise_filename{1,1});
        
        %% 20210309新增：个体化测量SNR
        % 对被试的个体化SNR-正确率曲线进行测定
        
        % 正常操作下step15（选取range的step1和step5）和step24（选取range的step2和step4）只能选一种
        TONEtestSNRsteps=[2 0 -2 -4 -6 -8 -10 -12 -14 -16];
        bsliang_constSNR(par_code_in,DATA(par_code_in).par_info.name,1,TONEtestSNRsteps,'step15');
        perc_tone=input('请输入声调SNR水平（一般是0.85）：');
        indSNRtone=bsliang_calculated_indSNR(par_code_in,1,perc_tone,'step15');
        PHONtestSNRsteps=[12 8 5 2 0 -2 -4 -6 -9 -12];
        bsliang_constSNR(par_code_in,DATA(par_code_in).par_info.name,2,PHONtestSNRsteps,'step15');
        perc_phon=input('请输入声母SNR水平（一般是0.85）：');
        indSNRphon=bsliang_calculated_indSNR(par_code_in,2,perc_phon,'step15');

%       TONEtestSNRsteps=[-2 -4 -6 -8 -10 -12 -14 -17 -21];
%       bsliang_constSNR(par_code_in,DATA(par_code_in).par_info.name,1,TONEtestSNRsteps,'step24');
%       indSNRtone=bsliang_calculated_indSNR(par_code_in,1,0.85,'step24');
%       PHONtestSNRsteps=[8 6 4 2 0 -2 -4 -6 -8];
%       bsliang_constSNR(par_code_in,DATA(par_code_in).par_info.name,2,PHONtestSNRsteps,'step24');
%       indSNRphon=bsliang_calculated_indSNR(par_code_in,2,0.85,'step24');
        
        disp(['Automatic calculated individual tone SNR=',num2str(indSNRtone),'; phon SNR=',num2str(indSNRphon)]);

        is_adjustSNR=input('是否手动调整SNR？ 1-是 0-否：');
        if is_adjustSNR
            indSNRtone=input('Please input self-defined tone SNR:');
            indSNRphon=input('Please input self-defined phon SNR:');
        end
        
        close all
        
        [~,SNRtone_k]=bsliang_adjustnoiseSNR(signalkk,noisekk,indSNRtone); %noiseout=noise0/k;
        [~,SNRphon_k]=bsliang_adjustnoiseSNR(signalkk,noisekk,indSNRphon); %noiseout=noise0/k;
        
        disp(['Automatic calculated individual tone SNR K=',num2str(SNRtone_k),'; phon SNR K =',num2str(SNRphon_k)]);
        disp(['PLEASE CHECK: RMS raw noise = ',num2str(rms(noisekk)),' RMS raw signal = ', num2str(rms(signalkk)),' SNR = 10*log10((rms(k*signal)/rms(noise))^2)']);
        
        DATA(par_code_in).def_range.indSNRs_k =[SNRtone_k SNRphon_k];
        DATA(par_code_in).practice.indSNRs_k = [SNRtone_k SNRphon_k SNRtone_k SNRphon_k];
        DATA(par_code_in).Id_Di.indSNRs_k =    [SNRtone_k SNRphon_k SNRtone_k SNRphon_k SNRtone_k SNRphon_k SNRtone_k SNRphon_k];
        
        save DATA DATA
        clear DATA
        
        confirm_tic=tic;
        % BSLiang 20201011 新版的不要求被试第一次来就做practice了
         lbsCP2_start_withinCOND(par_code_in,'_practice_',1,1);
         lbsCP2_start_withinCOND(par_code_in,'_practice_',2,1);
%         lbsCP2_start_withinCOND(par_code_in,'_practice_',3,1);
%         lbsCP2_start_withinCOND(par_code_in,'_practice_',4,1);
        confirm_toc=toc(confirm_tic);
        disp(['检验个体化矩阵消耗',num2str(confirm_toc/60),'分钟']);