function [dprime,c]=YQ_get_dprime_DI(data_indiv)
% overview of what "stimulus categories" there are in the data
    stim_cat = unique(data_indiv(:,1));
    % creating keys for what stim cats go together in what comp units
    stim_diff_key = [13 31; 24 42; 35 53];
    stim_same_key = [11 33; 22 44; 33 53];
    
    j=1;
    % looping over comp units
    for i = 1:size(stim_diff_key,1)
        diffs(j,i) = mean(data_indiv(ismember(data_indiv(:,1),stim_diff_key(i,:)),2));
        sames(j,i) = mean(data_indiv(ismember(data_indiv(:,1),stim_same_key(i,:)),2));
        comp_unit(j,i) = diffs(j,i)*0.5 + sames(j,i)*0.5;
        % 
        if diffs(j,i) == 1
            diffs_corr(j,i) = diffs(j,i)-1/(2*length(data_indiv(ismember(data_indiv(:,1),stim_diff_key(i,:)),2)));
        elseif diffs(j,i) == 0
            diffs_corr(j,i) = diffs(j,i)+1/(2*length(data_indiv(ismember(data_indiv(:,1),stim_diff_key(i,:)),2)));
        else
            diffs_corr(j,i) = diffs(j,i);
        end
        if sames(j,i) == 1
            sames_corr(j,i) = sames(j,i)-1/(2*length(data_indiv(ismember(data_indiv(:,1),stim_same_key(i,:)),2)));
        elseif sames(j,i) == 0
            sames_corr(j,i) = sames(j,i)+1/(2*length(data_indiv(ismember(data_indiv(:,1),stim_same_key(i,:)),2)));
        else
            sames_corr(j,i) = sames(j,i);
        end
        dprime(j,i) = norminv(diffs_corr(j,i),0,1)-norminv(1-sames_corr(j,i),0,1);
        c(j,i) = -0.5 * (norminv(diffs_corr(j,i),0,1)+norminv(1-sames_corr(j,i),0,1)); % criterion
    end