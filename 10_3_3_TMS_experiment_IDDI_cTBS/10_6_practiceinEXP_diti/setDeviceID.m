function deviceID=setDeviceID(mode)
InitializePsychSound;
device = PsychPortAudio('GetDevices') ;
    if isequal(mode,'subject')
        deviceID=3;%14;%9;%4;%21;%5
    elseif isequal(mode,'experimenter')
        deviceID=3;14;%9;%4;%21;
    end
%�����Ҫϵͳ�Զ�������Ϊ0�������Ҫ�Լ����ã���GetDevice��ѡ�ӳ���С��index��
end