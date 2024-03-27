function k_signal=bsliang_noiseSNR(RMS_signal,RMS_noise,SNRlst,noisemask_raw,fs,Tag)
    k_max = sqrt(10^((-1)*SNRlst(end)/10))*(RMS_signal/RMS_noise);
    if k_max>=1
        disp('原始信号振幅过大，需要调整');
        bsliang = @(k_signal) (sqrt(10^((-1)*SNRlst(end)/10))*((k_signal*RMS_signal)/RMS_noise)-0.999);
        options = optimset('TolX',0.0000000001); %per_Rate=0~1, 0.001=27/1000 steps
        k_signal=fzero(bsliang,[0 1],options);
    else
        k_signal=1;
    end
    k_noise_lst=sqrt(10.^((-1)*SNRlst/10))*((k_signal*RMS_signal)/RMS_noise);
    for kn=1:length(k_noise_lst)
        filename=[Tag,'_',num2str(SNRlst(kn)),'dB_SSN.wav'];
        filename=strrep(filename,'-','m');
        audiowrite(filename,k_noise_lst(kn)*noisemask_raw,fs);
    end