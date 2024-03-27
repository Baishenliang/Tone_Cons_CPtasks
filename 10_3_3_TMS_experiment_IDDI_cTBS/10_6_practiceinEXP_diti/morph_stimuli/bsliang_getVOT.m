function VOT = bsliang_getVOT(data,fs)

tone_env_org=envelope(data,600,'rms'); %得出包络线

w=600;
sdlst=zeros(1,w/2);
for i=w/2+1:length(tone_env_org)-w/2+1
sdlst=[sdlst,std(tone_env_org(i-w/2:i-1+w/2))];
end
sdlst=[sdlst,zeros(1,w/2)];

[fpeak,xi]=findpeaks(sdlst,'SortStr','descend');

% plot(data);
% hold on
% plot(tone_env_org);
% plot(sdlst);
% plot(xi(1),fpeak(1),'ro');

VOT=xi(1)/fs;
