function DATA=lbsCP2_loadDATA()
try
    load('DATA.mat');
catch
    DATA=[];
    lbsCP2_saveDATA(DATA);
end