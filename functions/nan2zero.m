function [arr_out] = nan2zero(arr_in)
% Set nan values to zeros
 arr_out = arr_in;
 arr_out(find(isnan(arr_in))) = 0;
