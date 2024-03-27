function [noiseout,k]=bsliang_adjustnoiseSNR(signal0,noise0,snr0)
    % �����廯SNR���������Ԥʵ����У��range֮��У��SNR�����Ĺ�ʽ��
    % snrkk=10*log10((rms(signalkk)/rms(noisekk))^2);
    bsliang = @(k)(10*log10((rms(k*signal0)/rms(noise0))^2)-snr0);
    % kֵת����rms(k*signal)/rms(noise)=rms(signal)/rms(noise/k)
    options = optimset('TolX',0.00000000000000000001);
    k=fzero(bsliang,[0.01 100],options);
    % k=0.01��Ϊ�˱���k==0ʱ��ɺ���ֵ�����ʱSNR=-44dB���Ѿ�Զ���ڱ��Կ�����Χ���ɽ���
    % k=100ʱSNR=36dB���Ѿ�Զ���ڱ�������
    noiseout=noise0/k;