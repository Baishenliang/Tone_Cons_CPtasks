function indSNR=bsliang_calculated_indSNR(subj,task,diff_level,steptags)

%% ��ȡ��������
if task==1 % �����ж�
    taskTag='TONE';
elseif task==2 % ��ĸ�ж�
    taskTag='PHON';
end
load(['results',filesep,'NO_',num2str(subj),'_constSNR_',taskTag]);
load(['results',filesep,'NO_',num2str(subj),'_constSNR_',taskTag,'_SNRs']);

scores=nan(1,length(SNRs));
rts=scores;
for SNRstep=1:length(SNRs)
    TRIAL_SNR=TRIALS(:,TRIALS(1,:)==SNRstep);
    scores(SNRstep)=sum(TRIAL_SNR(2,:)==TRIAL_SNR(3,:))/size(TRIAL_SNR,2);
    rts(SNRstep)=mean(TRIAL_SNR(4,:));
end

% SNR_logistics=@(paras,X) paras(1)+paras(2)./(1+exp(-1*paras(3)*(X-paras(4))));
% paras = lsqcurvefit(SNR_logistics,[0 1 1/range(SNRs) median(SNRs)],SNRs,scores,0.5,1);
% fitted_scores=SNR_logistics(paras,SNRs); % 0.5����Ϊ�������ˮƽ��0.5������1

if isequal(steptags,'step24')
    % step24ʱ������ȷ��Ϊ0.75
    SNR_logistics=@(paras,X) (0.75-0.5)*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+0.5;
elseif isequal(steptags,'step15')
    % step15ʱ������ȷ��Ϊ1
    SNR_logistics=@(paras,X) (1-0.5)*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+0.5;
end

paras = lsqcurvefit(SNR_logistics,[1/range(SNRs) median(SNRs)],SNRs,scores);
fitted_scores=SNR_logistics(paras,SNRs); % 0.5����Ϊ�������ˮƽ��0.5������1

func2indSNR = @(indSNR)SNR_logistics(paras,indSNR)-diff_level;
options = optimset('TolX',0.00000000000000000001);
indSNR=fzero(func2indSNR,[-100 100],options);

figure;
plot(SNRs,scores,'ko');
hold on
plot(SNRs,fitted_scores,'r-');
plot(SNRs,rts,'b-');
legend('raw scores','fitted scores','RTs');