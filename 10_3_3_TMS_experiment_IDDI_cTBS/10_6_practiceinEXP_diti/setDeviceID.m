function deviceID=setDeviceID(mode)
InitializePsychSound;
device = PsychPortAudio('GetDevices') ;
    if isequal(mode,'subject')
        deviceID=3;%14;%9;%4;%21;%5
    elseif isequal(mode,'experimenter')
        deviceID=3;14;%9;%4;%21;
    end
%如果需要系统自动调，设为0；如果需要自己设置，先GetDevice再选延迟最小的index。
end