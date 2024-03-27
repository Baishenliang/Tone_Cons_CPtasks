function new_sig = bsliang_add_envelope(org_sig,Fs_Hz,envelope_s)
Ts = 1/Fs_Hz;

new_sig = org_sig';

rise=(0:Ts:envelope_s)*(1/envelope_s);
fall=(envelope_s:-Ts:0)*(1/envelope_s);

new_sig(1,1:size(rise,2))=new_sig(1,1:size(rise,2)).*rise;
new_sig(1,end-size(fall,2)+1:end)=new_sig(1,end-size(fall,2)+1:end).*fall;
