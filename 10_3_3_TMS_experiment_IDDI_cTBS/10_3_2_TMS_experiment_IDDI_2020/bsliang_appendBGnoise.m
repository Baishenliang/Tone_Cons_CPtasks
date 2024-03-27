function SIG=bsliang_appendBGnoise(signal,noise,fs)

envelope_s = 0.01; % ��������10ms
len_sig = length(signal);
len_env = ceil(envelope_s*fs); % �������糤��

noise_sp = randi(length(noise)-(len_sig+2*len_env)); 
noise_new = noise(noise_sp:len_sig+2*len_env+noise_sp-1);
% ���ѡȡ����������һ���֣���Ϊ���������ֲ������ȣ����Բ���ֻѡȡ��ǰ��һ��

% test��
% disp(10*log10((rms(signal)/rms(noise_new))^2));

noise_new_env = bsliang_add_envelope(noise_new,fs,envelope_s);
noise_new_env = noise_new_env';
% ������������

signal_new = [zeros(len_env,1);signal;zeros(len_env,1)];
SIG=signal_new+noise_new_env;

