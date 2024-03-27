function SIG=bsliang_appendBGnoise(signal,noise,fs)

envelope_s = 0.01; % 升降包络10ms
len_sig = length(signal);
len_env = ceil(envelope_s*fs); % 升降包络长度

noise_sp = randi(length(noise)-(len_sig+2*len_env)); 
noise_new = noise(noise_sp:len_sig+2*len_env+noise_sp-1);
% 随机选取语谱噪音的一部分，因为语谱噪音分布不均匀，所以不能只选取最前面一段

% test：
% disp(10*log10((rms(signal)/rms(noise_new))^2));

noise_new_env = bsliang_add_envelope(noise_new,fs,envelope_s);
noise_new_env = noise_new_env';
% 赋予升降包络

signal_new = [zeros(len_env,1);signal;zeros(len_env,1)];
SIG=signal_new+noise_new_env;

