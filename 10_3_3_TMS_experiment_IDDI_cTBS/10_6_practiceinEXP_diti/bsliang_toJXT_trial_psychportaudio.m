InitializePsychSound;

deviceID=setDeviceID('subject');
param = PsychPortAudio('Open',deviceID,1+8,2,[],2);          % ���豸����Щ��������ô��OK��
soundBuffer=cell(1,size(stimfile,2)); %���Ǵ��滺���˵������ļ���buffer
% ��һ������slaveID���ڶ�������buffer
for soundID=1:size(stimfile,2)
   soundBuffer{1,soundID}=PsychPortAudio('OpenSlave',param,1,2);
   %soundBuffer{2,soundID}=PsychPortAudio('CreateBuffer', soundBuffer{1,soundID},[stimfile{1,soundID}';stimfile{1,soundID}']);
   PsychPortAudio('FillBuffer',soundBuffer{1,soundID}, [leftear_k*stimfile{1,soundID}';stimfile{1,soundID}']);
end

PsychPortAudio('Start',param,0,0);

PsychPortAudio('Start',soundBuffer{1,currentstep(direction)},1,0);
pause(0.5);
PsychPortAudio('Stop',soundBuffer{1,currentstep(direction)});

PsychPortAudio('Stop',param);
PsychPortAudio('Close',param);