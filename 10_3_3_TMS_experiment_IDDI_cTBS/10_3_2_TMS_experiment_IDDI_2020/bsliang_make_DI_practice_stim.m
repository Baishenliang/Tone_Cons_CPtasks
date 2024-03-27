function bsliang_make_DI_practice_stim()
load('input/diti_stim_for_train.mat');
stim_lst={'di1','di2','ti1','ti2'};
for i=1:4
    for j=1:4
        sound=[stim_for_train{1,i};zeros(44100*0.5,1);stim_for_train{1,j}];
        audiowrite(['DI_practice/',stim_lst{1,i},'_',stim_lst{1,j},'.wav'],sound,44100);
    end
end
