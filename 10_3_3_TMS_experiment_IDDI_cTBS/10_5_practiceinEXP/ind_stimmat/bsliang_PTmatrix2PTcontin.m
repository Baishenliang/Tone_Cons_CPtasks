function STIM_new=bsliang_PTmatrix2PTcontin(STIM)
% 将5×5的声调-声母连续体矩阵转换为5steps的声调或声母连续体矩阵：
% 对于声调全部用d，对于声母全部用一声
STIM_new=STIM;
maxstep=max(unique(cell2mat(STIM_new(2,:))));
for token=maxstep+1:size(STIM,2)
STIM_new{1,token}=STIM{1,STIM{2,token}};% 从原本的第二维度第二step开始，按照token赋予第一step里面的音节
STIM_new{4,token}=1;
end
% 播放测试：
% for s=1:size(STIM_new,2)
% sound(STIM_new{1,s},44100);
% WaitSecs(0.5)
% end