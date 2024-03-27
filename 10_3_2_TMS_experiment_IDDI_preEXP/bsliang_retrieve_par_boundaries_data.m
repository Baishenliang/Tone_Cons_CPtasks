function [threshold_struct_mat,threshold_struct_cell]=bsliang_retrieve_par_boundaries_data(DATA,par)

    % threshold_struct的四列分别是：'ba1_ba2','ba2_pa2','pa1_pa2','ba1_pa1'
    % threshold_struct的两行分别是：（1）lower_bound, （2）upper_bound
    
    % 输出两种形式:
    % threshold_struct_mat：矩阵形式
    % threshold_struct_cell：元胞形式
    
    threshold_struct_mat = zeros(2,4);
    threshold_struct_cell = {[],[],[],[];[],[],[],[];'ba1_ba2','ba2_pa2','pa1_pa2','ba1_pa1'};
    
    for threshold_steps=1:4%size(threshold_struct,2)
        this_step_data = DATA(par).data(threshold_steps);
        lower_bounds = cell2mat(this_step_data.threshold_boundaries{1,1});
        upper_bounds = cell2mat(this_step_data.threshold_boundaries{1,2});
        lower_bounds_2 = lower_bounds(~isnan(lower_bounds));
        upper_bounds_2 = upper_bounds(~isnan(upper_bounds));
        lower_bound = lower_bounds_2(end);
        upper_bound = upper_bounds_2(end);
        
        threshold_struct_mat(1,threshold_steps) = lower_bound;
        threshold_struct_mat(2,threshold_steps) = upper_bound;
        threshold_struct_cell(1,threshold_steps) = lower_bound;
        threshold_struct_cell(2,threshold_steps) = upper_bound;
    end