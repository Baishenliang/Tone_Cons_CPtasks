function STIM_new=bsliang_PTmatrix2PTcontin(STIM)
% ��5��5������-��ĸ���������ת��Ϊ5steps����������ĸ���������
% ��������ȫ����d��������ĸȫ����һ��
STIM_new=STIM;
maxstep=max(unique(cell2mat(STIM_new(2,:))));
for token=maxstep+1:size(STIM,2)
STIM_new{1,token}=STIM{1,STIM{2,token}};% ��ԭ���ĵڶ�ά�ȵڶ�step��ʼ������token�����һstep���������
STIM_new{4,token}=1;
end
% ���Ų��ԣ�
% for s=1:size(STIM_new,2)
% sound(STIM_new{1,s},44100);
% WaitSecs(0.5)
% end