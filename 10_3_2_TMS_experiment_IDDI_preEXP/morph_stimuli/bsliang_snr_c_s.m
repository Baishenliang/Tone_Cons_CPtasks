function SNR=bsliang_snr_c_s(c,s)
% calculte SNR by using noise-masked s and s
% c=noise-masked s
% s=signal
if length(c)==length(s)
    lens=length(c);
    SNR=10*log10(rms(s)^2/(rms(c)^2-2*(sum(c.*s))/lens+rms(s)^2));
end