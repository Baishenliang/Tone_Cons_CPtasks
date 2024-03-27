function [noiseout,k]=bsliang_adjustnoiseSNR(signal0,noise0,snr0)
    % 【个体化SNR】灵感来自预实验中校正range之后校正SNR函数的公式：
    % snrkk=10*log10((rms(signalkk)/rms(noisekk))^2);
    bsliang = @(k)(10*log10((rms(k*signal0)/rms(noise0))^2)-snr0);
    % k值转换：rms(k*signal)/rms(noise)=rms(signal)/rms(noise/k)
    options = optimset('TolX',0.00000000000000000001);
    k=fzero(bsliang,[0.01 100],options);
    % k=0.01是为了避免k==0时造成函数值无穷，此时SNR=-44dB，已经远低于被试可听范围，可接受
    % k=100时SNR=36dB，已经远高于被试听阈
    noiseout=noise0/k;