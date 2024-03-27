function [threshold_struct_mat,threshold_struct_cell,threshold_struct_std_mat]=bsliang_retrieve_par_boundaries_data(DATA,par)

    % threshold_struct的四列分别是：'di1_di2','di2_ti2','ti1_ti2','di1_ti1'
    % threshold_struct的两行分别是：（1）lower_bound, （2）upper_bound
    
    % 输出两种形式:
    % threshold_struct_mat：矩阵形式
    % threshold_struct_cell：元胞形式
    
    threshold_struct_mat = zeros(2,4);
    threshold_struct_std_mat = zeros(2,4);
    threshold_struct_cell = {[],[],[],[];[],[],[],[];'di1_di2','di2_ti2','ti1_ti2','di1_ti1'};
    
    rep_test = size(DATA(par).data,1);
    
    for threshold_steps=1:4%size(threshold_struct,2)
        
        lower_bound = zeros(1,rep_test);
        upper_bound = zeros(1,rep_test);        
        
        for rep_num=1:rep_test
            
            this_step_data = DATA(par).data(rep_num,threshold_steps);
            lower_bounds = cell2mat(this_step_data.threshold_boundaries{1,1});
            upper_bounds = cell2mat(this_step_data.threshold_boundaries{1,2});
            lower_bounds_2 = lower_bounds(~isnan(lower_bounds));
            upper_bounds_2 = upper_bounds(~isnan(upper_bounds));
            lower_bound(1,rep_num) = lower_bounds_2(end);
            upper_bound(1,rep_num) = upper_bounds_2(end);

        end
        
        [lw_bound,~,lw_bound_std] = bsliang_getmindiffcomb(lower_bound,2);
        [up_bound,~,up_bound_std] = bsliang_getmindiffcomb(upper_bound,2);
        
        threshold_struct_mat(1,threshold_steps) = lw_bound;
        threshold_struct_mat(2,threshold_steps) = up_bound;
        threshold_struct_std_mat(1,threshold_steps) = lw_bound_std;
        threshold_struct_std_mat(2,threshold_steps) = up_bound_std;
        threshold_struct_cell{1,threshold_steps} = lw_bound;
        threshold_struct_cell{2,threshold_steps} = up_bound;
        
    end